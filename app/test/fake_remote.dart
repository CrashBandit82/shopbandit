import 'package:shopbandit/data/remote.dart';

/// In-memory server: applies creates/updates like PocketBase incl. the
/// `field+` / `field-` modifiers and keeps an `updated` timestamp.
class FakeRemote implements SyncRemote {
  final records = <String, Map<String, Map<String, dynamic>>>{
    'catalog_items': {},
    'list_entries': {},
  };
  final users = <Map<String, dynamic>>[];
  bool online = true;
  int _tick = 0;
  final calls = <String>[];

  String _stamp() => '2026-10-24 10:00:${(_tick++).toString().padLeft(2, '0')}.000Z';

  void _check() {
    if (!online) throw RemoteUnreachable('offline');
  }

  @override
  Future<void> create(String collection, Map<String, dynamic> body) async {
    _check();
    calls.add('create $collection ${body['id']}');
    final id = body['id'] as String;
    if (records[collection]!.containsKey(id)) throw RemoteRejected(400, {'id': 'exists'});
    final now = _stamp();
    records[collection]![id] = {...body, 'created': now, 'updated': now};
  }

  @override
  Future<void> update(String collection, String id, Map<String, dynamic> body) async {
    _check();
    calls.add('update $collection $id');
    final r = records[collection]![id];
    if (r == null) throw RemoteRejected(404);
    body.forEach((k, v) {
      if (k.endsWith('+')) {
        final f = k.substring(0, k.length - 1);
        r[f] = ((r[f] as num?) ?? 0) + (v as num);
      } else if (k.endsWith('-')) {
        final f = k.substring(0, k.length - 1);
        r[f] = ((r[f] as num?) ?? 0) - (v as num);
      } else {
        r[k] = v;
      }
    });
    r['updated'] = _stamp();
  }

  @override
  Future<List<Map<String, dynamic>>> listSince(String collection, String since) async {
    _check();
    final all = records[collection]!.values.where((r) => (r['updated'] as String).compareTo(since) >= 0).toList()
      ..sort((a, b) => (a['updated'] as String).compareTo(b['updated'] as String));
    return all.map((r) => Map<String, dynamic>.of(r)).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> members() async {
    _check();
    return users;
  }
}
