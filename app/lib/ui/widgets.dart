import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocketbase/pocketbase.dart';

import '../core/password_rules.dart';
import '../data/sync_service.dart';
import '../l10n/app_localizations.dart';
import '../providers.dart';
import 'theme.dart';

extension L10nContext on BuildContext {
  AppLocalizations get t => AppLocalizations.of(this);
}

/// User facing text for an API error.
String errorText(AppLocalizations t, Object error) {
  if (error is ClientException) {
    if (error.statusCode == 0) return t.errorOffline;
    final msg = error.response['message']?.toString() ?? '';
    final data = error.response['data'];
    if (msg == 'invite_invalid') return t.errorInviteInvalid;
    if (msg == 'invite_expired') return t.errorInviteExpired;
    if (msg == 'already_member') return t.errorAlreadyMember;
    if (msg == 'only_member') return t.errorOnlyMember;
    if (data is Map && data.containsKey('password')) return t.errorPasswordRules;
    if (data is Map && data.containsKey('email')) return t.errorEmailTaken;
    if (error.statusCode == 400 && error.url?.path.endsWith('auth-with-password') == true) {
      return t.errorLoginFailed;
    }
    if (error.statusCode == 429) return t.errorTooManyRequests;
    if (error.statusCode == 403) return t.errorForbidden;
  }
  return t.errorGeneric;
}

void showError(BuildContext context, Object error) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorText(context.t, error))));
}

/// Gradient header (cyan → blue like the icon) used on the main screens.
class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  const GradientAppBar({super.key, required this.title, this.actions = const [], this.leading});

  final Widget title;
  final List<Widget> actions;
  final Widget? leading;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      leading: leading,
      actions: actions,
      foregroundColor: Colors.white,
      backgroundColor: Colors.transparent,
      flexibleSpace: const DecoratedBox(decoration: BoxDecoration(gradient: Brand.headerGradient)),
    );
  }
}

/// Small cloud icon: synchronized / pending / offline.
class SyncIndicator extends ConsumerWidget {
  const SyncIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final state = ref.watch(syncStateProvider).value ?? SyncState.idle;
    final pending = ref.watch(pendingCountProvider).value ?? 0;
    final (icon, label) = switch (state) {
      SyncState.offline => (Icons.cloud_off_outlined, t.syncOffline(pending)),
      SyncState.error => (Icons.sync_problem_outlined, t.syncError),
      SyncState.syncing => (Icons.cloud_sync_outlined, t.syncRunning),
      SyncState.idle when pending > 0 => (Icons.cloud_upload_outlined, t.syncPending(pending)),
      SyncState.idle => (Icons.cloud_done_outlined, t.syncDone),
    };
    return IconButton(
      tooltip: label,
      icon: Icon(icon, semanticLabel: label),
      onPressed: () {
        ref.read(sessionProvider).refresh();
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(label), duration: const Duration(seconds: 2)));
      },
    );
  }
}

/// Mascot + friendly text for empty screens.
class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ExcludeSemantics(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Image.asset('assets/branding/mascot.png', width: 132, height: 132),
              ),
            ),
            const SizedBox(height: 20),
            Text(title, style: theme.textTheme.titleLarge, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Live feedback for the password rule while typing.
class PasswordChecklist extends StatelessWidget {
  const PasswordChecklist({super.key, required this.password});

  final String password;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final problems = passwordProblems(password);
    final labels = {
      PasswordRule.minLength: t.pwRuleLength(passwordMinLength),
      PasswordRule.uppercase: t.pwRuleUpper,
      PasswordRule.lowercase: t.pwRuleLower,
      PasswordRule.digit: t.pwRuleDigit,
      PasswordRule.special: t.pwRuleSpecial,
    };
    final ok = context.shopColors.success;
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final e in labels.entries)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                Icon(
                  problems.contains(e.key) ? Icons.radio_button_unchecked : Icons.check_circle,
                  size: 18,
                  color: problems.contains(e.key) ? muted : ok,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    e.value,
                    semanticsLabel: '${e.value}: ${problems.contains(e.key) ? t.pwRuleMissing : t.pwRuleOk}',
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Centered, width-limited form layout for the auth screens.
class FormPage extends StatelessWidget {
  const FormPage({super.key, required this.children, this.appBar});

  final List<Widget> children;
  final PreferredSizeWidget? appBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children),
            ),
          ),
        ),
      ),
    );
  }
}

/// Logo tile for the auth screens.
class LogoHeader extends StatelessWidget {
  const LogoHeader({super.key, required this.subtitle});

  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        ExcludeSemantics(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Image.asset('assets/branding/mascot.png', width: 112, height: 112),
          ),
        ),
        const SizedBox(height: 16),
        Text(context.t.appTitle, style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text(subtitle, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        const SizedBox(height: 28),
      ],
    );
  }
}
