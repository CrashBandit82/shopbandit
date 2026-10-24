import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import 'auth/session.dart';
import 'data/db.dart';
import 'data/repository.dart';
import 'data/sync_service.dart';

/// Overridden in main() with the initialized session.
final sessionProvider = ChangeNotifierProvider<AppSession>((ref) => throw UnimplementedError());

final listProvider = StreamProvider<List<ListRow>>((ref) {
  final repo = ref.watch(sessionProvider.select((s) => s.repo));
  return repo?.watchList() ?? const Stream.empty();
});

final catalogProvider = StreamProvider<List<CatalogItem>>((ref) {
  final repo = ref.watch(sessionProvider.select((s) => s.repo));
  return repo?.watchCatalog() ?? const Stream.empty();
});

final membersProvider = StreamProvider<List<Member>>((ref) {
  final repo = ref.watch(sessionProvider.select((s) => s.repo));
  return repo?.watchMembers() ?? const Stream.empty();
});

final syncStateProvider = StreamProvider<SyncState>((ref) async* {
  final sync = ref.watch(sessionProvider.select((s) => s.sync));
  if (sync == null) return;
  yield sync.state;
  yield* sync.states;
});

final pendingCountProvider = StreamProvider<int>((ref) {
  final s = ref.watch(sessionProvider);
  return s.db.watchPendingCount();
});

/// null = follow the system language.
class LocaleNotifier extends Notifier<Locale?> {
  @override
  Locale? build() {
    final code = ref.read(sessionProvider).prefs.getString(Prefs.locale);
    return code == null ? null : Locale(code);
  }

  Future<void> set(String? code) async {
    final prefs = ref.read(sessionProvider).prefs;
    code == null ? await prefs.remove(Prefs.locale) : await prefs.setString(Prefs.locale, code);
    state = code == null ? null : Locale(code);
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale?>(LocaleNotifier.new);
