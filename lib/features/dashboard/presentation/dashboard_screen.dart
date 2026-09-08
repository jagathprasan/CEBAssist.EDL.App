import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/extensions/date_extensions.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading_skeleton.dart';
import '../../../../core/widgets/app_summary_card.dart';
import '../../../../shared/providers/user_provider.dart';
import '../domain/dashboard_models.dart';
import 'providers/dashboard_provider.dart';

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
                  'Your operational overview will appear here.',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                _SummaryGrid(items: data.summaries),
              ],
            ),
          ),
        ],
      ),
    );
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
