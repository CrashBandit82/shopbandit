// Shared helpers for the ShopBandit hooks. Loaded inside handlers via
// require(`${__hooks}/shopbandit.js`) because every handler runs in its own VM.

const INVITE_TTL_HOURS = 24

// Same rule as the app (app/lib/core/password_rules.dart).
function passwordProblems(pw) {
  const problems = []
  if (typeof pw !== "string" || pw.length < 8) problems.push("min_length")
  if (!/[A-Z]/.test(pw || "")) problems.push("uppercase")
  if (!/[a-z]/.test(pw || "")) problems.push("lowercase")
  if (!/[0-9]/.test(pw || "")) problems.push("digit")
  if (!/[^A-Za-z0-9]/.test(pw || "")) problems.push("special")
  return problems
}

function assertPassword(pw) {
  const problems = passwordProblems(pw)
  if (problems.length) {
    throw new BadRequestError("Password does not meet the requirements.", {
      password: new ValidationError("validation_password_rules", problems.join(",")),
    })
  }
}

function defaultHouseholdName(user) {
  const n = (user.getString("name") || user.getString("email").split("@")[0] || "").trim()
  return n ? n.slice(0, 60) : "Haushalt"
}

// Creates a fresh single-person household owned by `user` and moves the user into it.
function createOwnHousehold(app, user) {
  const households = app.findCollectionByNameOrId("households")
  const h = new Record(households)
  h.set("name", defaultHouseholdName(user))
  h.set("owner", user.id)
  app.save(h)
  user.set("household", h.id)
  app.save(user)
  return h
}

function members(app, householdId) {
  return app.findRecordsByFilter("users", "household = {:h}", "created", 0, 0, { h: householdId })
}

// Removes `user` from its current household. An empty household is deleted
// (with its list and catalog via cascade); otherwise ownership passes on.
function detachFromHousehold(app, user) {
  const hid = user.getString("household")
  if (!hid) return
  let household
  try {
    household = app.findRecordById("households", hid)
  } catch (_) {
    return
  }
  const others = members(app, hid).filter((m) => m.id !== user.id)
  user.set("household", "")
  app.save(user)
  if (others.length === 0) {
    app.delete(household)
  } else if (household.getString("owner") === user.id) {
    household.set("owner", others[0].id)
    app.save(household)
  }
}

function hashToken(token) {
  return $security.sha256(token)
}

function newInviteToken() {
  return $security.randomStringWithAlphabet(24, "ABCDEFGHJKLMNPQRSTUVWXYZ23456789")
}

function findValidInvite(app, token) {
  let inv
  try {
    inv = app.findFirstRecordByFilter("invites", "token_hash = {:t}", { t: hashToken(String(token || "").trim().toUpperCase()) })
  } catch (_) {
    throw new BadRequestError("invite_invalid")
  }
  if (inv.getBool("used") || inv.getBool("revoked")) throw new BadRequestError("invite_invalid")
  if (new Date(inv.getString("expires").replace(" ", "T")) < new Date()) throw new BadRequestError("invite_expired")
  return inv
}

// --- push ------------------------------------------------------------------

// Optional comma separated host allow list for UnifiedPush endpoints
// (SHOPBANDIT_PUSH_HOSTS). Endpoints must always be https.
function endpointAllowed(url) {
  const m = /^https:\/\/([^/:?#]+)(:\d+)?(\/|$)/i.exec(url || "")
  if (!m) return false
  const host = m[1].toLowerCase()
  if (/^[0-9.]+$/.test(host) || host.indexOf("[") >= 0 || host === "localhost") return false
  const allow = ($os.getenv("SHOPBANDIT_PUSH_HOSTS") || "").split(",").map((s) => s.trim().toLowerCase()).filter(Boolean)
  return allow.length === 0 || allow.indexOf(host) >= 0
}

function displayName(user) {
  return (user.getString("name") || user.getString("email").split("@")[0] || "?").trim()
}

// Builds one bundled notification per household and recipient.
function sendPendingPushes(app) {
  const cutoff = new Date(Date.now() - 20 * 1000).toISOString().replace("T", " ")
  const pending = app.findRecordsByFilter(
    "list_entries", "notified = false && created <= {:c}", "created", 500, 0, { c: cutoff })
  if (!pending.length) return

  const byHousehold = {}
  for (const e of pending) {
    const h = e.getString("household")
    ;(byHousehold[h] = byHousehold[h] || []).push(e)
  }

  for (const hid in byHousehold) {
    const entries = byHousehold[hid]
    const fresh = entries.filter((e) => !e.getBool("deleted") && !e.getBool("checked"))
    const users = members(app, hid)
    const nameOf = {}
    for (const u of users) nameOf[u.id] = displayName(u)

    for (const recipient of users) {
      const foreign = fresh.filter((e) => e.getString("added_by") !== recipient.id)
      if (!foreign.length) continue
      const endpoints = app.findRecordsByFilter("push_endpoints", "user = {:u}", "", 20, 0, { u: recipient.id })
      if (!endpoints.length) continue

      // Only names + count: the payload may pass a third-party push server
      // unencrypted, so no item names are sent.
      const adders = {}
      for (const e of foreign) adders[nameOf[e.getString("added_by")] || "?"] = true
      const payload = JSON.stringify({
        type: "items_added",
        household: hid,
        by: Object.keys(adders),
        count: foreign.length,
      })
      for (const ep of endpoints) {
        const url = ep.getString("endpoint_url")
        if (!endpointAllowed(url)) continue
        try {
          const res = $http.send({ url: url, method: "POST", body: payload, headers: { "content-type": "application/json" }, timeout: 10 })
          // 404/410 = endpoint gone (app uninstalled / unregistered)
          if (res.statusCode === 404 || res.statusCode === 410) app.delete(ep)
        } catch (err) {
          app.logger().warn("push failed", "endpoint", ep.id, "error", String(err))
        }
      }
    }
  }

  for (const e of pending) {
    e.set("notified", true)
    app.unsafeWithoutHooks().save(e)
  }
}

module.exports = {
  INVITE_TTL_HOURS,
  passwordProblems,
  assertPassword,
  createOwnHousehold,
  detachFromHousehold,
  members,
  hashToken,
  newInviteToken,
  findValidInvite,
  endpointAllowed,
  sendPendingPushes,
}
