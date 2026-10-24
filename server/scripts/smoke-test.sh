#!/usr/bin/env bash
# Smoke test against a running ShopBandit PocketBase.
# Usage: server/scripts/smoke-test.sh [http://127.0.0.1:8090]
# Needs: curl, jq. Creates throw-away users with random e-mail addresses.
set -euo pipefail

PB="${1:-http://127.0.0.1:8090}"
RUN="$(date +%s)$RANDOM"
PW='Test1234!x'
fail() { echo "FAIL: $*" >&2; exit 1; }
ok() { echo "ok   $*"; }

req() { # method path token [json]
  local m="$1" p="$2" t="$3" d="${4:-}"
  curl -s -X "$m" "$PB$p" -H 'content-type: application/json' ${t:+-H "Authorization: $t"} ${d:+-d "$d"}
}
code() { # same as req, prints only the HTTP status
  local m="$1" p="$2" t="$3" d="${4:-}"
  curl -s -o /dev/null -w '%{http_code}' -X "$m" "$PB$p" -H 'content-type: application/json' ${t:+-H "Authorization: $t"} ${d:+-d "$d"}
}
signup() { # email name -> prints token
  req POST /api/collections/users/records "" "{\"email\":\"$1\",\"password\":\"$PW\",\"passwordConfirm\":\"$PW\",\"name\":\"$2\"}" >/dev/null
  sleep 3 # *:auth rate limit
  req POST /api/collections/users/auth-with-password "" "{\"identity\":\"$1\",\"password\":\"$PW\"}" | jq -r .token
}
me() { req POST /api/collections/users/auth-refresh "$1" | jq -r ".record.$2"; }
pbid() { (LC_ALL=C tr -dc 'a-z0-9' </dev/urandom | head -c 15) 2>/dev/null || true; }

curl -sf "$PB/api/health" >/dev/null || fail "health"
ok health

[ "$(code POST /api/collections/users/records "" "{\"email\":\"weak$RUN@example.com\",\"password\":\"weakpass1\",\"passwordConfirm\":\"weakpass1\"}")" = 400 ] || fail "weak password accepted"
ok "weak password rejected"
sleep 3

A=$(signup "a$RUN@example.com" Anna); [ -n "$A" ] && [ "$A" != null ] || fail "signup A"
sleep 3
B=$(signup "b$RUN@example.com" Bert); [ "$B" != null ] || fail "signup B"
HA=$(me "$A" household); HB=$(me "$B" household)
[ -n "$HA" ] && [ -n "$HB" ] && [ "$HA" != "$HB" ] || fail "own households ($HA/$HB)"
ok "own household per user"

[ "$(code PATCH "/api/collections/users/records/$(me "$B" id)" "$B" "{\"household\":\"$HA\"}")" != 200 ] || fail "user could change household"
ok "household not writable by user"

CI=$(pbid)
[ "$(code POST /api/collections/catalog_items/records "$A" "{\"id\":\"$CI\",\"household\":\"$HA\",\"name\":\"Milch\",\"name_normalized\":\"milch\"}")" = 200 ] || fail "catalog create"
E1=$(pbid)
[ "$(code POST /api/collections/list_entries/records "$A" "{\"id\":\"$E1\",\"household\":\"$HA\",\"catalog_item\":\"$CI\",\"quantity\":\"2\",\"added_by\":\"$(me "$A" id)\"}")" = 200 ] || fail "entry create"
ok "client ids for catalog + entry"

[ "$(code POST /api/collections/catalog_items/records "$B" "{\"household\":\"$HA\",\"name\":\"X\",\"name_normalized\":\"x\"}")" = 400 ] || fail "B wrote into A's household"
[ "$(req GET /api/collections/list_entries/records "$B" | jq .totalItems)" = 0 ] || fail "B sees A's entries"
ok "households isolated"

[ "$(code PATCH "/api/collections/catalog_items/records/$CI" "$A" '{"purchase_count+":1}')" = 200 ] || fail "increment"
[ "$(req GET "/api/collections/catalog_items/records/$CI" "$A" | jq .purchase_count)" = 1 ] || fail "count"
ok "purchase counter"

[ "$(code POST /api/shopbandit/invites/create "$B" '{}')" = 200 ] || fail "B is admin of own household"
INV=$(req POST /api/shopbandit/invites/create "$A" '{}' | jq -r .token)
[ ${#INV} = 24 ] || fail "invite token"
[ "$(req POST /api/shopbandit/invites/check "$B" "{\"token\":\"$INV\"}" | jq .discards_own)" = true ] || fail "invite check"
[ "$(code POST /api/shopbandit/invites/accept "$B" "{\"token\":\"$INV\"}")" = 200 ] || fail "accept"
[ "$(me "$B" household)" = "$HA" ] || fail "B not in A's household"
[ "$(code GET "/api/collections/households/records/$HB" "$A")" = 404 ] || fail "old household still visible"
[ "$(req GET /api/collections/list_entries/records "$B" | jq .totalItems)" = 1 ] || fail "B sees shared list"
[ "$(code POST /api/shopbandit/invites/accept "$B" "{\"token\":\"$INV\"}")" = 400 ] || fail "invite reusable"
ok "invite accept (one-time)"

[ "$(code POST /api/shopbandit/invites/create "$B" '{}')" = 403 ] || fail "member created invite"
[ "$(req GET /api/collections/users/records "$B" | jq .totalItems)" = 2 ] || fail "members visible"
ok "member rights"

INV2=$(req POST /api/shopbandit/invites/create "$A" '{}' | jq -r '.id + " " + .token')
[ "$(code POST /api/shopbandit/invites/revoke "$A" "{\"id\":\"${INV2%% *}\"}")" = 200 ] || fail "revoke"
[ "$(code POST /api/shopbandit/invites/check "$B" "{\"token\":\"${INV2##* }\"}")" = 400 ] || fail "revoked invite valid"
ok "invite revoke"

[ "$(code POST /api/collections/push_endpoints/records "$B" "{\"user\":\"$(me "$B" id)\",\"endpoint_url\":\"http://127.0.0.1:8000/x\"}")" = 400 ] || fail "internal push endpoint accepted"
ok "push endpoint must be https"

[ "$(code POST /api/shopbandit/household/remove "$A" "{\"user\":\"$(me "$B" id)\"}")" = 200 ] || fail "remove"
NB=$(me "$B" household); [ -n "$NB" ] && [ "$NB" != "$HA" ] || fail "removed member got no new household"
[ "$(code POST /api/shopbandit/household/leave "$A" '{}')" = 400 ] || fail "single member could leave"
ok "remove member / leave"

echo "ALL OK"
