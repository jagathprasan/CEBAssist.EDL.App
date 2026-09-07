import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/extensions/date_extensions.dart';
import '../../../../core/widgets/app_activity_tile.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading_skeleton.dart';
import '../../../../core/widgets/app_quick_action_tile.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../../../core/widgets/app_summary_card.dart';
import '../../../../shared/providers/user_provider.dart';
import '../domain/dashboard_models.dart';
import 'providers/dashboard_provider.dart';
import 'widgets/collection_progress_card.dart';
import 'widgets/energy_overview_chart.dart';
import 'widgets/outage_status_card.dart';
import 'widgets/project_monitoring_section.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(dashboardProvider);
    return dashboard.when(
      loading: () => const AppDashboardSkeleton(),
      error: (error, _) => AppErrorState(
        message: 'The operational overview could not be loaded.',
        onRetry: () => ref.invalidate(dashboardProvider),
      ),
      data: (data) => _DashboardBody(data: data),
    );
  }
}

class _DashboardBody extends ConsumerWidget {
  const _DashboardBody({required this.data});

  final DashboardSnapshot data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final now = DateTime.now();

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(dashboardProvider),
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.xl,
            ),
            sliver: SliverList.list(
              children: [
                Text(
                  '${now.greeting}, ${user.firstName}',
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  now.longDate,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  "Here is today’s operational overview.",
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                _SummaryGrid(items: data.summaries),
                const SizedBox(height: AppSpacing.lg),
                ProjectMonitoringSection(
                  portfolio: data.projectPortfolio,
                  onRefresh: () => ref.invalidate(dashboardProvider),
                ),
                const SizedBox(height: AppSpacing.lg),
                EnergyOverviewChart(points: data.energy),
                const SizedBox(height: AppSpacing.lg),
                CollectionProgressCard(progress: data.collection),
                const SizedBox(height: AppSpacing.lg),
                OutageStatusCard(outages: data.outages),
                const SizedBox(height: AppSpacing.lg),
                const AppSectionHeader(title: 'Quick Actions'),
                _QuickActionGrid(actions: data.quickActions),
                const SizedBox(height: AppSpacing.lg),
                const AppSectionHeader(title: 'Recent Activities'),
                ...data.activities.map(
                  (item) => AppActivityTile(
                    icon: _activityIcon(item.type),
                    title: item.title,
                    timestamp: item.timestamp.relativeLabel,
                    statusLabel: _statusLabel(item.status),
                    tone: _statusTone(item.status),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                const AppSectionHeader(title: 'Attention Required'),
                ...data.attentionItems.map(
                  (item) => _AttentionTile(item: item),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _activityIcon(ActivityType type) {
    return switch (type) {
      ActivityType.meter => Icons.speed_outlined,
      ActivityType.outage => Icons.power_off_outlined,
      ActivityType.billing => Icons.receipt_long_outlined,
      ActivityType.inventory => Icons.inventory_2_outlined,
    };
  }

  String _statusLabel(ActivityStatus status) {
    return switch (status) {
      ActivityStatus.completed => 'Completed',
      ActivityStatus.assigned => 'Assigned',
      ActivityStatus.generated => 'Generated',
      ActivityStatus.approved => 'Approved',
    };
  }

  AppStatusTone _statusTone(ActivityStatus status) {
    return switch (status) {
      ActivityStatus.completed ||
      ActivityStatus.approved => AppStatusTone.success,
      ActivityStatus.assigned => AppStatusTone.warning,
      ActivityStatus.generated => AppStatusTone.info,
    };
  }
}

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({required this.items});

  final List<DashboardSummaryItem> items;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final gap = AppSpacing.sm;
        final width = (constraints.maxWidth - gap) / 2;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final item in items)
              SizedBox(
                width: width,
                child: AppSummaryCard(
                  icon: _icon(item.type),
                  value: item.value,
                  label: item.label,
                  trendLabel: item.trendLabel,
                  trendUp: item.isPositive,
                  color: _color(context, item.type),
                ),
              ),
          ],
        );
      },
    );
  }

  IconData _icon(SummaryMetricType type) {
    return switch (type) {
      SummaryMetricType.consumers => Icons.groups_outlined,
      SummaryMetricType.meters => Icons.sensors_outlined,
      SummaryMetricType.complaints => Icons.support_agent_outlined,
      SummaryMetricType.outages => Icons.offline_bolt_outlined,
    };
  }

  Color _color(BuildContext context, SummaryMetricType type) {
    return switch (type) {
      SummaryMetricType.consumers => context.colors.primary,
      SummaryMetricType.meters => context.colors.secondary,
      SummaryMetricType.complaints => context.semantic.warning,
      SummaryMetricType.outages => context.colors.error,
    };
  }
}

class _QuickActionGrid extends StatelessWidget {
  const _QuickActionGrid({required this.actions});

  final List<QuickActionItem> actions;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 520 ? 3 : 2;
        final gap = AppSpacing.sm;
        final width = (constraints.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final action in actions)
              SizedBox(
                width: width,
                height: 112,
                child: AppQuickActionTile(
                  icon: _icon(action.type),
                  label: action.label,
                  onTap: () => _open(context, action.type),
                ),
              ),
          ],
        );
      },
    );
  }

  IconData _icon(QuickActionType type) {
    return switch (type) {
      QuickActionType.searchConsumer => Icons.person_search_outlined,
      QuickActionType.viewMeter => Icons.speed_outlined,
      QuickActionType.reportOutage => Icons.report_gmailerrorred_outlined,
      QuickActionType.checkBill => Icons.receipt_long_outlined,
      QuickActionType.createRequest => Icons.post_add_outlined,
      QuickActionType.viewReports => Icons.bar_chart_outlined,
    };
  }

  void _open(BuildContext context, QuickActionType type) {
    final route = switch (type) {
      QuickActionType.searchConsumer => AppRoutes.consumerServices,
      QuickActionType.viewMeter => AppRoutes.meterManagement,
      QuickActionType.reportOutage => AppRoutes.outageManagement,
      QuickActionType.checkBill => AppRoutes.billing,
      QuickActionType.createRequest => AppRoutes.projects,
      QuickActionType.viewReports => AppRoutes.reports,
    };
    context.go(route);
  }
}

class _AttentionTile extends StatelessWidget {
  const _AttentionTile({required this.item});

  final AttentionItem item;

  @override
  Widget build(BuildContext context) {
    final isWarning = item.severity == AttentionSeverity.warning;
    final color = isWarning ? context.semantic.warning : context.colors.primary;
    final background = isWarning
        ? context.semantic.warningContainer
        : context.semantic.infoContainer;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadius.borderMd,
      ),
      child: Row(
        children: [
          Icon(
            isWarning
                ? Icons.warning_amber_rounded
                : Icons.info_outline_rounded,
            color: color,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              item.message,
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
