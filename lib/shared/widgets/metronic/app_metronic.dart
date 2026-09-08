import 'package:flutter/material.dart';

import '../../../app/theme/app_durations.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_confirmation_dialog.dart';
import '../../../core/widgets/app_status_chip.dart';
import '../cards/app_cards.dart';
import '../navigation/app_navigation.dart';

export '../data_display/app_calendar.dart';

enum AppAlertVariant { info, success, warning, error, primary }

/// Metronic-style alert / banner.
class AppAlert extends StatelessWidget {
  const AppAlert({
    super.key,
    required this.title,
    this.message,
    this.variant = AppAlertVariant.info,
    this.onClose,
    this.action,
  });

  final String title;
  final String? message;
  final AppAlertVariant variant;
  final VoidCallback? onClose;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final (color, icon) = switch (variant) {
      AppAlertVariant.success => (
        context.semantic.success,
        Icons.check_circle_outline,
      ),
      AppAlertVariant.warning => (
        context.semantic.warning,
        Icons.warning_amber_outlined,
      ),
      AppAlertVariant.error => (context.colors.error, Icons.error_outline),
      AppAlertVariant.primary => (
        context.colors.primary,
        Icons.campaign_outlined,
      ),
      AppAlertVariant.info => (context.semantic.info, Icons.info_outline),
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: color.withValues(alpha: context.isDark ? 0.16 : 0.1),
        borderRadius: AppRadius.borderSm,
        border: Border.all(color: color.withValues(alpha: 0.28)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (message != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    message!,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
                ],
                ?action,
              ],
            ),
          ),
          if (onClose != null)
            IconButton(
              tooltip: 'Dismiss',
              onPressed: onClose,
              icon: const Icon(Icons.close, size: 18),
              visualDensity: VisualDensity.compact,
            ),
        ],
      ),
    );
  }
}

class AppBreadcrumbItem {
  const AppBreadcrumbItem({required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;
}

class AppBreadcrumb extends StatelessWidget {
  const AppBreadcrumb({super.key, required this.items, this.compact = false});

  final List<AppBreadcrumbItem> items;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final style =
        (compact ? context.textTheme.labelSmall : context.textTheme.labelLarge)
            ?.copyWith(height: 1.1);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Icon(
                  Icons.chevron_right,
                  size: compact ? 14 : 16,
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            InkWell(
              onTap: items[i].onTap,
              child: Text(
                items[i].label,
                style: style?.copyWith(
                  fontWeight: i == items.length - 1
                      ? FontWeight.w700
                      : FontWeight.w500,
                  color: i == items.length - 1
                      ? context.colors.onSurface
                      : context.colors.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class AppAccordionSection {
  const AppAccordionSection({
    required this.title,
    required this.body,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final Widget body;
}

class AppAccordion extends StatelessWidget {
  const AppAccordion({super.key, required this.sections});

  final List<AppAccordionSection> sections;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      elevated: false,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (final section in sections)
            ExpansionTile(
              title: Text(section.title),
              subtitle: section.subtitle == null
                  ? null
                  : Text(section.subtitle!),
              childrenPadding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                0,
                AppSpacing.md,
                AppSpacing.md,
              ),
              children: [section.body],
            ),
        ],
      ),
    );
  }
}

class AppStepper extends StatelessWidget {
  const AppStepper({super.key, required this.steps, required this.currentStep});

  final List<String> steps;
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          if (i > 0)
            Expanded(
              child: Container(
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                color: i <= currentStep
                    ? context.colors.primary
                    : context.colors.outlineVariant,
              ),
            ),
          Column(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: i <= currentStep
                    ? context.colors.primary
                    : context.colors.surfaceContainerHigh,
                child: Text(
                  '${i + 1}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: i <= currentStep
                        ? context.colors.onPrimary
                        : context.colors.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(steps[i], style: context.textTheme.labelSmall),
            ],
          ),
        ],
      ],
    );
  }
}

class AppKbd extends StatelessWidget {
  const AppKbd({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHigh,
        borderRadius: AppRadius.borderXs,
        border: Border.all(color: context.colors.outlineVariant),
      ),
      child: Text(
        label,
        style: context.textTheme.labelSmall?.copyWith(
          fontFamily: 'monospace',
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class AppSlider extends StatelessWidget {
  const AppSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 1,
    this.label,
  });

  final double value;
  final ValueChanged<double> onChanged;
  final double min;
  final double max;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) Text(label!, style: context.textTheme.labelLarge),
        Slider(value: value, min: min, max: max, onChanged: onChanged),
      ],
    );
  }
}

class AppToggle extends StatelessWidget {
  const AppToggle({
    super.key,
    required this.selected,
    required this.onChanged,
    required this.label,
    this.icon,
  });

  final bool selected;
  final ValueChanged<bool> onChanged;
  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      selected: selected,
      onSelected: onChanged,
      avatar: icon == null ? null : Icon(icon, size: 16),
      label: Text(label),
    );
  }
}

class AppToggleGroup extends StatelessWidget {
  const AppToggleGroup({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  final List<String> options;
  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.xs,
      children: [
        for (final option in options)
          AppToggle(
            label: option,
            selected: option == selected,
            onChanged: (_) => onChanged(option),
          ),
      ],
    );
  }
}

class AppAvatarGroup extends StatelessWidget {
  const AppAvatarGroup({
    super.key,
    required this.initials,
    this.max = 4,
    this.size = 32,
  });

  final List<String> initials;
  final int max;
  final double size;

  @override
  Widget build(BuildContext context) {
    final shown = initials.take(max).toList();
    final extra = initials.length - shown.length;
    return SizedBox(
      height: size,
      child: Stack(
        children: [
          for (var i = 0; i < shown.length; i++)
            Padding(
              padding: EdgeInsets.only(left: i * (size * 0.7)),
              child: AppAvatar(initials: shown[i], size: size),
            ),
          if (extra > 0)
            Padding(
              padding: EdgeInsets.only(left: shown.length * (size * 0.7)),
              child: CircleAvatar(
                radius: size / 2,
                backgroundColor: context.colors.surfaceContainerHighest,
                child: Text(
                  '+$extra',
                  style: context.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class AppKanbanColumn extends StatelessWidget {
  const AppKanbanColumn({
    super.key,
    required this.title,
    required this.count,
    required this.children,
  });

  final String title;
  final int count;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      elevated: false,
      color: context.colors.surfaceContainerLow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              AppStatusChip(label: '$count', compact: true),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ...children,
        ],
      ),
    );
  }
}

class AppCountingNumber extends StatelessWidget {
  const AppCountingNumber({super.key, required this.value, this.suffix = ''});

  final int value;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value.toDouble()),
      duration: AppDurations.slow,
      builder: (context, animated, _) {
        return Text(
          '${animated.round()}$suffix',
          style: context.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        );
      },
    );
  }
}

class AppCode extends StatelessWidget {
  const AppCode({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHigh,
        borderRadius: AppRadius.borderXs,
      ),
      child: Text(
        text,
        style: context.textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
      ),
    );
  }
}

class AppCarousel extends StatelessWidget {
  const AppCarousel({super.key, required this.children, this.height = 160});

  final List<Widget> children;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: children.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) =>
            SizedBox(width: 280, child: children[index]),
      ),
    );
  }
}

Future<bool> showAppConfirmDelete(
  BuildContext context, {
  String title = 'Delete item',
  String message = 'This action cannot be undone.',
}) {
  return AppConfirmationDialog.show(
    context,
    title: title,
    message: message,
    confirmLabel: 'Delete',
    isDestructive: true,
  );
}

class AppSeparator extends StatelessWidget {
  const AppSeparator({super.key, this.label});

  final String? label;

  @override
  Widget build(BuildContext context) {
    if (label == null) return const AppDivider();
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Text(
            label!,
            style: context.textTheme.labelSmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}

class AppHoverCard extends StatelessWidget {
  const AppHoverCard({super.key, required this.trigger, required this.message});

  final Widget trigger;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      preferBelow: true,
      waitDuration: AppDurations.fast,
      child: trigger,
    );
  }
}

class AppAspectRatioBox extends StatelessWidget {
  const AppAspectRatioBox({
    super.key,
    required this.child,
    this.ratio = 16 / 9,
  });

  final Widget child;
  final double ratio;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(aspectRatio: ratio, child: child);
  }
}

class AppTreeNode {
  const AppTreeNode({required this.label, this.children = const []});

  final String label;
  final List<AppTreeNode> children;
}

class AppTree extends StatelessWidget {
  const AppTree({super.key, required this.nodes});

  final List<AppTreeNode> nodes;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [for (final node in nodes) _node(context, node, 0)],
    );
  }

  Widget _node(BuildContext context, AppTreeNode node, int depth) {
    if (node.children.isEmpty) {
      return ListTile(
        dense: true,
        contentPadding: EdgeInsets.only(left: AppSpacing.md * depth),
        leading: const Icon(Icons.insert_drive_file_outlined, size: 18),
        title: Text(node.label),
      );
    }
    return ExpansionTile(
      tilePadding: EdgeInsets.only(left: AppSpacing.md * depth),
      leading: const Icon(Icons.folder_outlined, size: 18),
      title: Text(node.label),
      children: [
        for (final child in node.children) _node(context, child, depth + 1),
      ],
    );
  }
}

class AppCommandSheet {
  AppCommandSheet._();

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required List<String> options,
    required T Function(String option) onSelected,
  }) {
    return showAppBottomSheet<T>(
      context: context,
      title: title,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final option in options)
            ListTile(
              title: Text(option),
              onTap: () => Navigator.of(context).pop(onSelected(option)),
            ),
        ],
      ),
    );
  }
}
