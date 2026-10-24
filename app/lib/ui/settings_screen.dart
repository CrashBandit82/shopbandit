import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/constants.dart';
import '../providers.dart';
import '../push/push_service.dart';
import 'household_screen.dart' show confirm;
import 'widgets.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  PushMode? _push;

  @override
  void initState() {
    super.initState();
    PushService.instance.currentMode().then((m) {
      if (mounted) setState(() => _push = m);
    });
  }

  Future<void> _togglePush(bool on) async {
    final t = context.t;
    final messenger = ScaffoldMessenger.of(context);
    if (!on) {
      await PushService.instance.disable();
      setState(() => _push = PushMode.off);
      return;
    }
    final distributors = await PushService.instance.distributors();
    String? chosen;
    if (distributors.length > 1 && mounted) {
      chosen = await showDialog<String>(
        context: context,
        builder: (context) => SimpleDialog(
          title: Text(t.chooseDistributor),
          children: [
            for (final d in distributors)
              SimpleDialogOption(onPressed: () => Navigator.pop(context, d), child: Text(d)),
          ],
        ),
      );
      if (chosen == null) return;
    }
    final mode = await PushService.instance.enable(distributor: chosen);
    if (!mounted) return;
    setState(() => _push = mode);
    if (mode == PushMode.polling) {
      messenger.showSnackBar(SnackBar(content: Text(t.pushPollingHint), duration: const Duration(seconds: 6)));
    }
  }

  Future<void> _editName() async {
    final t = context.t;
    final session = ref.read(sessionProvider);
    final c = TextEditingController(text: session.user?.getStringValue('name'));
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.displayName),
        content: TextField(controller: c, autofocus: true, textCapitalization: TextCapitalization.words),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(t.cancel)),
          FilledButton(onPressed: () => Navigator.pop(context, c.text), child: Text(t.save)),
        ],
      ),
    );
    c.dispose();
    if (name == null || name.trim().isEmpty) return;
    try {
      await session.updateName(name);
    } catch (e) {
      if (mounted) showError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final session = ref.watch(sessionProvider);
    final locale = ref.watch(localeProvider);
    final user = session.user;
    final verified = user?.getBoolValue('verified') ?? false;
    final pushLabel = switch (_push) {
      PushMode.unifiedPush => t.pushModeUnifiedPush,
      PushMode.polling => t.pushModePolling,
      _ => t.pushModeOff,
    };

    return Scaffold(
      appBar: GradientAppBar(title: Text(t.settings)),
      body: ListView(
        children: [
          _Section(t.account),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text(user?.getStringValue('name') ?? ''),
            subtitle: Text(user?.getStringValue('email') ?? ''),
            trailing: const Icon(Icons.edit_outlined),
            onTap: _editName,
          ),
          if (!verified)
            ListTile(
              leading: const Icon(Icons.mark_email_unread_outlined),
              title: Text(t.emailNotVerified),
              subtitle: Text(t.resendVerification),
              onTap: () async {
                final messenger = ScaffoldMessenger.of(context);
                try {
                  await session.resendVerification();
                  messenger.showSnackBar(SnackBar(content: Text(t.verificationSent)));
                } catch (e) {
                  if (context.mounted) showError(context, e);
                }
              },
            ),
          _Section(t.notifications),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_outlined),
            title: Text(t.notifyOnAdd),
            subtitle: Text(pushLabel),
            value: _push != null && _push != PushMode.off,
            onChanged: _push == null ? null : _togglePush,
          ),
          _Section(t.list),
          ListTile(
            leading: const Icon(Icons.inventory_2_outlined),
            title: Text(t.manageCatalog),
            subtitle: Text(t.manageCatalogHint),
            onTap: () => context.push('/settings/catalog'),
          ),
          _Section(t.language),
          RadioGroup<String>(
            groupValue: locale?.languageCode ?? 'system',
            onChanged: (v) => ref.read(localeProvider.notifier).set(v == 'system' ? null : v),
            child: Column(
              children: [
                RadioListTile(value: 'system', title: Text(t.languageSystem)),
                const RadioListTile(value: 'de', title: Text('Deutsch')),
                const RadioListTile(value: 'en', title: Text('English')),
              ],
            ),
          ),
          _Section(t.server),
          ListTile(
            leading: const Icon(Icons.dns_outlined),
            title: Text(session.serverUrl ?? ''),
            subtitle: Text(t.changeServerHint),
            onTap: () async {
              final ok = await confirm(context, title: t.changeServer, message: t.changeServerMessage, action: t.logout);
              if (!ok) return;
              await PushService.instance.disable();
              await session.logout();
              if (context.mounted) context.go('/server');
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(t.logout),
            onTap: () async {
              final ok = await confirm(context, title: t.logout, message: t.logoutMessage, action: t.logout);
              if (!ok) return;
              await PushService.instance.disable();
              await session.logout();
            },
          ),
          _Section(t.about),
          AboutListTile(
            icon: const Icon(Icons.info_outline),
            applicationName: AppInfo.name,
            applicationLegalese: 'GPL-3.0 · ${AppInfo.sourceUrl}',
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
      child: Semantics(
        header: true,
        child: Text(
          title,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}

/// Lists all catalog items; swipe or tap the bin to remove one.
class CatalogScreen extends ConsumerWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final items = ref.watch(catalogProvider).value ?? const [];
    final repo = ref.watch(sessionProvider.select((s) => s.repo));
    return Scaffold(
      appBar: GradientAppBar(title: Text(t.manageCatalog)),
      body: items.isEmpty
          ? EmptyState(title: t.catalogEmptyTitle, message: t.catalogEmptyMessage)
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, i) {
                final c = items[i];
                return ListTile(
                  title: Text(c.name),
                  subtitle: Text(t.boughtTimes(c.purchaseCount)),
                  trailing: IconButton(
                    tooltip: t.deleteNamed(c.name),
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () async {
                      final ok = await confirm(context, title: t.deleteNamed(c.name), message: t.deleteCatalogMessage, action: t.delete);
                      if (ok) await repo?.deleteCatalogItem(c.id);
                    },
                  ),
                );
              },
            ),
    );
  }
}
