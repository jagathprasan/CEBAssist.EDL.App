import 'package:flutter/material.dart';

import '../../../app/theme/app_shadows.dart';
import '../../../app/theme/app_sizes.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_status_chip.dart';

/// Base elevated surface used by content cards.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.color,
    this.elevated = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      margin: margin,
      padding: padding ?? const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color ?? context.colors.surfaceContainerLowest,
        borderRadius: AppRadius.borderMd,
        border: Border.all(
          color: context.colors.outlineVariant.withValues(alpha: 0.5),
        ),
        boxShadow: elevated ? AppShadows.md(context) : AppShadows.none,
      ),
      child: child,
    );

    if (onTap == null) return content;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.borderMd,
        child: content,
      ),
    );
  }
}

class AppInfoCard extends StatelessWidget {
  const AppInfoCard({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.info_outline,
    this.onAction,
    this.actionLabel,
  });

  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? onAction;
  final String? actionLabel;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: context.semantic.infoContainer.withValues(alpha: 0.55),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: context.semantic.info),
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
                const SizedBox(height: AppSpacing.xxs),
                Text(message, style: context.textTheme.bodyMedium),
                if (onAction != null && actionLabel != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  TextButton(onPressed: onAction, child: Text(actionLabel!)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AppStatCard extends StatelessWidget {
  const AppStatCard({
    super.key,
    required this.label,
    required this.value,
    this.trendLabel,
    this.icon,
    this.iconColor,
    this.trendColor,
    this.onTap,
  });

  final String label;
  final String value;
  final String? trendLabel;
  final IconData? icon;
  final Color? iconColor;
  final Color? trendColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final accent = iconColor ?? context.colors.primary;
    return AppCard(
      onTap: onTap,
      elevated: false,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: context.textTheme.labelLarge?.copyWith(
                    color: context.colors.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  value,
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (trendLabel != null) ...[
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    trendLabel!,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: trendColor ?? context.semantic.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (icon != null) AppIconBox(icon: icon!, color: accent),
        ],
      ),
    );
  }
}

/// Metronic-style tinted square icon used on KPI cards.
class AppIconBox extends StatelessWidget {
  const AppIconBox({
    super.key,
    required this.icon,
    required this.color,
    this.size = 44,
  });

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: context.isDark ? 0.22 : 0.12),
        borderRadius: AppRadius.borderXs,
      ),
      child: Icon(icon, color: color, size: size * 0.48),
    );
  }
}

class AppSummaryCard extends StatelessWidget {
  const AppSummaryCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  subtitle,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

class AppActionCard extends StatelessWidget {
  const AppActionCard({
    super.key,
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.onAction,
    this.icon,
  });

  final String title;
  final String description;
  final String actionLabel;
  final VoidCallback onAction;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: context.colors.primary),
                const SizedBox(width: AppSpacing.sm),
              ],
              Expanded(
                child: Text(
                  title,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(description, style: context.textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton(onPressed: onAction, child: Text(actionLabel)),
          ),
        ],
      ),
    );
  }
}

class AppListTile extends StatelessWidget {
  const AppListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: leading,
      title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: subtitle == null
          ? null
          : Text(subtitle!, maxLines: 2, overflow: TextOverflow.ellipsis),
      trailing: trailing,
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.borderSm),
    );
  }
}

class AppSectionHeader extends StatelessWidget {
  const AppSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
  });

  final String title;
  final String? subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          ?action,
        ],
      ),
    );
  }
}

class AppDivider extends StatelessWidget {
  const AppDivider({super.key, this.height = AppSpacing.lg, this.indent});

  final double height;
  final double? indent;

  @override
  Widget build(BuildContext context) {
    return Divider(height: height, indent: indent, endIndent: indent);
  }
}

class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.child,
    required this.count,
    this.max = 99,
  });

  final Widget child;
  final int count;
  final int max;

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return child;
    final label = count > max ? '$max+' : '$count';
    return Badge(label: Text(label), child: child);
  }
}

class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onSelected,
    this.avatar,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool>? onSelected;
  final Widget? avatar;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      avatar: avatar,
    );
  }
}

class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    this.imageUrl,
    this.initials,
    this.size = AppSizes.avatarMd,
    this.onTap,
  });

  final String? imageUrl;
  final String? initials;
  final double size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final fallback = CircleAvatar(
      radius: size / 2,
      backgroundColor: context.colors.primaryContainer,
      child: Text(
        _initialsText(initials),
        style: context.textTheme.labelLarge?.copyWith(
          color: context.colors.onPrimaryContainer,
          fontWeight: FontWeight.w700,
        ),
      ),
    );

    Widget avatar = fallback;
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      avatar = CircleAvatar(
        radius: size / 2,
        backgroundColor: context.colors.surfaceContainerHighest,
        backgroundImage: NetworkImage(imageUrl!),
        onBackgroundImageError: (_, _) {},
        child: null,
      );
    }

    if (onTap == null) return avatar;
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: avatar,
    );
  }

  static String _initialsText(String? initials) {
    final raw = (initials ?? '?').trim();
    if (raw.isEmpty) return '?';
    return raw.length <= 2
        ? raw.toUpperCase()
        : raw.substring(0, 2).toUpperCase();
  }
}

/// Domain status badge mapped to semantic tones.
enum AppEntityStatus {
  active,
  inactive,
  pending,
  approved,
  rejected,
  completed,
  delayed,
  cancelled,
  draft,
  inProgress,
  synced,
  notSynced,
  offline,
}

class AppStatusBadge extends StatelessWidget {
  const AppStatusBadge({super.key, required this.status, this.compact = false});

  final AppEntityStatus status;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final (label, tone) = switch (status) {
      AppEntityStatus.active => ('Active', AppStatusTone.success),
      AppEntityStatus.inactive => ('Inactive', AppStatusTone.neutral),
      AppEntityStatus.pending => ('Pending', AppStatusTone.warning),
      AppEntityStatus.approved => ('Approved', AppStatusTone.success),
      AppEntityStatus.rejected => ('Rejected', AppStatusTone.error),
      AppEntityStatus.completed => ('Completed', AppStatusTone.success),
      AppEntityStatus.delayed => ('Delayed', AppStatusTone.warning),
      AppEntityStatus.cancelled => ('Cancelled', AppStatusTone.error),
      AppEntityStatus.draft => ('Draft', AppStatusTone.neutral),
      AppEntityStatus.inProgress => ('In Progress', AppStatusTone.info),
      AppEntityStatus.synced => ('Synced', AppStatusTone.success),
      AppEntityStatus.notSynced => ('Not Synced', AppStatusTone.warning),
      AppEntityStatus.offline => ('Offline', AppStatusTone.neutral),
    };
    return AppStatusChip(label: label, tone: tone, compact: compact);
  }
}

class AppProgressBar extends StatelessWidget {
  const AppProgressBar({
    super.key,
    required this.value,
    this.label,
    this.height = AppSizes.progressMd,
    this.color,
    this.trackColor,
  });

  final double value;
  final String? label;
  final double height;
  final Color? color;
  final Color? trackColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: context.textTheme.labelMedium),
          const SizedBox(height: AppSpacing.xxs),
        ],
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: value.clamp(0, 1),
            minHeight: height,
            color: color,
            backgroundColor: trackColor ?? context.colors.surfaceContainerHigh,
          ),
        ),
      ],
    );
  }
}

class AppCircularProgress extends StatelessWidget {
  const AppCircularProgress({
    super.key,
    this.value,
    this.size = 36,
    this.strokeWidth = 3,
  });

  final double? value;
  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(value: value, strokeWidth: strokeWidth),
    );
  }
}

class AppKeyValueRow extends StatelessWidget {
  const AppKeyValueRow({
    super.key,
    required this.label,
    required this.value,
    this.dense = false,
  });

  final String label;
  final String value;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: dense ? AppSpacing.xxs : AppSpacing.xs,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Priority chip with consistent semantic colours in both UI modes.
class AppPriorityBadge extends StatelessWidget {
  const AppPriorityBadge({super.key, required this.priority});

  final String priority;

  @override
  Widget build(BuildContext context) {
    final tone = switch (priority.toLowerCase()) {
      'critical' => AppStatusTone.error,
      'high' => AppStatusTone.warning,
      'low' => AppStatusTone.neutral,
      _ => AppStatusTone.info,
    };
    return AppStatusChip(label: priority, tone: tone);
  }
}
