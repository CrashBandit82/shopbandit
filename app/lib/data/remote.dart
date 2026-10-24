import 'dart:async';
import 'dart:io';

import 'package:pocketbase/pocketbase.dart';

/// Server rejected the request (4xx/5xx with a response).
class RemoteRejected implements Exception {
  RemoteRejected(this.status, [this.data = const {}]);
  final int status;
  final Map<String, dynamic> data;

  @override
  String toString() => 'RemoteRejected($status, $data)';
}

/// Server not reachable (offline, DNS, timeout).
class RemoteUnreachable implements Exception {
  RemoteUnreachable(this.cause);
  final Object cause;

  @override
  String toString() => 'RemoteUnreachable($cause)';
}

typedef RemoteEvent = ({String collection, String action, Map<String, dynamic> record});

/// The parts of the server API the sync layer needs. Kept small so tests can
/// replace it with an in-memory fake.
abstract interface class SyncRemote {
  Future<void> create(String collection, Map<String, dynamic> body);
  Future<void> update(String collection, String id, Map<String, dynamic> body);

  /// Records of [collection] with `updated >= since` (all when [since] is empty).
  Future<List<Map<String, dynamic>>> listSince(String collection, String since);

  /// All users visible to the current user (= household members).
  Future<List<Map<String, dynamic>>> members();
}

/// [SyncRemote] backed by the PocketBase SDK.
class PocketBaseRemote implements SyncRemote {
  PocketBaseRemote(this.pb);
  final PocketBase pb;

  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call().timeout(const Duration(seconds: 20));
    } on ClientException catch (e) {
      if (e.statusCode == 0) throw RemoteUnreachable((e.originalError as Object?) ?? e);
      throw RemoteRejected(e.statusCode, e.response);
    } on SocketException catch (e) {
      throw RemoteUnreachable(e);
    } on TimeoutException catch (e) {
      throw RemoteUnreachable(e);
    }
  }

  @override
  Future<void> create(String collection, Map<String, dynamic> body) =>
      _guard(() => pb.collection(collection).create(body: body));

  @override
  Future<void> update(String collection, String id, Map<String, dynamic> body) =>
      _guard(() => pb.collection(collection).update(id, body: body));

  @override
  Future<List<Map<String, dynamic>>> listSince(String collection, String since) =>
      _guard(() async {
        final records = await pb.collection(collection).getFullList(
              batch: 500,
              sort: 'updated',
              filter: since.isEmpty ? null : pb.filter('updated >= {:s}', {'s': since}),
            );
        return records.map((r) => r.toJson()).toList();
      });

  @override
  Future<List<Map<String, dynamic>>> members() => _guard(() async {
        final records = await pb.collection('users').getFullList(fields: 'id,name,household,email');
        return records.map((r) => r.toJson()).toList();
      });

  /// Live updates while the app is open. Returns an unsubscribe function.
  Future<Future<void> Function()> subscribe(void Function(RemoteEvent) onEvent) async {
    final unsubs = <UnsubscribeFunc>[];
    for (final c in const ['list_entries', 'catalog_items', 'users']) {
      unsubs.add(await pb.collection(c).subscribe('*', (e) {
        final record = e.record;
        if (record == null) return;
        onEvent((collection: c, action: e.action, record: record.toJson()));
      }));
    }
    return () async {
      for (final u in unsubs) {
        await u();
      }
    };
  }
}
