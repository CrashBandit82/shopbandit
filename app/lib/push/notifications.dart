import 'dart:ui';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/session.dart';
import '../l10n/app_localizations.dart';

final _plugin = FlutterLocalNotificationsPlugin();
bool _initialized = false;

Future<void> initNotifications() async {
  if (_initialized) return;
  await _plugin.initialize(
    settings: const InitializationSettings(
      android: AndroidInitializationSettings('ic_notification'),
    ),
  );
  _initialized = true;
}

Future<bool> requestNotificationPermission() async {
  await initNotifications();
  final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
  return await android?.requestNotificationsPermission() ?? true;
}

/// Language for texts shown outside the UI (background isolate).
AppLocalizations notificationTexts(SharedPreferences prefs) {
  final code = prefs.getString(Prefs.locale) ?? PlatformDispatcher.instance.locale.languageCode;
  final supported = AppLocalizations.supportedLocales.map((l) => l.languageCode);
  return lookupAppLocalizations(Locale(supported.contains(code) ? code : 'en'));
}

/// "Anna added 3 items" – one bundled notification, replaced on update.
Future<void> showItemsAdded(SharedPreferences prefs, List<String> by, int count) async {
  if (count <= 0 || prefs.getBool(Prefs.notifications) == false) return;
  await initNotifications();
  final t = notificationTexts(prefs);
  final who = by.isEmpty ? t.someone : by.join(', ');
  await _plugin.show(
    id: 1,
    title: t.appTitle,
    body: t.notifyItemsAdded(who, count),
    notificationDetails: NotificationDetails(
      android: AndroidNotificationDetails(
        'list_changes',
        t.notifyChannelName,
        channelDescription: t.notifyChannelDescription,
        importance: Importance.defaultImportance,
        color: const Color(0xFF2162B6),
      ),
    ),
  );
}
