import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/constants.dart';
import '../providers.dart';
import 'widgets.dart';

/// First start and settings: which ShopBandit server to use.
class ServerScreen extends ConsumerStatefulWidget {
  const ServerScreen({super.key});

  @override
  ConsumerState<ServerScreen> createState() => _ServerScreenState();
}

class _ServerScreenState extends ConsumerState<ServerScreen> {
  late final _url = TextEditingController(text: ref.read(sessionProvider).serverUrl ?? AppInfo.defaultServer);
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _url.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    final ok = await ref.read(sessionProvider).setServer(_url.text);
    if (!mounted) return;
    setState(() {
      _busy = false;
      _error = ok ? null : context.t.serverUnreachable;
    });
    if (ok) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return FormPage(
      children: [
        LogoHeader(subtitle: t.serverSubtitle),
        Text(t.serverExplain, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 16),
        TextField(
          controller: _url,
          keyboardType: TextInputType.url,
          autocorrect: false,
          decoration: InputDecoration(labelText: t.serverUrl, errorText: _error, prefixIcon: const Icon(Icons.dns_outlined)),
          onSubmitted: (_) => _save(),
        ),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: _busy ? null : _save,
          child: _busy ? const SizedBox.square(dimension: 22, child: CircularProgressIndicator(strokeWidth: 2)) : Text(t.next),
        ),
      ],
    );
  }
}
