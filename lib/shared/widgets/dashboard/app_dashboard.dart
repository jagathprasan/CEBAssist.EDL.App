import 'package:flutter/material.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_loading_skeleton.dart';
import '../cards/app_cards.dart';

class AppKpiCard extends StatelessWidget {
  const AppKpiCard({
    super.key,
    required this.label,
    required this.value,
    this.deltaLabel,
    this.icon,
    this.iconColor,
    this.trendColor,
    this.onTap,
  });

  final String label;
  final String value;
  final String? deltaLabel;
  final IconData? icon;
  final Color? iconColor;
  final Color? trendColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppStatCard(
      label: label,
      value: value,
      trendLabel: deltaLabel,
      icon: icon,
      iconColor: iconColor,
      trendColor: trendColor,
      onTap: onTap,
    );
  }
}

class AppMetricCard extends StatelessWidget {
  const AppMetricCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.caption,
  });

  final String label;
  final String value;
  final IconData icon;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: context.colors.primaryContainer,
            child: Icon(icon, color: context.colors.onPrimaryContainer),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: context.textTheme.labelLarge?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
                Text(
                  value,
                  style: context.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (caption != null)
                  Text(caption!, style: context.textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AppQuickAction {
  const AppQuickAction({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
}

class AppQuickActionGrid extends StatelessWidget {
  const AppQuickActionGrid({
    super.key,
    required this.actions,
    this.crossAxisCount = 2,
  });

  final List<AppQuickAction> actions;
  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: actions.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: AppSpacing.sm,
        crossAxisSpacing: AppSpacing.sm,
        childAspectRatio: 1.55,
      ),
      itemBuilder: (context, index) {
        final action = actions[index];
        return AppCard(
          onTap: action.onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(action.icon, color: context.colors.primary),
              const SizedBox(height: AppSpacing.xs),
              Text(
                action.label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class AppRecentActivityList extends StatelessWidget {
  const AppRecentActivityList({super.key, required this.items, this.onViewAll});

  final List<Widget> items;
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          AppSectionHeader(
            title: 'Recent activity',
            action: onViewAll == null
                ? null
                : TextButton(
                    onPressed: onViewAll,
                    child: const Text('View all'),
                  ),
          ),
          ...items,
        ],
      ),
    );
  }
}

class AppNotificationSummary extends StatelessWidget {
  const AppNotificationSummary({
    super.key,
    required this.unreadCount,
    required this.preview,
    this.onOpen,
  });

  final int unreadCount;
  final String preview;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    return AppSummaryCard(
      title: '$unreadCount unread notifications',
      subtitle: preview,
      onTap: onOpen,
      trailing: const Icon(Icons.notifications_outlined),
    );
  }
}

class AppProgressSummary extends StatelessWidget {
  const AppProgressSummary({
    super.key,
    required this.title,
    required this.progress,
    this.caption,
  });

  final String title;
  final double progress;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppProgressBar(value: progress, label: caption),
        ],
      ),
    );
  }
}

class AppStatusSlice {
  const AppStatusSlice({required this.label, required this.count, this.color});

  final String label;
  final int count;
  final Color? color;
}

class AppStatusDistribution extends StatelessWidget {
  const AppStatusDistribution({super.key, required this.slices});

  final List<AppStatusSlice> slices;

  @override
  Widget build(BuildContext context) {
    final total = slices.fold<int>(0, (sum, s) => sum + s.count);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Status distribution',
            style: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          for (final slice in slices) ...[
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: slice.color ?? context.colors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(child: Text(slice.label)),
                Text(
                  '${slice.count}',
                  style: context.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxs),
            AppProgressBar(
              value: total == 0 ? 0 : slice.count / total,
              color: slice.color,
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}

/// Host for injecting a chart widget without owning chart logic.
class AppChartContainer extends StatelessWidget {
  const AppChartContainer({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.height = 200,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSectionHeader(title: title, subtitle: subtitle),
          SizedBox(height: height, child: child),
        ],
      ),
    );
  }
}

class AppDashboardSection extends StatelessWidget {
  const AppDashboardSection({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.action,
  });

  final String title;
  final String? subtitle;
  final Widget child;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppSectionHeader(title: title, subtitle: subtitle, action: action),
          child,
        ],
      ),
    );
  }
}

class AppDashboardSkeletonLoader extends StatelessWidget {
  const AppDashboardSkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) => const AppDashboardSkeleton();
}
