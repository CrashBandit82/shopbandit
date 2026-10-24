import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'auth/session.dart';
import 'core/constants.dart';
import 'l10n/app_localizations.dart';
import 'providers.dart';
import 'ui/auth_screens.dart';
import 'ui/household_screen.dart';
import 'ui/list_screen.dart';
import 'ui/scan_screen.dart';
import 'ui/server_screen.dart';
import 'ui/settings_screen.dart';
import 'ui/theme.dart';

const _authRoutes = {'/server', '/login', '/register', '/forgot'};

GoRouter buildRouter(AppSession session) => GoRouter(
      refreshListenable: session,
      initialLocation: '/',
      redirect: (context, state) {
        final loc = state.matchedLocation;
        if (session.serverUrl == null) return loc == '/server' ? null : '/server';
        if (!session.loggedIn) return _authRoutes.contains(loc) ? null : '/login';
        if (_authRoutes.contains(loc)) return '/';
        return null;
      },
      routes: [
        GoRoute(path: '/server', builder: (_, _) => const ServerScreen()),
        GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
        GoRoute(path: '/register', builder: (_, _) => const RegisterScreen()),
        GoRoute(path: '/forgot', builder: (_, _) => const ForgotPasswordScreen()),
        GoRoute(path: '/', builder: (_, _) => const ListScreen(), routes: [
          GoRoute(path: 'household', builder: (_, _) => const HouseholdScreen(), routes: [
            GoRoute(path: 'scan', builder: (_, _) => const ScanScreen()),
          ]),
          GoRoute(path: 'settings', builder: (_, _) => const SettingsScreen(), routes: [
            GoRoute(path: 'catalog', builder: (_, _) => const CatalogScreen()),
          ]),
        ]),
      ],
    );

class ShopBanditApp extends ConsumerStatefulWidget {
  const ShopBanditApp({super.key});

  @override
  ConsumerState<ShopBanditApp> createState() => _ShopBanditAppState();
}

class _ShopBanditAppState extends ConsumerState<ShopBanditApp> with WidgetsBindingObserver {
  late final GoRouter _router = buildRouter(ref.read(sessionProvider));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) unawaited(ref.read(sessionProvider).refresh());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppInfo.name,
      debugShowCheckedModeBanner: false,
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      themeMode: ThemeMode.system,
      locale: ref.watch(localeProvider),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: _router,
    );
  }
}
