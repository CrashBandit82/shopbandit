import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unifiedpush_platform_interface/unifiedpush_platform_interface.dart';
import 'package:workmanager/workmanager.dart';

import '../auth/session.dart';
import 'notifications.dart';

const _pollTask = 'shopbandit-poll';
const _instance = 'default';

// Talks to unifiedpush_android directly: the `unifiedpush` wrapper package
// also pulls in the Linux implementation with a native BoringSSL build.
UnifiedPushPlatform get _up => UnifiedPushPlatform.instance;

enum PushMode { off, unifiedPush, polling }

/// Must run before runApp: the UnifiedPush receiver may start the app in the
/// background just to deliver a message.
Future<void> initPushCallbacks({required void Function() onListChanged}) async {
  await _up.initializeCallback(
    onNewEndpoint: (endpoint, _) => PushService.instance._onNewEndpoint(endpoint.url),
    onRegistrationFailed: (_, _) {},
    onUnregistered: (_) => PushService.instance._onUnregistered(),
    onMessage: (message, _) async {
      final prefs = await SharedPreferences.getInstance();
      final data = _decode(message.content);
      if (data['type'] != 'items_added') return;
      onListChanged();
      // app open: the list updates live, no notification needed
      if (WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed) return;
      await showItemsAdded(
        prefs,
        (data['by'] as List? ?? const []).map((e) => e.toString()).toList(),
        (data['count'] as num?)?.toInt() ?? 0,
      );
    },
  );
  await Workmanager().initialize(pollCallbackDispatcher);
}

Map<String, dynamic> _decode(List<int> bytes) {
  try {
    return (jsonDecode(utf8.decode(bytes)) as Map).cast<String, dynamic>();
  } catch (_) {
    return const {};
  }
}

/// Registers the device for notifications: UnifiedPush when a distributor
/// app (e.g. ntfy) is installed, otherwise periodic polling via WorkManager.
class PushService {
  PushService._();
  static final instance = PushService._();

  AppSession? _session;

  void attach(AppSession session) => _session = session;

  Future<List<String>> distributors() => _up.getDistributors(const []);

  Future<PushMode> currentMode() async {
    final prefs = _session!.prefs;
    if (prefs.getBool(Prefs.notifications) != true) return PushMode.off;
    return await _up.getDistributor() != null ? PushMode.unifiedPush : PushMode.polling;
  }

  /// Turns notifications on. [distributor] picks one of [distributors()].
  Future<PushMode> enable({String? distributor}) async {
    final prefs = _session!.prefs;
    await requestNotificationPermission();
    await prefs.setBool(Prefs.notifications, true);
    if (distributor != null) await _up.saveDistributor(distributor);
    final hasDistributor = distributor != null || await _up.tryUseCurrentOrDefaultDistributor();
    if (hasDistributor) {
      await Workmanager().cancelByUniqueName(_pollTask);
      await _up.register(_instance, const [], null, null);
      return PushMode.unifiedPush;
    }
    await prefs.setString(Prefs.lastPoll, DateTime.now().toUtc().toIso8601String());
    await Workmanager().registerPeriodicTask(
      _pollTask,
      _pollTask,
      frequency: const Duration(minutes: 15),
      constraints: Constraints(networkType: NetworkType.connected),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
    );
    return PushMode.polling;
  }

  Future<void> disable() async {
    await _session?.prefs.setBool(Prefs.notifications, false);
    await Workmanager().cancelByUniqueName(_pollTask);
    if (await _up.getDistributor() != null) await _up.unregister(_instance);
    await _deleteEndpointRecord();
  }

  /// Re-register on every app start (UnifiedPush requirement).
  Future<void> resume() async {
    if (_session?.prefs.getBool(Prefs.notifications) != true) return;
    if (await _up.getDistributor() != null) await _up.register(_instance, const [], null, null);
  }

  Future<void> _onNewEndpoint(String url) async {
    final s = _session;
    if (s == null || s.pb == null || !s.loggedIn) return;
    await _deleteEndpointRecord();
    try {
      final r = await s.pb!.collection('push_endpoints').create(body: {'user': s.userId, 'endpoint_url': url});
      await s.prefs.setString(Prefs.pushRecordId, r.id);
    } on ClientException catch (e) {
      debugPrint('push endpoint rejected: ${e.response}');
    }
  }

  Future<void> _onUnregistered() => _deleteEndpointRecord();

  Future<void> _deleteEndpointRecord() async {
    final s = _session;
    final id = s?.prefs.getString(Prefs.pushRecordId);
    if (s == null || id == null) return;
    try {
      await s.pb?.collection('push_endpoints').delete(id);
    } catch (_) {}
    await s.prefs.remove(Prefs.pushRecordId);
  }
}

/// WorkManager fallback without a UnifiedPush distributor: checks every
/// ~15 minutes for entries other members added since the last check.
@pragma('vm:entry-point')
void pollCallbackDispatcher() {
  Workmanager().executeTask((task, _) async {
    WidgetsFlutterBinding.ensureInitialized();
    final prefs = await SharedPreferences.getInstance();
    final url = prefs.getString(Prefs.serverUrl);
    if (url == null || prefs.getBool(Prefs.notifications) != true) return true;
    const secure = FlutterSecureStorage();
    final pb = PocketBase(
      url,
      authStore: AsyncAuthStore(
        initial: await secure.read(key: authStorageKey),
        save: (data) => secure.write(key: authStorageKey, value: data),
      ),
    );
    if (!pb.authStore.isValid) return true;
    final me = pb.authStore.record!.id;
    final since = prefs.getString(Prefs.lastPoll) ?? DateTime.now().toUtc().toIso8601String();
    final now = DateTime.now().toUtc().toIso8601String();
    try {
      final entries = await pb.collection('list_entries').getFullList(
            fields: 'added_by',
            filter: pb.filter(
              'created > {:since} && added_by != {:me} && deleted = false && checked = false',
              {'since': since.replaceFirst('T', ' '), 'me': me},
            ),
          );
      await prefs.setString(Prefs.lastPoll, now);
      if (entries.isEmpty) return true;
      final users = await pb.collection('users').getFullList(fields: 'id,name');
      final names = {for (final u in users) u.id: u.getStringValue('name')};
      final by = entries.map((e) => names[e.getStringValue('added_by')] ?? '').where((n) => n.isNotEmpty).toSet().toList();
      await showItemsAdded(prefs, by, entries.length);
    } catch (_) {
      // offline or token expired: try again next round
    }
    return true;
  });
}
