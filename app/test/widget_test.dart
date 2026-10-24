import 'package:drift/drift.dart' show DatabaseConnection, driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopbandit/auth/session.dart';
import 'package:shopbandit/data/db.dart';
import 'package:shopbandit/data/repository.dart';
import 'package:shopbandit/data/sync_service.dart';
import 'package:shopbandit/l10n/app_localizations.dart';
import 'package:shopbandit/providers.dart';
import 'package:shopbandit/ui/auth_screens.dart';
import 'package:shopbandit/ui/list_screen.dart';
import 'package:shopbandit/ui/theme.dart';

import 'fake_remote.dart';

Future<AppSession> _session({bool withRepo = false}) async {
  SharedPreferences.setMockInitialValues({Prefs.serverUrl: 'https://shop.example.com'});
  final db = AppDatabase(DatabaseConnection(NativeDatabase.memory(), closeStreamsSynchronously: true));
  final session = AppSession(prefs: await SharedPreferences.getInstance(), db: db);
  if (withRepo) {
    final remote = FakeRemote()..online = false;
    session.sync = SyncService(db, remote);
    session.repo = ShopRepository(db, session.sync!, household: 'h1', userId: 'u1');
  }
  return session;
}

Widget _app(AppSession session, Widget home) => ProviderScope(
      overrides: [sessionProvider.overrideWith((ref) => session)],
      child: MaterialApp(
        locale: const Locale('de'),
        theme: buildTheme(Brightness.light),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: home,
      ),
    );

// The in-memory DB is not closed: closing inside the fake-async test zone
// never completes. Streams close synchronously, so no timers stay pending.
Future<void> _dispose(WidgetTester tester, AppSession session) => tester.pumpWidget(const SizedBox());

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  testWidgets('login validates input before calling the server', (tester) async {
    final session = await _session();
    await tester.pumpWidget(_app(session, const LoginScreen()));
    await tester.tap(find.text('Anmelden'));
    await tester.pump();
    expect(find.text('Bitte eine gültige E-Mail-Adresse eingeben'), findsOneWidget);
    expect(find.text('Bitte Passwort eingeben'), findsOneWidget);
    await _dispose(tester, session);
  });

  testWidgets('register shows live password feedback', (tester) async {
    final session = await _session();
    await tester.pumpWidget(_app(session, const RegisterScreen()));
    final pw = find.widgetWithText(TextFormField, 'Passwort');
    expect(find.byIcon(Icons.check_circle), findsNothing);
    await tester.enterText(pw, 'abc');
    await tester.pump();
    expect(find.byIcon(Icons.check_circle), findsOneWidget); // lowercase only
    await tester.enterText(pw, 'Abcdefg1!');
    await tester.pump();
    expect(find.byIcon(Icons.check_circle), findsNWidgets(5));
    await _dispose(tester, session);
  });

  testWidgets('list: add, show quantity, check off with undo', (tester) async {
    final session = await _session(withRepo: true);
    await tester.pumpWidget(_app(session, const ListScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Alles erledigt!'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextField, 'Was fehlt?'), 'Milch');
    await tester.enterText(find.widgetWithText(TextField, 'Menge'), '2 l');
    await tester.tap(find.byTooltip('Hinzufügen'));
    await tester.pumpAndSettle();
    expect(find.text('Milch'), findsOneWidget);
    expect(find.text('2 l'), findsOneWidget);

    await tester.tap(find.byTooltip('Milch als gekauft markieren'));
    await tester.pumpAndSettle();
    expect(find.text('Alles erledigt!'), findsOneWidget);
    expect(find.text('Milch gekauft'), findsOneWidget);

    await tester.tap(find.text('Rückgängig'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(ListTile, 'Milch'), findsOneWidget);
    await _dispose(tester, session);
  });
}
