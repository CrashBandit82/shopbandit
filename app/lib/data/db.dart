import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'db.g.dart';

/// Local mirror of the server collection `catalog_items`.
class CatalogItems extends Table {
  TextColumn get id => text()();
  TextColumn get household => text()();
  TextColumn get name => text()();
  TextColumn get nameNormalized => text()();
  IntColumn get purchaseCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastPurchased => dateTime().nullable()();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();

  /// Server `updated` (PocketBase date string), empty until first sync.
  TextColumn get updated => text().withDefault(const Constant(''))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Local mirror of the server collection `list_entries`.
class ListEntries extends Table {
  TextColumn get id => text()();
  TextColumn get household => text()();
  TextColumn get catalogItem => text()();
  TextColumn get quantity => text().withDefault(const Constant(''))();
  TextColumn get addedBy => text().withDefault(const Constant(''))();
  BoolColumn get checked => boolean().withDefault(const Constant(false))();
  DateTimeColumn get checkedAt => dateTime().nullable()();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get updated => text().withDefault(const Constant(''))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Household members (users visible to the current user).
class Members extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get household => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Pending local changes, pushed in order (see SyncService).
class Outbox extends Table {
  IntColumn get seq => integer().autoIncrement()();
  TextColumn get collection => text()();
  TextColumn get recordId => text()();

  /// `create` or `update`
  TextColumn get op => text()();

  /// JSON body for the PocketBase request.
  TextColumn get payload => text()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  DateTimeColumn get notBefore => dateTime().nullable()();
}

/// Small key/value store for sync cursors.
class Meta extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

@DriftDatabase(tables: [CatalogItems, ListEntries, Members, Outbox, Meta])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'shopbandit'));

  @override
  int get schemaVersion => 1;

  Future<String?> getMeta(String key) async =>
      (await (select(meta)..where((m) => m.key.equals(key))).getSingleOrNull())
          ?.value;

  Future<void> setMeta(String key, String value) =>
      into(meta).insertOnConflictUpdate(MetaCompanion.insert(key: key, value: value));

  /// Drops all household data (used on logout and household switch).
  Future<void> clearAll() => transaction(() async {
        for (final t in allTables) {
          await delete(t).go();
        }
      });

  Future<int> pendingCount() async {
    final c = outbox.seq.count();
    return (await (selectOnly(outbox)..addColumns([c])).getSingle()).read(c) ?? 0;
  }

  Stream<int> watchPendingCount() {
    final c = outbox.seq.count();
    return (selectOnly(outbox)..addColumns([c]))
        .watchSingle()
        .map((r) => r.read(c) ?? 0);
  }

  Future<Set<String>> pendingRecordIds() async =>
      (await select(outbox).get()).map((o) => o.recordId).toSet();
}
