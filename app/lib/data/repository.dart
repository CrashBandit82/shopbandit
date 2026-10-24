import 'package:drift/drift.dart';

import '../core/items.dart';
import 'db.dart';
import 'sync_service.dart';

/// Entry joined with its catalog item, as shown in the list.
typedef ListRow = ({ListEntry entry, CatalogItem item, String? addedByName});

/// All local writes. Each write updates the local DB first (UI reacts at
/// once) and queues the change for the server.
class ShopRepository {
  ShopRepository(this.db, this.sync, {required this.household, required this.userId, DateTime Function()? clock})
      : _now = clock ?? DateTime.now;

  final AppDatabase db;
  final SyncService sync;
  final String household;
  final String userId;
  final DateTime Function() _now;

  // ------------------------------------------------------------- queries --

  Stream<List<ListRow>> watchList() {
    final q = db.select(db.listEntries).join([
      innerJoin(db.catalogItems, db.catalogItems.id.equalsExp(db.listEntries.catalogItem)),
      leftOuterJoin(db.members, db.members.id.equalsExp(db.listEntries.addedBy)),
    ])
      ..where(db.listEntries.household.equals(household) &
          db.listEntries.deleted.equals(false) &
          db.listEntries.checked.equals(false))
      ..orderBy([OrderingTerm.desc(db.listEntries.createdAt)]);
    return q.watch().map((rows) => rows
        .map((r) => (
              entry: r.readTable(db.listEntries),
              item: r.readTable(db.catalogItems),
              addedByName: r.readTableOrNull(db.members)?.name,
            ))
        .toList());
  }

  Stream<List<CatalogItem>> watchCatalog() => (db.select(db.catalogItems)
        ..where((c) => c.household.equals(household) & c.deleted.equals(false))
        ..orderBy([(c) => OrderingTerm.asc(c.nameNormalized)]))
      .watch();

  Stream<List<Member>> watchMembers() => (db.select(db.members)
        ..where((m) => m.household.equals(household))
        ..orderBy([(m) => OrderingTerm.asc(m.name)]))
      .watch();

  /// Catalog items sorted by [frequencyScore], without those already listed.
  static List<CatalogItem> frequent(List<CatalogItem> catalog, Set<String> onList, DateTime now, {int limit = 12}) {
    final candidates = catalog.where((c) => c.purchaseCount > 0 && !onList.contains(c.id)).toList()
      ..sort((a, b) => frequencyScore(b.purchaseCount, b.lastPurchased, now)
          .compareTo(frequencyScore(a.purchaseCount, a.lastPurchased, now)));
    return candidates.take(limit).toList();
  }

  // -------------------------------------------------------------- writes --

  /// Adds [rawName] to the list. Reuses (and if needed restores) the catalog
  /// item; if the item is already on the list only the quantity is updated.
  Future<void> addItem(String rawName, {String quantity = ''}) async {
    final name = cleanItemName(rawName);
    if (name.isEmpty) return;
    final normalized = normalizeItemName(name);
    final qty = quantity.trim();

    await db.transaction(() async {
      final existing = await (db.select(db.catalogItems)
            ..where((c) => c.household.equals(household) & c.nameNormalized.equals(normalized)))
          .getSingleOrNull();
      final catalogId = existing?.id ?? catalogItemId(household, normalized);

      if (existing == null) {
        await db.into(db.catalogItems).insert(CatalogItemsCompanion.insert(
              id: catalogId,
              household: household,
              name: name,
              nameNormalized: normalized,
            ));
        await sync.enqueue('catalog_items', catalogId, 'create', {
          'id': catalogId,
          'household': household,
          'name': name,
          'name_normalized': normalized,
          'purchase_count': 0,
          'deleted': false,
        });
      } else if (existing.deleted) {
        await (db.update(db.catalogItems)..where((c) => c.id.equals(catalogId)))
            .write(const CatalogItemsCompanion(deleted: Value(false)));
        await sync.enqueue('catalog_items', catalogId, 'update', {'deleted': false});
      }

      final onList = await (db.select(db.listEntries)
            ..where((e) =>
                e.catalogItem.equals(catalogId) & e.deleted.equals(false) & e.checked.equals(false))
            ..limit(1))
          .getSingleOrNull();
      if (onList != null) {
        if (qty.isNotEmpty && qty != onList.quantity) await _setQuantity(onList.id, qty);
        return;
      }

      final id = newRecordId();
      await db.into(db.listEntries).insert(ListEntriesCompanion.insert(
            id: id,
            household: household,
            catalogItem: catalogId,
            quantity: Value(qty),
            addedBy: Value(userId),
            createdAt: _now(),
          ));
      await sync.enqueue('list_entries', id, 'create', {
        'id': id,
        'household': household,
        'catalog_item': catalogId,
        'quantity': qty,
        'added_by': userId,
        'checked': false,
        'deleted': false,
      });
    });
    _kick();
  }

  Future<void> updateQuantity(String entryId, String quantity) async {
    await db.transaction(() => _setQuantity(entryId, quantity.trim()));
    _kick();
  }

  Future<void> _setQuantity(String entryId, String qty) async {
    await (db.update(db.listEntries)..where((e) => e.id.equals(entryId)))
        .write(ListEntriesCompanion(quantity: Value(qty)));
    await sync.enqueue('list_entries', entryId, 'update', {'quantity': qty});
  }

  /// Bought: entry leaves the list, purchase counter goes up.
  Future<void> check(ListRow row, {bool undo = false}) async {
    final now = _now();
    await db.transaction(() async {
      await (db.update(db.listEntries)..where((e) => e.id.equals(row.entry.id))).write(ListEntriesCompanion(
            checked: Value(!undo),
            checkedAt: Value(undo ? null : now),
          ));
      await sync.enqueue('list_entries', row.entry.id, 'update', {
        'checked': !undo,
        'checked_at': undo ? '' : toPbDate(now),
      });

      final item = await (db.select(db.catalogItems)..where((c) => c.id.equals(row.item.id))).getSingle();
      final count = undo ? (item.purchaseCount > 0 ? item.purchaseCount - 1 : 0) : item.purchaseCount + 1;
      final last = undo ? row.item.lastPurchased : now;
      await (db.update(db.catalogItems)..where((c) => c.id.equals(item.id))).write(CatalogItemsCompanion(
            purchaseCount: Value(count),
            lastPurchased: Value(last),
          ));
      await sync.enqueue('catalog_items', item.id, 'update', {
        // relative change, so parallel purchases on two phones add up
        if (undo) 'purchase_count-': 1 else 'purchase_count+': 1,
        'last_purchased': last == null ? '' : toPbDate(last),
      });
    });
    _kick();
  }

  Future<void> deleteEntry(String entryId, {bool undo = false}) async {
    await db.transaction(() async {
      await (db.update(db.listEntries)..where((e) => e.id.equals(entryId)))
          .write(ListEntriesCompanion(deleted: Value(!undo)));
      await sync.enqueue('list_entries', entryId, 'update', {'deleted': !undo});
    });
    _kick();
  }

  /// Removes an item from the catalog (and from the list, if it is on it).
  Future<void> deleteCatalogItem(String catalogId) async {
    await db.transaction(() async {
      await (db.update(db.catalogItems)..where((c) => c.id.equals(catalogId)))
          .write(const CatalogItemsCompanion(deleted: Value(true)));
      await sync.enqueue('catalog_items', catalogId, 'update', {'deleted': true});
      final active = await (db.select(db.listEntries)
            ..where((e) => e.catalogItem.equals(catalogId) & e.deleted.equals(false) & e.checked.equals(false)))
          .get();
      for (final e in active) {
        await (db.update(db.listEntries)..where((x) => x.id.equals(e.id)))
            .write(const ListEntriesCompanion(deleted: Value(true)));
        await sync.enqueue('list_entries', e.id, 'update', {'deleted': true});
      }
    });
    _kick();
  }

  void _kick() => sync.sync().ignore();
}
