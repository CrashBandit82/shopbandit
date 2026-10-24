import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../auth/session.dart';
import '../core/invite_link.dart';
import '../providers.dart';
import 'widgets.dart';

class HouseholdScreen extends ConsumerWidget {
  const HouseholdScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final session = ref.watch(sessionProvider);
    final members = ref.watch(membersProvider).value ?? const [];
    final theme = Theme.of(context);

    return Scaffold(
      appBar: GradientAppBar(title: Text(t.household)),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: Text(session.householdName, style: theme.textTheme.titleLarge),
            subtitle: Text(t.memberCount(members.length)),
            trailing: session.isAdmin
                ? IconButton(
                    tooltip: t.renameHousehold,
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () => _rename(context, session),
                  )
                : null,
          ),
          const Divider(),
          for (final m in members)
            ListTile(
              leading: CircleAvatar(child: Text(m.name.isEmpty ? '?' : m.name.characters.first.toUpperCase())),
              title: Text(m.id == session.userId ? t.youSuffix(m.name) : m.name),
              subtitle: m.id == session.householdOwner ? Text(t.admin) : null,
              trailing: session.isAdmin && m.id != session.userId
                  ? IconButton(
                      tooltip: t.removeMember(m.name),
                      icon: const Icon(Icons.person_remove_outlined),
                      onPressed: () => _remove(context, session, m.id, m.name),
                    )
                  : null,
            ),
          const SizedBox(height: 16),
          if (session.isAdmin)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: FilledButton.icon(
                icon: const Icon(Icons.qr_code_2),
                label: Text(t.inviteMember),
                onPressed: () => _invite(context, session),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: OutlinedButton.icon(
              icon: const Icon(Icons.qr_code_scanner),
              label: Text(t.joinHousehold),
              onPressed: () async {
                final code = await context.push<String>('/household/scan');
                if (code != null && context.mounted) await joinWithCode(context, session, code);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: TextButton.icon(
              icon: const Icon(Icons.keyboard_outlined),
              label: Text(t.enterCode),
              onPressed: () => _enterCode(context, session),
            ),
          ),
          if (members.length > 1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: TextButton.icon(
                style: TextButton.styleFrom(foregroundColor: theme.colorScheme.error),
                icon: const Icon(Icons.logout),
                label: Text(t.leaveHousehold),
                onPressed: () => _leave(context, session),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _rename(BuildContext context, AppSession session) async {
    final t = context.t;
    final c = TextEditingController(text: session.householdName);
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.renameHousehold),
        content: TextField(controller: c, autofocus: true, maxLength: 80),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(t.cancel)),
          FilledButton(onPressed: () => Navigator.pop(context, c.text), child: Text(t.save)),
        ],
      ),
    );
    c.dispose();
    if (name == null || name.trim().isEmpty) return;
    try {
      await session.renameHousehold(name);
    } catch (e) {
      if (context.mounted) showError(context, e);
    }
  }

  Future<void> _remove(BuildContext context, AppSession session, String id, String name) async {
    final t = context.t;
    final ok = await confirm(context, title: t.removeMember(name), message: t.removeMemberMessage(name), action: t.remove);
    if (!ok) return;
    try {
      await session.removeMember(id);
    } catch (e) {
      if (context.mounted) showError(context, e);
    }
  }

  Future<void> _leave(BuildContext context, AppSession session) async {
    final t = context.t;
    final ok = await confirm(context, title: t.leaveHousehold, message: t.leaveHouseholdMessage, action: t.leave);
    if (!ok) return;
    try {
      await session.leaveHousehold();
    } catch (e) {
      if (context.mounted) showError(context, e);
    }
  }

  Future<void> _invite(BuildContext context, AppSession session) async {
    try {
      final invite = await session.createInvite();
      if (!context.mounted) return;
      await showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (_) => _InviteSheet(session: session, invite: invite),
      );
    } catch (e) {
      if (context.mounted) showError(context, e);
    }
  }

  Future<void> _enterCode(BuildContext context, AppSession session) async {
    final t = context.t;
    final c = TextEditingController();
    final code = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.enterCode),
        content: TextField(
          controller: c,
          autofocus: true,
          textCapitalization: TextCapitalization.characters,
          decoration: InputDecoration(hintText: t.inviteCodeHint),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(t.cancel)),
          FilledButton(onPressed: () => Navigator.pop(context, c.text), child: Text(t.next)),
        ],
      ),
    );
    c.dispose();
    if (code != null && context.mounted) await joinWithCode(context, session, code);
  }
}

Future<bool> confirm(BuildContext context, {required String title, required String message, required String action}) async {
  final t = context.t;
  return await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: Text(t.cancel)),
            FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(action)),
          ],
        ),
      ) ??
      false;
}

/// Scanned or typed invite → preview → confirmation → join.
Future<void> joinWithCode(BuildContext context, AppSession session, String code) async {
  final t = context.t;
  final invite = parseInvite(code);
  if (invite == null) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.errorInviteInvalid)));
    return;
  }
  if (invite.server != null && normalizeServerUrl(invite.server!) != session.serverUrl) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.inviteOtherServer(invite.server!))));
    return;
  }
  try {
    final preview = await session.checkInvite(invite.token);
    if (!context.mounted) return;
    if (preview.alreadyMember) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.errorAlreadyMember)));
      return;
    }
    final message = [
      t.joinMessage(preview.householdName, preview.members),
      if (preview.discardsOwn) t.joinDiscardsOwn,
    ].join('\n\n');
    final ok = await confirm(context, title: t.joinHousehold, message: message, action: t.join);
    if (!ok) return;
    await session.acceptInvite(invite.token);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.joined(preview.householdName))));
      context.go('/');
    }
  } catch (e) {
    if (context.mounted) showError(context, e);
  }
}

class _InviteSheet extends StatefulWidget {
  const _InviteSheet({required this.session, required this.invite});

  final AppSession session;
  final Invite invite;

  @override
  State<_InviteSheet> createState() => _InviteSheetState();
}

class _InviteSheetState extends State<_InviteSheet> {
  bool _revoked = false;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final theme = Theme.of(context);
    final link = buildInviteLink(widget.session.serverUrl!, widget.invite.token);
    final expires = DateFormat.yMd(Localizations.localeOf(context).toString()).add_Hm().format(widget.invite.expires.toLocal());
    final token = widget.invite.token;
    final grouped = [for (var i = 0; i < token.length; i += 4) token.substring(i, i + 4)].join('-');

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(t.inviteMember, style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(t.inviteExplain, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            if (_revoked)
              Padding(padding: const EdgeInsets.all(48), child: Text(t.inviteRevoked))
            else ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: QrImageView(
                  data: link,
                  size: 220,
                  semanticsLabel: t.inviteQrLabel,
                  eyeStyle: const QrEyeStyle(eyeShape: QrEyeShape.square, color: Color(0xFF0F1B2D)),
                  dataModuleStyle: const QrDataModuleStyle(dataModuleShape: QrDataModuleShape.square, color: Color(0xFF0F1B2D)),
                ),
              ),
              const SizedBox(height: 12),
              SelectableText(grouped, style: theme.textTheme.titleMedium?.copyWith(fontFamily: 'monospace', letterSpacing: 1)),
              const SizedBox(height: 4),
              Text(t.inviteValidUntil(expires), style: theme.textTheme.bodySmall),
              const SizedBox(height: 16),
              TextButton.icon(
                icon: const Icon(Icons.block),
                label: Text(t.revokeInvite),
                onPressed: () async {
                  try {
                    await widget.session.revokeInvite(widget.invite.id);
                    setState(() => _revoked = true);
                  } catch (e) {
                    if (context.mounted) showError(context, e);
                  }
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
