import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/db.dart';
import '../data/remote.dart';
import '../data/repository.dart';
import '../data/sync_service.dart';

const authStorageKey = 'pb_auth';

/// Keys in SharedPreferences.
abstract final class Prefs {
  static const serverUrl = 'server_url';
  static const locale = 'locale';
  static const notifications = 'notifications';
  static const pushRecordId = 'push_record_id';
  static const lastPoll = 'last_poll';
}

/// Normalizes user input like "shop.example.com/" to "https://shop.example.com".
String normalizeServerUrl(String input) {
  var s = input.trim();
  if (s.isEmpty) return s;
  if (!s.contains('://')) s = 'https://$s';
  while (s.endsWith('/')) {
    s = s.substring(0, s.length - 1);
  }
  return s;
}

typedef InvitePreview = ({String householdName, int members, bool alreadyMember, bool discardsOwn});
typedef Invite = ({String id, String token, DateTime expires});

/// Login state, server connection and household actions.
/// Owns the [SyncService]/[ShopRepository] of the logged-in user.
class AppSession extends ChangeNotifier {
  AppSession({required this.prefs, required this.db, FlutterSecureStorage? secure})
      : secure = secure ?? const FlutterSecureStorage();

  final SharedPreferences prefs;
  final AppDatabase db;
  final FlutterSecureStorage secure;

  PocketBase? pb;
  SyncService? sync;
  ShopRepository? repo;
  String householdName = '';
  String householdOwner = '';
  Future<void> Function()? _unsubscribe;
  Timer? _syncTimer;

  String? get serverUrl => prefs.getString(Prefs.serverUrl);
  RecordModel? get user => pb?.authStore.record;
  bool get loggedIn => pb != null && pb!.authStore.isValid && repo != null;
  String get userId => user?.id ?? '';
  String get household => user?.getStringValue('household') ?? '';
  bool get isAdmin => householdOwner.isNotEmpty && householdOwner == userId;

  Future<void> init() async {
    final url = serverUrl;
    if (url == null) return;
    await _connect(url);
    if (pb!.authStore.isValid && household.isNotEmpty) {
      await _startSession();
      unawaited(refresh());
    }
  }

  Future<void> _connect(String url) async {
    final initial = await secure.read(key: authStorageKey);
    pb = PocketBase(
      url,
      lang: PlatformDispatcher.instance.locale.languageCode,
      authStore: AsyncAuthStore(
        initial: initial,
        save: (data) => secure.write(key: authStorageKey, value: data),
        clear: () => secure.delete(key: authStorageKey),
      ),
    );
  }

  /// Checks `/api/health` and stores the server URL.
  Future<bool> setServer(String input) async {
    final url = normalizeServerUrl(input);
    try {
      final res = await http.get(Uri.parse('$url/api/health')).timeout(const Duration(seconds: 10));
      if (res.statusCode != 200) return false;
    } catch (_) {
      return false;
    }
    if (url != serverUrl) {
      await logout();
      await prefs.setString(Prefs.serverUrl, url);
      await _connect(url);
    }
    notifyListeners();
    return true;
  }

  // ---------------------------------------------------------------- auth --

  Future<void> login(String email, String password) async {
    await pb!.collection('users').authWithPassword(email.trim(), password);
    await _startSession();
  }

  Future<void> register(String name, String email, String password) async {
    await pb!.collection('users').create(body: {
      'name': name.trim(),
      'email': email.trim(),
      'password': password,
      'passwordConfirm': password,
    });
    unawaited(pb!.collection('users').requestVerification(email.trim()).catchError((_) {}));
    await login(email, password);
  }

  Future<void> requestPasswordReset(String email) =>
      pb!.collection('users').requestPasswordReset(email.trim());

  Future<void> resendVerification() =>
      pb!.collection('users').requestVerification(user!.getStringValue('email'));

  Future<void> logout() async {
    await _stopSession();
    pb?.authStore.clear();
    await db.clearAll();
    notifyListeners();
  }

  Future<void> updateName(String name) async {
    await pb!.collection('users').update(userId, body: {'name': name.trim()});
    await refresh();
  }

  // ------------------------------------------------------------- session --

  Future<void> _startSession() async {
    await _stopSession();
    final client = pb!;
    final h = household;
    if (await db.getMeta('household') != h || await db.getMeta('user') != userId) {
      // other household or user than the local data belongs to
      await db.clearAll();
      await db.setMeta('household', h);
      await db.setMeta('user', userId);
    }
    final remote = PocketBaseRemote(client);
    sync = SyncService(db, remote);
    repo = ShopRepository(db, sync!, household: h, userId: userId);
    notifyListeners();

    unawaited(_loadHousehold());
    unawaited(sync!.sync());
    unawaited(_subscribe(remote));
    _syncTimer = Timer.periodic(const Duration(minutes: 2), (_) => sync?.sync());
  }

  Future<void> _subscribe(PocketBaseRemote remote) async {
    try {
      _unsubscribe = await remote.subscribe((e) => sync?.applyEvent(e));
      // reconnects of the realtime connection → catch up on missed changes
      final unsubConnect = await remote.pb.realtime.subscribe('PB_CONNECT', (_) => sync?.sync());
      final unsubData = _unsubscribe;
      _unsubscribe = () async {
        await unsubData?.call();
        await unsubConnect();
      };
    } catch (_) {
      // offline: the periodic sync and the next resume take over
    }
  }

  Future<void> _stopSession() async {
    _syncTimer?.cancel();
    _syncTimer = null;
    final u = _unsubscribe;
    _unsubscribe = null;
    if (u != null) await u().catchError((_) {});
    await sync?.dispose();
    sync = null;
    repo = null;
  }

  Future<void> _loadHousehold() async {
    try {
      final h = await pb!.collection('households').getOne(household);
      householdName = h.getStringValue('name');
      householdOwner = h.getStringValue('owner');
      notifyListeners();
    } catch (_) {}
  }

  /// Refreshes the auth record (household may have changed on the server)
  /// and syncs. Called on app start and resume.
  Future<void> refresh() async {
    final client = pb;
    if (client == null || !client.authStore.isValid) return;
    final before = household;
    try {
      await client.collection('users').authRefresh();
    } on ClientException catch (e) {
      if (e.statusCode == 401 || e.statusCode == 403 || e.statusCode == 404) {
        await logout();
      }
      return;
    }
    if (household != before || repo == null) {
      await _startSession();
    } else {
      await sync?.resetBackoff();
      unawaited(sync?.sync());
      unawaited(_loadHousehold());
      notifyListeners();
    }
  }

  // ----------------------------------------------------------- household --

  Future<Map<String, dynamic>> _post(String path, [Map<String, dynamic> body = const {}]) async {
    final res = await pb!.send<dynamic>(path, method: 'POST', body: body);
    return (res as Map).cast<String, dynamic>();
  }

  Future<Invite> createInvite() async {
    final r = await _post('/api/shopbandit/invites/create');
    return (id: r['id'] as String, token: r['token'] as String, expires: DateTime.parse(r['expires'] as String));
  }

  Future<void> revokeInvite(String id) => _post('/api/shopbandit/invites/revoke', {'id': id});

  Future<InvitePreview> checkInvite(String token) async {
    final r = await _post('/api/shopbandit/invites/check', {'token': token});
    return (
      householdName: r['household_name'] as String,
      members: (r['members'] as num).toInt(),
      alreadyMember: r['already_member'] == true,
      discardsOwn: r['discards_own'] == true,
    );
  }

  Future<void> acceptInvite(String token) async {
    await sync?.sync(); // push pending changes of the old household first
    await _post('/api/shopbandit/invites/accept', {'token': token});
    await refresh();
  }

  Future<void> leaveHousehold() async {
    await sync?.sync();
    await _post('/api/shopbandit/household/leave');
    await refresh();
  }

  Future<void> removeMember(String memberId) async {
    await _post('/api/shopbandit/household/remove', {'user': memberId});
    await sync?.sync();
  }

  Future<void> renameHousehold(String name) async {
    await pb!.collection('households').update(household, body: {'name': name.trim()});
    await _loadHousehold();
  }

  @override
  void dispose() {
    unawaited(_stopSession());
    super.dispose();
  }
}
