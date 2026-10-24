/// <reference path="../pb_data/types.d.ts" />

// ---------------------------------------------------------------------------
// Settings from the environment (applied on every start)
// ---------------------------------------------------------------------------
onBootstrap((e) => {
  e.next()
  const env = (k) => $os.getenv(k)
  const s = e.app.settings()

  s.meta.appName = "ShopBandit"
  if (env("SHOPBANDIT_PUBLIC_URL")) s.meta.appURL = env("SHOPBANDIT_PUBLIC_URL")
  if (env("SMTP_HOST")) {
    s.smtp.enabled = true
    s.smtp.host = env("SMTP_HOST")
    s.smtp.port = parseInt(env("SMTP_PORT") || "587", 10)
    s.smtp.username = env("SMTP_USERNAME")
    s.smtp.password = env("SMTP_PASSWORD")
    s.smtp.tls = env("SMTP_TLS") === "true"
    s.meta.senderAddress = env("SMTP_SENDER") || s.meta.senderAddress
    s.meta.senderName = "ShopBandit"
  }
  if (env("SHOPBANDIT_TRUSTED_PROXY_HEADER")) s.trustedProxy.headers = [env("SHOPBANDIT_TRUSTED_PROXY_HEADER")]

  s.rateLimits.enabled = true
  s.rateLimits.rules = [
    { label: "*:auth", audience: "", duration: 3, maxRequests: 2 },
    { label: "*:create", audience: "@guest", duration: 5, maxRequests: 2 },
    { label: "/api/collections/users/request-", audience: "", duration: 60, maxRequests: 5 },
    { label: "/api/collections/users/confirm-", audience: "", duration: 60, maxRequests: 10 },
    { label: "/api/shopbandit/invites/", audience: "", duration: 60, maxRequests: 10 },
    { label: "/api/", audience: "", duration: 10, maxRequests: 300 },
  ]
  e.app.save(s)
})

// ---------------------------------------------------------------------------
// Password rule (server side, mirrors the app)
// ---------------------------------------------------------------------------
onRecordCreateRequest((e) => {
  const sb = require(`${__hooks}/shopbandit.js`)
  sb.assertPassword(e.requestInfo().body["password"])
  // household is assigned by the server only
  e.record.set("household", "")
  e.next()
}, "users")

onRecordUpdateRequest((e) => {
  const body = e.requestInfo().body
  if (body["password"] !== undefined) {
    require(`${__hooks}/shopbandit.js`).assertPassword(body["password"])
  }
  e.next()
}, "users")

onRecordConfirmPasswordResetRequest((e) => {
  require(`${__hooks}/shopbandit.js`).assertPassword(e.requestInfo().body["password"])
  e.next()
}, "users")

// Every new user starts in an own household.
onRecordAfterCreateSuccess((e) => {
  const sb = require(`${__hooks}/shopbandit.js`)
  sb.createOwnHousehold(e.app, e.record)
  e.next()
}, "users")

// ---------------------------------------------------------------------------
// Invites
// ---------------------------------------------------------------------------
routerAdd("POST", "/api/shopbandit/invites/create", (e) => {
  const sb = require(`${__hooks}/shopbandit.js`)
  const hid = e.auth.getString("household")
  const h = hid ? $app.findRecordById("households", hid) : null
  if (!h || h.getString("owner") !== e.auth.id) throw new ForbiddenError("Only the household admin can do this.")

  const token = sb.newInviteToken()
  const expires = new Date(Date.now() + sb.INVITE_TTL_HOURS * 3600 * 1000)
  const inv = new Record($app.findCollectionByNameOrId("invites"))
  inv.set("household", h.id)
  inv.set("token_hash", sb.hashToken(token))
  inv.set("expires", expires.toISOString())
  inv.set("created_by", e.auth.id)
  $app.save(inv)
  return e.json(200, { id: inv.id, token: token, expires: expires.toISOString(), household_name: h.getString("name") })
}, $apis.requireAuth("users"))

routerAdd("POST", "/api/shopbandit/invites/revoke", (e) => {
  const hid = e.auth.getString("household")
  const h = hid ? $app.findRecordById("households", hid) : null
  if (!h || h.getString("owner") !== e.auth.id) throw new ForbiddenError("Only the household admin can do this.")
  const id = e.requestInfo().body["id"] || ""
  const inv = $app.findFirstRecordByFilter("invites", "id = {:id} && household = {:h}", { id: id, h: h.id })
  inv.set("revoked", true)
  $app.save(inv)
  return e.json(200, { ok: true })
}, $apis.requireAuth("users"))

// Preview for the confirmation dialog: which household, how many members.
routerAdd("POST", "/api/shopbandit/invites/check", (e) => {
  const sb = require(`${__hooks}/shopbandit.js`)
  const inv = sb.findValidInvite($app, e.requestInfo().body["token"])
  const h = $app.findRecordById("households", inv.getString("household"))
  const ownHid = e.auth.getString("household")
  const own = ownHid ? sb.members($app, ownHid) : []
  return e.json(200, {
    household_name: h.getString("name"),
    members: sb.members($app, h.id).length,
    already_member: ownHid === h.id,
    // true when joining deletes the current (single-person) household with its list
    discards_own: ownHid !== h.id && own.length <= 1,
  })
}, $apis.requireAuth("users"))

routerAdd("POST", "/api/shopbandit/invites/accept", (e) => {
  const sb = require(`${__hooks}/shopbandit.js`)
  const token = e.requestInfo().body["token"]
  let householdId = ""
  $app.runInTransaction((tx) => {
    const inv = sb.findValidInvite(tx, token)
    householdId = inv.getString("household")
    const user = tx.findRecordById("users", e.auth.id)
    if (user.getString("household") === householdId) throw new BadRequestError("already_member")
    sb.detachFromHousehold(tx, user)
    user.set("household", householdId)
    tx.save(user)
    inv.set("used", true)
    tx.save(inv)
  })
  return e.json(200, { household: householdId })
}, $apis.requireAuth("users"))

// ---------------------------------------------------------------------------
// Membership
// ---------------------------------------------------------------------------
routerAdd("POST", "/api/shopbandit/household/leave", (e) => {
  const sb = require(`${__hooks}/shopbandit.js`)
  let newId = ""
  $app.runInTransaction((tx) => {
    const user = tx.findRecordById("users", e.auth.id)
    if (sb.members(tx, user.getString("household")).length <= 1) throw new BadRequestError("only_member")
    sb.detachFromHousehold(tx, user)
    newId = sb.createOwnHousehold(tx, user).id
  })
  return e.json(200, { household: newId })
}, $apis.requireAuth("users"))

routerAdd("POST", "/api/shopbandit/household/remove", (e) => {
  const sb = require(`${__hooks}/shopbandit.js`)
  const hid = e.auth.getString("household")
  const h = hid ? $app.findRecordById("households", hid) : null
  if (!h || h.getString("owner") !== e.auth.id) throw new ForbiddenError("Only the household admin can do this.")
  const userId = e.requestInfo().body["user"] || ""
  if (userId === e.auth.id) throw new BadRequestError("cannot_remove_self")
  $app.runInTransaction((tx) => {
    const member = tx.findFirstRecordByFilter("users", "id = {:u} && household = {:h}", { u: userId, h: h.id })
    sb.detachFromHousehold(tx, member)
    sb.createOwnHousehold(tx, member)
  })
  return e.json(200, { ok: true })
}, $apis.requireAuth("users"))

// ---------------------------------------------------------------------------
// Push (UnifiedPush endpoints, bundled once per minute)
// ---------------------------------------------------------------------------
onRecordCreateRequest((e) => {
  const sb = require(`${__hooks}/shopbandit.js`)
  if (!sb.endpointAllowed(e.record.getString("endpoint_url"))) {
    throw new BadRequestError("endpoint_not_allowed")
  }
  e.next()
}, "push_endpoints")

onRecordUpdateRequest((e) => {
  const sb = require(`${__hooks}/shopbandit.js`)
  if (!sb.endpointAllowed(e.record.getString("endpoint_url"))) {
    throw new BadRequestError("endpoint_not_allowed")
  }
  e.next()
}, "push_endpoints")

cronAdd("shopbandit_push", "* * * * *", () => {
  require(`${__hooks}/shopbandit.js`).sendPendingPushes($app)
})

// Old invites are of no use after expiry.
cronAdd("shopbandit_invite_cleanup", "17 3 * * *", () => {
  const old = new Date(Date.now() - 7 * 24 * 3600 * 1000).toISOString().replace("T", " ")
  for (const inv of $app.findRecordsByFilter("invites", "expires < {:d}", "", 1000, 0, { d: old })) {
    $app.delete(inv)
  }
})
