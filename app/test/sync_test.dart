import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopbandit/core/items.dart';
import 'package:shopbandit/data/db.dart';
import 'package:shopbandit/data/repository.dart';
import 'package:shopbandit/data/sync_service.dart';

import 'fake_remote.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late AppDatabase db;
  late FakeRemote server;
  late SyncService sync;
  late ShopRepository repo;

  ShopRepository device(AppDatabase d, SyncService s, String user) =>
      ShopRepository(d, s, household: 'h1', userId: user);

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    server = FakeRemote()..users.addAll([
        {'id': 'u1', 'name': 'Anna', 'household': 'h1'},
        {'id': 'u2', 'name': 'Bert', 'household': 'h1'},
      ]);
    sync = SyncService(db, server);
    repo = device(db, sync, 'u1');
  });

  tearDown(() => db.close());

  Future<List<ListRow>> listOf(ShopRepository r) => r.watchList().first;

  test('offline add is queued and pushed later', () async {
    server.online = false;
    await repo.addItem('Milch', quantity: '2');
    await sync.sync();
    expect(sync.state, SyncState.offline);
    expect(await db.pendingCount(), 2);
    expect((await listOf(repo)).single.item.name, 'Milch');

    server.online = true;
    await sync.resetBackoff();
    await sync.sync();
    expect(sync.state, SyncState.idle);
    expect(await db.pendingCount(), 0);
    expect(server.records['list_entries']!.values.single['quantity'], '2');
  });

  test('backoff grows and caps at 5 minutes', () {
    expect(SyncService.backoff(1), const Duration(seconds: 2));
    expect(SyncService.backoff(5), const Duration(seconds: 32));
    expect(SyncService.backoff(20), const Duration(minutes: 5));
  });

  test('same item twice: no duplicate catalog entry, quantity updated', () async {
    await repo.addItem('Brot');
    await repo.addItem('  brot ', quantity: '1');
    await sync.sync();
    expect(server.records['catalog_items']!.length, 1);
    expect(server.records['list_entries']!.length, 1);
    expect((await listOf(repo)).single.entry.quantity, '1');
  });

  test('two devices add the same new item offline → one catalog record', () async {
    final db2 = AppDatabase(NativeDatabase.memory());
    final sync2 = SyncService(db2, server);
    final repo2 = device(db2, sync2, 'u2');
    server.online = false;
    await repo.addItem('Butter');
    await repo2.addItem('butter');
    server.online = true;
    await sync.resetBackoff();
    await sync2.resetBackoff();
    await sync.sync();
    await sync2.sync();
    expect(server.records['catalog_items']!.length, 1);
    expect(server.records['catalog_items']!.keys.single, catalogItemId('h1', 'butter'));
    expect(await db2.pendingCount(), 0);
    await db2.close();
  });

  test('check off counts purchases; parallel checks add up', () async {
    await repo.addItem('Eier');
    await sync.sync();
    final db2 = AppDatabase(NativeDatabase.memory());
    final sync2 = SyncService(db2, server);
    final repo2 = device(db2, sync2, 'u2');
    await sync2.sync();

    final row1 = (await listOf(repo)).single;
    final row2 = (await listOf(repo2)).single;
    await repo.check(row1);
    await repo2.check(row2);
    await sync.sync();
    await sync2.sync();
    await sync.sync();

    final serverItem = server.records['catalog_items']!.values.single;
    expect(serverItem['purchase_count'], 2);
    expect(await listOf(repo), isEmpty);
    final local = await db.select(db.catalogItems).getSingle();
    expect(local.purchaseCount, 2);
    await db2.close();
  });

  test('undo check restores entry and counter', () async {
    await repo.addItem('Käse');
    final row = (await listOf(repo)).single;
    await repo.check(row);
    await repo.check(row, undo: true);
    await sync.sync();
    expect((await listOf(repo)).single.item.name, 'Käse');
    expect(server.records['catalog_items']!.values.single['purchase_count'], 0);
  });

  test('delete is a tombstone that syncs to other devices', () async {
    await repo.addItem('Salz');
    await sync.sync();
    final db2 = AppDatabase(NativeDatabase.memory());
    final sync2 = SyncService(db2, server);
    final repo2 = device(db2, sync2, 'u2');
    await sync2.sync();
    expect(await listOf(repo2), hasLength(1));

    await repo.deleteEntry((await listOf(repo)).single.entry.id);
    await sync.sync();
    await sync2.sync();
    expect(await listOf(repo2), isEmpty);
    expect(server.records['list_entries']!.values.single['deleted'], true);
    await db2.close();
  });

  test('pending local change is not overwritten by older remote data', () async {
    await repo.addItem('Mehl', quantity: '1');
    await sync.sync();
    final id = (await listOf(repo)).single.entry.id;
    // other device changes quantity on the server
    await server.update('list_entries', id, {'quantity': '3'});
    // we change it offline afterwards → our write is the last one
    server.online = false;
    await repo.updateQuantity(id, '5');
    await sync.sync();
    expect((await listOf(repo)).single.entry.quantity, '5');
    server.online = true;
    await sync.resetBackoff();
    await sync.sync();
    expect(server.records['list_entries']![id]!['quantity'], '5');
    expect((await listOf(repo)).single.entry.quantity, '5');
  });

  test('rejected change (404) is dropped and does not block the queue', () async {
    await sync.enqueue('list_entries', 'gone', 'update', {'quantity': '1'});
    await repo.addItem('Zucker');
    await sync.sync();
    expect(await db.pendingCount(), 0);
    expect(server.records['list_entries']!.length, 1);
  });

  test('member names come with the list', () async {
    await sync.sync();
    final db2 = AppDatabase(NativeDatabase.memory());
    final sync2 = SyncService(db2, server);
    await device(db2, sync2, 'u2').addItem('Tee');
    await sync2.sync();
    await sync.sync();
    expect((await listOf(repo)).single.addedByName, 'Bert');
    await db2.close();
  });

  test('frequently bought: sorted, without items on the list', () {
    final now = DateTime(2026, 10, 24);
    CatalogItem item(String id, int count, int daysAgo) => CatalogItem(
          id: id,
          household: 'h1',
          name: id,
          nameNormalized: id,
          purchaseCount: count,
          lastPurchased: now.subtract(Duration(days: daysAgo)),
          deleted: false,
          updated: '',
        );
    final result = ShopRepository.frequent(
      [item('a', 10, 100), item('b', 3, 1), item('c', 5, 5), item('d', 0, 0), item('e', 9, 1)],
      {'e'},
      now,
    );
    expect(result.map((c) => c.id), ['c', 'b', 'a']);
  });

  test('clearAll wipes household data', () async {
    await repo.addItem('Reis');
    await db.clearAll();
    expect(await db.select(db.listEntries).get(), isEmpty);
    expect(await db.pendingCount(), 0);
  });
}
