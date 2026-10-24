import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'auth/session.dart';
import 'data/db.dart';
import 'providers.dart';
import 'push/notifications.dart';
import 'push/push_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final session = AppSession(prefs: prefs, db: AppDatabase());
  PushService.instance.attach(session);
  // Push/notification setup must never block the app start.
  try {
    await initPushCallbacks(onListChanged: () => session.sync?.sync());
    await initNotifications();
  } catch (e) {
    debugPrint('notification setup failed: $e');
  }
  await session.init();
  unawaited(PushService.instance.resume());

  runApp(ProviderScope(
    overrides: [sessionProvider.overrideWith((ref) => session)],
    child: const ShopBanditApp(),
  ));
}
