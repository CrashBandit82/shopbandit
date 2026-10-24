import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:drift/drift.dart';

import 'db.dart';
import 'remote.dart';

enum SyncState { idle, syncing, offline, error }

DateTime? parsePbDate(Object? value) {
  final s = value?.toString() ?? '';
  if (s.isEmpty) return null;
  return DateTime.tryParse(s.replaceFirst(' ', 'T'));
}

String toPbDate(DateTime d) => d.toUtc().toIso8601String().replaceFirst('T', ' ');

/// Offline-first sync:
/// * local changes go into [Outbox] and are pushed in order with backoff,
/// * remote changes are pulled by `updated` cursor and via realtime events,
/// * records with pending local changes are not overwritten by remote data
///   (last write wins once the local change reached the server),
/// * deletions are tombstones (`deleted = true`).
class SyncService {
  SyncService(this.db, this.remote, {DateTime Function()? clock}) : _now = clock ?? DateTime.now;

  final AppDatabase db;
  final SyncRemote remote;
  final DateTime Function() _now;

  final _state = StreamController<SyncState>.broadcast();
  SyncState _current = SyncState.idle;
  Future<void>? _running;
  bool _again = false;

  Stream<SyncState> get states => _state.stream;
  SyncState get state => _current;

  void _set(SyncState s) {
    _current = s;
    _state.add(s);
  }

  static Duration backoff(int attempts) =>
      Duration(seconds: min(300, pow(2, attempts).toInt()));

  /// Runs push + pull. Concurrent calls are coalesced into one follow-up run.
  Future<void> sync() {
    if (_running != null) {
      _again = true;
      return _running!;
    }
    final f = _run();
    _running = f;
    return f.whenComplete(() => _running = null);
  }

  Future<void> _run() async {
    do {
      _again = false;
      _set(SyncState.syncing);
      try {
        await push();
        await pull();
        _set(SyncState.idle);
      } on RemoteUnreachable {
        _set(SyncState.offline);
        return;
      } on RemoteRejected {
        _set(SyncState.error);
        return;
      }
    } while (_again);
  }

  // ---------------------------------------------------------------- push --

  Future<void> enqueue(String collection, String recordId, String op, Map<String, dynamic> payload) =>
      db.into(db.outbox).insert(OutboxCompanion.insert(
            collection: collection,
            recordId: recordId,
            op: op,
            payload: jsonEncode(payload),
          ));

  /// Sends pending changes in order. Stops at the first network problem.
  Future<void> push() async {
    while (true) {
      final next = await (db.select(db.outbox)
            ..orderBy([(o) => OrderingTerm.asc(o.seq)])
            ..limit(1))
          .getSingleOrNull();
      if (next == null) return;
      if (next.notBefore != null && next.notBefore!.isAfter(_now())) {
        throw RemoteUnreachable('backoff');
      }
      final body = (jsonDecode(next.payload) as Map).cast<String, dynamic>();
      try {
        await _send(next, body);
        await _done(next);
      } on RemoteUnreachable {
        await _retryLater(next);
        rethrow;
      } on RemoteRejected catch (e) {
        if (e.status == 401 || e.status >= 500 || e.status == 429) {
          await _retryLater(next);
          rethrow;
        }
        // 400/403/404: the change cannot be applied (record gone, household
        // changed, invalid data) - drop it so the queue does not get stuck.
        await _done(next);
      }
    }
  }

  Future<void> _send(OutboxData op, Map<String, dynamic> body) async {
    if (op.op == 'update') {
      await remote.update(op.collection, op.recordId, body);
      return;
    }
    try {
      await remote.create(op.collection, body);
    } on RemoteRejected catch (e) {
      // Same id already on the server (deterministic catalog ids, or a create
      // that succeeded before the connection dropped): apply as update.
      if (e.status != 400) rethrow;
      final patch = Map<String, dynamic>.of(body)
        ..remove('id')
        ..remove('household')
        ..remove('added_by');
      await remote.update(op.collection, op.recordId, patch);
    }
  }

  Future<void> _done(OutboxData op) =>
      (db.delete(db.outbox)..where((o) => o.seq.equals(op.seq))).go();

  Future<void> _retryLater(OutboxData op) => (db.update(db.outbox)..where((o) => o.seq.equals(op.seq))).write(
        OutboxCompanion(
          attempts: Value(op.attempts + 1),
          notBefore: Value(_now().add(backoff(op.attempts + 1))),
        ),
      );

  /// Lets the next [push] ignore backoff (e.g. on reconnect or user action).
  Future<void> resetBackoff() =>
      db.update(db.outbox).write(const OutboxCompanion(notBefore: Value(null)));

  // ---------------------------------------------------------------- pull --

  Future<void> pull() async {
    for (final c in const ['catalog_items', 'list_entries']) {
      final key = 'pull:$c';
      final since = await db.getMeta(key) ?? '';
      final records = await remote.listSince(c, since);
      if (records.isEmpty) continue;
      final pending = await db.pendingRecordIds();
      await db.transaction(() async {
        for (final r in records) {
          if (!pending.contains(r['id'])) await applyRemote(c, r);
        }
      });
      final newest = records.map((r) => r['updated'].toString()).reduce((a, b) => a.compareTo(b) >= 0 ? a : b);
      await db.setMeta(key, newest);
    }
    final members = await remote.members();
    await db.transaction(() async {
      await db.delete(db.members).go();
      for (final m in members) {
        await applyRemote('users', m);
      }
    });
  }

  /// Upserts one server record into the local tables.
  Future<void> applyRemote(String collection, Map<String, dynamic> r) async {
    final id = r['id'] as String;
    switch (collection) {
      case 'catalog_items':
        await db.into(db.catalogItems).insertOnConflictUpdate(CatalogItemsCompanion.insert(
              id: id,
              household: r['household'] as String,
              name: r['name'] as String,
              nameNormalized: r['name_normalized'] as String,
              purchaseCount: Value((r['purchase_count'] as num?)?.toInt() ?? 0),
              lastPurchased: Value(parsePbDate(r['last_purchased'])),
              deleted: Value(r['deleted'] == true),
              updated: Value(r['updated']?.toString() ?? ''),
            ));
      case 'list_entries':
        await db.into(db.listEntries).insertOnConflictUpdate(ListEntriesCompanion.insert(
              id: id,
              household: r['household'] as String,
              catalogItem: r['catalog_item'] as String,
              quantity: Value(r['quantity']?.toString() ?? ''),
              addedBy: Value(r['added_by']?.toString() ?? ''),
              checked: Value(r['checked'] == true),
              checkedAt: Value(parsePbDate(r['checked_at'])),
              deleted: Value(r['deleted'] == true),
              createdAt: parsePbDate(r['created']) ?? _now(),
              updated: Value(r['updated']?.toString() ?? ''),
            ));
      case 'users':
        final email = r['email']?.toString() ?? '';
        final name = (r['name']?.toString() ?? '').trim();
        await db.into(db.members).insertOnConflictUpdate(MembersCompanion.insert(
              id: id,
              name: name.isNotEmpty ? name : email.split('@').first,
              household: r['household']?.toString() ?? '',
            ));
    }
  }

  /// Realtime event from the server (only while the app is open).
  Future<void> applyEvent(RemoteEvent e) async {
    final pending = await db.pendingRecordIds();
    if (pending.contains(e.record['id'])) return;
    if (e.collection == 'users' && e.action == 'delete') {
      await (db.delete(db.members)..where((m) => m.id.equals(e.record['id'] as String))).go();
      return;
    }
    await applyRemote(e.collection, e.record);
  }

  Future<void> dispose() => _state.close();
}
