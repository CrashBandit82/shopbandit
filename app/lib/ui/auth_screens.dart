import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/password_rules.dart';
import '../providers.dart';
import 'widgets.dart';

final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _busy = true);
    try {
      await ref.read(sessionProvider).login(_email.text, _password.text);
    } catch (e) {
      if (mounted) showError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final server = ref.watch(sessionProvider.select((s) => s.serverUrl)) ?? '';
    return FormPage(
      children: [
        LogoHeader(subtitle: t.loginSubtitle),
        Form(
          key: _form,
          child: AutofillGroup(
            child: Column(
              children: [
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  decoration: InputDecoration(labelText: t.email, prefixIcon: const Icon(Icons.mail_outline)),
                  validator: (v) => _emailPattern.hasMatch(v?.trim() ?? '') ? null : t.emailInvalid,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _password,
                  obscureText: _obscure,
                  autofillHints: const [AutofillHints.password],
                  decoration: InputDecoration(
                    labelText: t.password,
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      tooltip: _obscure ? t.showPassword : t.hidePassword,
                      icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  validator: (v) => (v ?? '').isEmpty ? t.passwordRequired : null,
                  onFieldSubmitted: (_) => _submit(),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(onPressed: () => context.push('/forgot'), child: Text(t.forgotPassword)),
        ),
        const SizedBox(height: 8),
        FilledButton(
          onPressed: _busy ? null : _submit,
          child: _busy ? const SizedBox.square(dimension: 22, child: CircularProgressIndicator(strokeWidth: 2)) : Text(t.login),
        ),
        const SizedBox(height: 12),
        OutlinedButton(onPressed: () => context.push('/register'), child: Text(t.createAccount)),
        const SizedBox(height: 24),
        TextButton.icon(
          onPressed: () => context.go('/server'),
          icon: const Icon(Icons.dns_outlined, size: 18),
          label: Text(t.serverLabel(server.replaceFirst(RegExp('^https?://'), ''))),
        ),
      ],
    );
  }
}

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _password.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    for (final c in [_name, _email, _password, _confirm]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _busy = true);
    final t = context.t;
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(sessionProvider).register(_name.text, _email.text, _password.text);
      messenger.showSnackBar(SnackBar(content: Text(t.verificationSent)));
    } catch (e) {
      if (mounted) showError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return FormPage(
      appBar: AppBar(title: Text(t.createAccount)),
      children: [
        Form(
          key: _form,
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _name,
                  textCapitalization: TextCapitalization.words,
                  autofillHints: const [AutofillHints.givenName],
                  decoration: InputDecoration(labelText: t.displayName, helperText: t.displayNameHelp, prefixIcon: const Icon(Icons.person_outline)),
                  validator: (v) => (v ?? '').trim().isEmpty ? t.nameRequired : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  decoration: InputDecoration(labelText: t.email, prefixIcon: const Icon(Icons.mail_outline)),
                  validator: (v) => _emailPattern.hasMatch(v?.trim() ?? '') ? null : t.emailInvalid,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _password,
                  obscureText: true,
                  autofillHints: const [AutofillHints.newPassword],
                  decoration: InputDecoration(labelText: t.password, prefixIcon: const Icon(Icons.lock_outline)),
                  validator: (v) => isValidPassword(v ?? '') ? null : t.errorPasswordRules,
                ),
                const SizedBox(height: 8),
                PasswordChecklist(password: _password.text),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _confirm,
                  obscureText: true,
                  decoration: InputDecoration(labelText: t.passwordConfirm, prefixIcon: const Icon(Icons.lock_outline)),
                  validator: (v) => v == _password.text ? null : t.passwordMismatch,
                  onFieldSubmitted: (_) => _submit(),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: _busy ? null : _submit,
          child: _busy ? const SizedBox.square(dimension: 22, child: CircularProgressIndicator(strokeWidth: 2)) : Text(t.createAccount),
        ),
      ],
    );
  }
}

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _email = TextEditingController();
  bool _busy = false;
  bool _sent = false;

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_emailPattern.hasMatch(_email.text.trim())) return;
    setState(() => _busy = true);
    try {
      await ref.read(sessionProvider).requestPasswordReset(_email.text);
      if (mounted) setState(() => _sent = true);
    } catch (e) {
      if (mounted) showError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return FormPage(
      appBar: AppBar(title: Text(t.forgotPassword)),
      children: [
        Text(_sent ? t.resetSent : t.resetExplain),
        const SizedBox(height: 16),
        if (!_sent) ...[
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(labelText: t.email, prefixIcon: const Icon(Icons.mail_outline)),
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 20),
          FilledButton(onPressed: _busy ? null : _submit, child: Text(t.sendResetLink)),
        ] else
          FilledButton(onPressed: () => context.pop(), child: Text(t.backToLogin)),
      ],
    );
  }
}
