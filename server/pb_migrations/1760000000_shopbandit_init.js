/// <reference path="../pb_data/types.d.ts" />

// ShopBandit schema: households, invites, catalog, list entries, push endpoints.
// Every member only sees data of the household stored in users.household.
// users.household is only changed by hooks (see pb_hooks/), never by clients.

const SAME_HOUSEHOLD = "@request.auth.id != '' && household = @request.auth.household"
const KEEP_HOUSEHOLD = "(@request.body.household:isset = false || @request.body.household = @request.auth.household)"

migrate((app) => {
  const users = app.findCollectionByNameOrId("users")

  const households = new Collection({
    type: "base",
    name: "households",
    fields: [
      { name: "name", type: "text", required: true, max: 80 },
      { name: "owner", type: "relation", collectionId: users.id, maxSelect: 1, required: true },
      { name: "created", type: "autodate", onCreate: true, onUpdate: false },
      { name: "updated", type: "autodate", onCreate: true, onUpdate: true },
    ],
  })
  app.save(households)

  users.fields.add(new RelationField({ name: "household", collectionId: households.id, maxSelect: 1 }))
  users.listRule = "id = @request.auth.id || (household != '' && household = @request.auth.household)"
  users.viewRule = users.listRule
  users.updateRule = "id = @request.auth.id && @request.body.household:isset = false"
  app.save(users)

  households.listRule = "id = @request.auth.household"
  households.viewRule = "id = @request.auth.household"
  households.updateRule = "id = @request.auth.household && owner = @request.auth.id && @request.body.owner:isset = false"
  app.save(households)

  // token_hash = sha256(token); the plain token is shown only once (QR code).
  app.save(new Collection({
    type: "base",
    name: "invites",
    listRule: "household = @request.auth.household && household.owner = @request.auth.id",
    viewRule: "household = @request.auth.household && household.owner = @request.auth.id",
    fields: [
      { name: "household", type: "relation", collectionId: households.id, maxSelect: 1, required: true, cascadeDelete: true },
      { name: "token_hash", type: "text", required: true, hidden: true },
      { name: "expires", type: "date", required: true },
      { name: "used", type: "bool" },
      { name: "revoked", type: "bool" },
      { name: "created_by", type: "relation", collectionId: users.id, maxSelect: 1 },
      { name: "created", type: "autodate", onCreate: true, onUpdate: false },
      { name: "updated", type: "autodate", onCreate: true, onUpdate: true },
    ],
    indexes: ["CREATE UNIQUE INDEX idx_invites_token ON invites (token_hash)"],
  }))

  const catalog = new Collection({
    type: "base",
    name: "catalog_items",
    listRule: SAME_HOUSEHOLD,
    viewRule: SAME_HOUSEHOLD,
    createRule: SAME_HOUSEHOLD,
    updateRule: SAME_HOUSEHOLD + " && " + KEEP_HOUSEHOLD,
    fields: [
      { name: "household", type: "relation", collectionId: households.id, maxSelect: 1, required: true, cascadeDelete: true },
      { name: "name", type: "text", required: true, max: 120 },
      { name: "name_normalized", type: "text", required: true, max: 120 },
      { name: "purchase_count", type: "number", onlyInt: true, min: 0 },
      { name: "last_purchased", type: "date" },
      { name: "deleted", type: "bool" },
      { name: "created", type: "autodate", onCreate: true, onUpdate: false },
      { name: "updated", type: "autodate", onCreate: true, onUpdate: true },
    ],
    indexes: [
      "CREATE UNIQUE INDEX idx_catalog_name ON catalog_items (household, name_normalized)",
      "CREATE INDEX idx_catalog_updated ON catalog_items (household, updated)",
    ],
  })
  app.save(catalog)

  app.save(new Collection({
    type: "base",
    name: "list_entries",
    listRule: SAME_HOUSEHOLD,
    viewRule: SAME_HOUSEHOLD,
    createRule: SAME_HOUSEHOLD + " && added_by = @request.auth.id && catalog_item.household = @request.auth.household",
    updateRule: SAME_HOUSEHOLD + " && " + KEEP_HOUSEHOLD +
      " && @request.body.added_by:isset = false" +
      " && (@request.body.catalog_item:isset = false || @request.body.catalog_item.household = @request.auth.household)",
    fields: [
      { name: "household", type: "relation", collectionId: households.id, maxSelect: 1, required: true, cascadeDelete: true },
      { name: "catalog_item", type: "relation", collectionId: catalog.id, maxSelect: 1, required: true, cascadeDelete: true },
      { name: "quantity", type: "text", max: 40 },
      { name: "added_by", type: "relation", collectionId: users.id, maxSelect: 1 },
      { name: "checked", type: "bool" },
      { name: "checked_at", type: "date" },
      { name: "deleted", type: "bool" },
      // set by the push cron once members were notified about this entry
      { name: "notified", type: "bool" },
      { name: "created", type: "autodate", onCreate: true, onUpdate: false },
      { name: "updated", type: "autodate", onCreate: true, onUpdate: true },
    ],
    indexes: [
      "CREATE INDEX idx_entries_updated ON list_entries (household, updated)",
      "CREATE INDEX idx_entries_notify ON list_entries (notified, created)",
    ],
  }))

  app.save(new Collection({
    type: "base",
    name: "push_endpoints",
    listRule: "user = @request.auth.id",
    viewRule: "user = @request.auth.id",
    createRule: "@request.auth.id != '' && user = @request.auth.id",
    updateRule: "user = @request.auth.id && @request.body.user:isset = false",
    deleteRule: "user = @request.auth.id",
    fields: [
      { name: "user", type: "relation", collectionId: users.id, maxSelect: 1, required: true, cascadeDelete: true },
      { name: "endpoint_url", type: "url", required: true },
      { name: "created", type: "autodate", onCreate: true, onUpdate: false },
      { name: "updated", type: "autodate", onCreate: true, onUpdate: true },
    ],
    indexes: ["CREATE UNIQUE INDEX idx_push_endpoint ON push_endpoints (endpoint_url)"],
  }))
}, (app) => {
  for (const name of ["push_endpoints", "list_entries", "catalog_items", "invites"]) {
    app.delete(app.findCollectionByNameOrId(name))
  }
  const users = app.findCollectionByNameOrId("users")
  users.fields.removeByName("household")
  users.listRule = "id = @request.auth.id"
  users.viewRule = "id = @request.auth.id"
  users.updateRule = "id = @request.auth.id"
  app.save(users)
  app.delete(app.findCollectionByNameOrId("households"))
})
