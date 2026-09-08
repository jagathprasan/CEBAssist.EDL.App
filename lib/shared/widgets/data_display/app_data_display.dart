import 'package:flutter/material.dart';

import '../../../app/theme/app_breakpoints.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../cards/app_cards.dart';
import '../feedback/app_feedback.dart';
import '../forms/app_form_fields.dart';
import '../navigation/app_navigation.dart';

class AppPaginationControls extends StatelessWidget {
  const AppPaginationControls({
    super.key,
    required this.page,
    required this.totalPages,
    required this.onPageChanged,
  });

  final int page;
  final int totalPages;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          tooltip: 'Previous page',
          onPressed: page <= 1 ? null : () => onPageChanged(page - 1),
          icon: const Icon(Icons.chevron_left),
        ),
        Text('$page / $totalPages', style: context.textTheme.labelLarge),
        IconButton(
          tooltip: 'Next page',
          onPressed: page >= totalPages ? null : () => onPageChanged(page + 1),
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}

class AppPaginatedList<T> extends StatelessWidget {
  const AppPaginatedList({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.page,
    required this.totalPages,
    required this.onPageChanged,
    this.emptyTitle = 'No results',
    this.emptyMessage = 'Try adjusting your filters.',
    this.onRefresh,
  });

  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final int page;
  final int totalPages;
  final ValueChanged<int> onPageChanged;
  final String emptyTitle;
  final String emptyMessage;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    final list = items.isEmpty
        ? AppEmptyStateView(title: emptyTitle, message: emptyMessage)
        : ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) =>
                itemBuilder(context, items[index], index),
          );

    final body = Column(
      children: [
        Expanded(child: list),
        if (items.isNotEmpty)
          AppPaginationControls(
            page: page,
            totalPages: totalPages,
            onPageChanged: onPageChanged,
          ),
      ],
    );

    if (onRefresh == null) return body;
    return RefreshIndicator(onRefresh: onRefresh!, child: body);
  }
}

class AppSearchableList<T> extends StatelessWidget {
  const AppSearchableList({
    super.key,
    required this.controller,
    required this.onQueryChanged,
    required this.items,
    required this.itemBuilder,
    this.hint = 'Search',
  });

  final TextEditingController controller;
  final ValueChanged<String> onQueryChanged;
  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppSearchField(
          controller: controller,
          onChanged: onQueryChanged,
          hint: hint,
        ),
        const SizedBox(height: AppSpacing.sm),
        Expanded(
          child: items.isEmpty
              ? const AppEmptyStateView(
                  title: 'No matches',
                  message: 'Nothing matched your search.',
                )
              : ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) =>
                      itemBuilder(context, items[index], index),
                ),
        ),
      ],
    );
  }
}

class AppExpandableListItem extends StatelessWidget {
  const AppExpandableListItem({
    super.key,
    required this.title,
    required this.children,
    this.subtitle,
    this.initiallyExpanded = false,
  });

  final String title;
  final String? subtitle;
  final List<Widget> children;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(title),
      subtitle: subtitle == null ? null : Text(subtitle!),
      initiallyExpanded: initiallyExpanded,
      childrenPadding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        0,
        AppSpacing.md,
        AppSpacing.md,
      ),
      children: children,
    );
  }
}

class AppDataColumn {
  const AppDataColumn({
    required this.keyName,
    required this.label,
    this.numeric = false,
  });

  final String keyName;
  final String label;
  final bool numeric;
}

/// Adapts to cards on compact widths; table on larger screens.
class AppAdaptiveDataTable extends StatelessWidget {
  const AppAdaptiveDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.onRowTap,
  });

  final List<AppDataColumn> columns;
  final List<Map<String, String>> rows;
  final ValueChanged<Map<String, String>>? onRowTap;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (AppBreakpoints.isCompact(width)) {
      return Column(
        children: [
          for (final row in rows) ...[
            AppMobileDataCard(
              title: row[columns.first.keyName] ?? '',
              entries: {
                for (final col in columns.skip(1))
                  col.label: row[col.keyName] ?? '',
              },
              onTap: onRowTap == null ? null : () => onRowTap!(row),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ],
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          for (final col in columns)
            DataColumn(label: Text(col.label), numeric: col.numeric),
        ],
        rows: [
          for (final row in rows)
            DataRow(
              onSelectChanged: onRowTap == null ? null : (_) => onRowTap!(row),
              cells: [
                for (final col in columns)
                  DataCell(Text(row[col.keyName] ?? '')),
              ],
            ),
        ],
      ),
    );
  }
}

class AppMobileDataCard extends StatelessWidget {
  const AppMobileDataCard({
    super.key,
    required this.title,
    required this.entries,
    this.onTap,
    this.trailing,
  });

  final String title;
  final Map<String, String> entries;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              ?trailing,
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          for (final entry in entries.entries)
            AppKeyValueRow(label: entry.key, value: entry.value, dense: true),
        ],
      ),
    );
  }
}

class AppTimelineItem {
  const AppTimelineItem({
    required this.title,
    required this.timeLabel,
    this.subtitle,
    this.icon,
  });

  final String title;
  final String timeLabel;
  final String? subtitle;
  final IconData? icon;
}

class AppTimeline extends StatelessWidget {
  const AppTimeline({super.key, required this.items});

  final List<AppTimelineItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < items.length; i++)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 28,
                  child: Column(
                    children: [
                      Icon(
                        items[i].icon ?? Icons.circle,
                        size: 12,
                        color: context.colors.primary,
                      ),
                      if (i < items.length - 1)
                        Expanded(
                          child: Container(
                            width: 2,
                            color: context.colors.outlineVariant,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          items[i].title,
                          style: context.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          items[i].timeLabel,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.colors.onSurfaceVariant,
                          ),
                        ),
                        if (items[i].subtitle != null) Text(items[i].subtitle!),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class AppActivityLogItem extends StatelessWidget {
  const AppActivityLogItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.timeLabel,
    this.icon = Icons.history,
  });

  final String title;
  final String subtitle;
  final String timeLabel;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return AppListTile(
      leading: CircleAvatar(
        backgroundColor: context.colors.primaryContainer,
        child: Icon(icon, size: 18, color: context.colors.onPrimaryContainer),
      ),
      title: title,
      subtitle: '$subtitle · $timeLabel',
    );
  }
}

class AppNotificationItem extends StatelessWidget {
  const AppNotificationItem({
    super.key,
    required this.title,
    required this.body,
    required this.timeLabel,
    this.unread = false,
    this.onTap,
  });

  final String title;
  final String body;
  final String timeLabel;
  final bool unread;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      elevated: unread,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: unread ? FontWeight.w800 : FontWeight.w600,
                  ),
                ),
              ),
              Text(
                timeLabel,
                style: context.textTheme.labelSmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(body, style: context.textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class AppUserItem extends StatelessWidget {
  const AppUserItem({
    super.key,
    required this.name,
    this.role,
    this.imageUrl,
    this.onTap,
  });

  final String name;
  final String? role;
  final String? imageUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppListTile(
      onTap: onTap,
      leading: AppAvatar(imageUrl: imageUrl, initials: name.initials),
      title: name,
      subtitle: role,
      trailing: const Icon(Icons.chevron_right),
    );
  }
}

class AppAttachmentItem extends StatelessWidget {
  const AppAttachmentItem({
    super.key,
    required this.fileName,
    this.sizeLabel,
    this.onTap,
    this.onRemove,
  });

  final String fileName;
  final String? sizeLabel;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return AppListTile(
      onTap: onTap,
      leading: const Icon(Icons.insert_drive_file_outlined),
      title: fileName,
      subtitle: sizeLabel,
      trailing: onRemove == null
          ? null
          : IconButton(
              tooltip: 'Remove',
              onPressed: onRemove,
              icon: const Icon(Icons.close),
            ),
    );
  }
}

class AppKeyValueDetails extends StatelessWidget {
  const AppKeyValueDetails({super.key, required this.entries});

  final Map<String, String> entries;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          for (final e in entries.entries)
            AppKeyValueRow(label: e.key, value: e.value),
        ],
      ),
    );
  }
}

Future<void> showAppSortFilterSheet({
  required BuildContext context,
  required List<String> sortOptions,
  required String selectedSort,
  required ValueChanged<String> onSortChanged,
  required List<String> filterOptions,
  required String selectedFilter,
  required ValueChanged<String> onFilterChanged,
}) {
  return showAppBottomSheet<void>(
    context: context,
    title: 'Sort & filter',
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Sort by', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          children: [
            for (final option in sortOptions)
              ChoiceChip(
                label: Text(option),
                selected: option == selectedSort,
                onSelected: (_) {
                  onSortChanged(option);
                  Navigator.of(context).pop();
                },
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Text('Filter', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          children: [
            for (final option in filterOptions)
              FilterChip(
                label: Text(option),
                selected: option == selectedFilter,
                onSelected: (_) {
                  onFilterChanged(option);
                  Navigator.of(context).pop();
                },
              ),
          ],
        ),
      ],
    ),
  );
}
