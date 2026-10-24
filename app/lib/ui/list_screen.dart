import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/items.dart';
import '../data/db.dart';
import '../data/repository.dart';
import '../providers.dart';
import 'theme.dart';
import 'widgets.dart';

class ListScreen extends ConsumerWidget {
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final session = ref.watch(sessionProvider);
    final rows = ref.watch(listProvider).value ?? const <ListRow>[];
    final catalog = ref.watch(catalogProvider).value ?? const <CatalogItem>[];
    final onList = rows.map((r) => r.item.id).toSet();
    final frequent = ShopRepository.frequent(catalog, onList, DateTime.now());

    return Scaffold(
      appBar: GradientAppBar(
        title: Text(session.householdName.isEmpty ? t.appTitle : session.householdName),
        actions: [
          const SyncIndicator(),
          IconButton(
            tooltip: t.household,
            icon: const Icon(Icons.group_outlined),
            onPressed: () => context.push('/household'),
          ),
          IconButton(
            tooltip: t.settings,
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => session.refresh(),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _AddBar(catalog: catalog)),
            if (frequent.isNotEmpty) SliverToBoxAdapter(child: _FrequentSection(items: frequent)),
            if (rows.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: EmptyState(title: t.emptyListTitle, message: t.emptyListMessage),
              )
            else ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
                  child: Text(t.listCount(rows.length), style: Theme.of(context).textTheme.titleSmall),
                ),
              ),
              SliverList.builder(
                itemCount: rows.length,
                itemBuilder: (context, i) => _EntryTile(key: ValueKey(rows[i].entry.id), row: rows[i]),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ],
        ),
      ),
    );
  }
}

/// Item input with autocomplete from the catalog + optional quantity.
class _AddBar extends ConsumerStatefulWidget {
  const _AddBar({required this.catalog});

  final List<CatalogItem> catalog;

  @override
  ConsumerState<_AddBar> createState() => _AddBarState();
}

class _AddBarState extends ConsumerState<_AddBar> {
  final _name = TextEditingController();
  final _qty = TextEditingController();
  final _nameFocus = FocusNode();

  @override
  void dispose() {
    _name.dispose();
    _qty.dispose();
    _nameFocus.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final name = _name.text;
    if (cleanItemName(name).isEmpty) return;
    unawaited(HapticFeedback.selectionClick());
    await ref.read(sessionProvider).repo?.addItem(name, quantity: _qty.text);
    _name.clear();
    _qty.clear();
    _nameFocus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: RawAutocomplete<CatalogItem>(
              textEditingController: _name,
              focusNode: _nameFocus,
              displayStringForOption: (c) => c.name,
              optionsBuilder: (value) {
                final q = normalizeItemName(value.text);
                if (q.isEmpty) return const [];
                return widget.catalog.where((c) => c.nameNormalized.contains(q)).take(6);
              },
              onSelected: (_) {},
              fieldViewBuilder: (context, controller, focus, onSubmit) => TextField(
                controller: controller,
                focusNode: focus,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(hintText: t.addItemHint, prefixIcon: const Icon(Icons.add_shopping_cart)),
                onSubmitted: (_) => _add(),
              ),
              optionsViewBuilder: (context, onSelected, options) => Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(16),
                  color: scheme.surfaceContainerHigh,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 260, maxWidth: 320),
                    child: ListView(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      shrinkWrap: true,
                      children: [
                        for (final o in options)
                          ListTile(dense: true, title: Text(o.name), onTap: () => onSelected(o)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 84,
            child: TextField(
              controller: _qty,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(hintText: t.quantityHint),
              onSubmitted: (_) => _add(),
            ),
          ),
          const SizedBox(width: 8),
          DecoratedBox(
            decoration: BoxDecoration(gradient: Brand.headerGradient, borderRadius: BorderRadius.circular(16)),
            child: IconButton(
              tooltip: t.add,
              iconSize: 28,
              color: Colors.white,
              padding: const EdgeInsets.all(12),
              icon: const Icon(Icons.add),
              onPressed: _add,
            ),
          ),
        ],
      ),
    );
  }
}

class _FrequentSection extends ConsumerWidget {
  const _FrequentSection({required this.items});

  final List<CatalogItem> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final shop = context.shopColors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_fire_department_outlined, size: 18, color: shop.accent),
              const SizedBox(width: 6),
              Text(t.frequentlyBought, style: Theme.of(context).textTheme.titleSmall),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final c in items)
                ActionChip(
                  avatar: Icon(Icons.add, size: 18, color: shop.onAccent),
                  label: Text(c.name),
                  labelStyle: TextStyle(color: shop.onAccent, fontWeight: FontWeight.w600),
                  backgroundColor: shop.accent.withValues(alpha: 0.85),
                  side: BorderSide.none,
                  tooltip: t.addNamed(c.name),
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    ref.read(sessionProvider).repo?.addItem(c.name);
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EntryTile extends ConsumerStatefulWidget {
  const _EntryTile({super.key, required this.row});

  final ListRow row;

  @override
  ConsumerState<_EntryTile> createState() => _EntryTileState();
}

class _EntryTileState extends ConsumerState<_EntryTile> {
  bool _checking = false;

  Future<void> _check() async {
    final repo = ref.read(sessionProvider).repo;
    if (repo == null || _checking) return;
    final t = context.t;
    final messenger = ScaffoldMessenger.of(context);
    final row = widget.row;
    unawaited(HapticFeedback.lightImpact());
    setState(() => _checking = true);
    await Future<void>.delayed(const Duration(milliseconds: 350));
    await repo.check(row);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        // with an action Flutter keeps the snack bar until tapped otherwise
        persist: false,
        content: Text(t.checkedOff(row.item.name)),
        action: SnackBarAction(label: t.undo, onPressed: () => repo.check(row, undo: true)),
      ));
  }

  Future<void> _delete() async {
    final repo = ref.read(sessionProvider).repo;
    if (repo == null) return;
    final t = context.t;
    final messenger = ScaffoldMessenger.of(context);
    final row = widget.row;
    unawaited(HapticFeedback.mediumImpact());
    await repo.deleteEntry(row.entry.id);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        // with an action Flutter keeps the snack bar until tapped otherwise
        persist: false,
        content: Text(t.deleted(row.item.name)),
        action: SnackBarAction(label: t.undo, onPressed: () => repo.deleteEntry(row.entry.id, undo: true)),
      ));
  }

  Future<void> _editQuantity() async {
    final t = context.t;
    final controller = TextEditingController(text: widget.row.entry.quantity);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(widget.row.item.name),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(labelText: t.quantity, hintText: t.quantityExample),
          onSubmitted: (v) => Navigator.pop(context, v),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(t.cancel)),
          FilledButton(onPressed: () => Navigator.pop(context, controller.text), child: Text(t.save)),
        ],
      ),
    );
    controller.dispose();
    if (result != null) await ref.read(sessionProvider).repo?.updateQuantity(widget.row.entry.id, result);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final theme = Theme.of(context);
    final shop = context.shopColors;
    final row = widget.row;
    final me = ref.watch(sessionProvider.select((s) => s.userId));
    final by = row.entry.addedBy == me ? null : row.addedByName;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      builder: (context, v, child) => Opacity(
        opacity: v,
        child: Transform.translate(offset: Offset(0, (1 - v) * 12), child: child),
      ),
      child: AnimatedOpacity(
        opacity: _checking ? 0.4 : 1,
        duration: const Duration(milliseconds: 300),
        child: Dismissible(
          key: ValueKey('dismiss-${row.entry.id}'),
          direction: DismissDirection.endToStart,
          onDismissed: (_) => _delete(),
          background: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(color: theme.colorScheme.errorContainer, borderRadius: BorderRadius.circular(16)),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 24),
            child: Icon(Icons.delete_outline, color: theme.colorScheme.onErrorContainer, semanticLabel: t.delete),
          ),
          child: Card(
            child: ListTile(
              contentPadding: const EdgeInsets.only(left: 4, right: 16),
              leading: IconButton(
                tooltip: t.markBought(row.item.name),
                onPressed: _check,
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (c, a) => ScaleTransition(scale: a, child: c),
                  child: _checking
                      ? Icon(Icons.check_circle, key: const ValueKey('on'), color: shop.success, size: 28)
                      : Icon(Icons.radio_button_unchecked, key: const ValueKey('off'), color: theme.colorScheme.outline, size: 28),
                ),
              ),
              title: Text(row.item.name, style: theme.textTheme.titleMedium),
              subtitle: by == null
                  ? null
                  : Text(t.addedBy(by), style: theme.textTheme.bodySmall?.copyWith(color: shop.subtle)),
              trailing: row.entry.quantity.isEmpty
                  ? null
                  : Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        row.entry.quantity,
                        style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.onSecondaryContainer),
                      ),
                    ),
              onTap: _editQuantity,
            ),
          ),
        ),
      ),
    );
  }
}
