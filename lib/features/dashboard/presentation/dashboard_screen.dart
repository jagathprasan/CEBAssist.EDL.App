import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_breakpoints.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/extensions/date_extensions.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading_skeleton.dart';
import '../../../../shared/data/edl_network_sites.dart';
import '../../../../shared/providers/user_provider.dart';
import '../../../../shared/widgets/widgets.dart';
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

  static const _operations = [
    (
      title: 'Feeder inspection',
      route: 'Unit A → Pole 24',
      status: AppEntityStatus.inProgress,
      eta: 'On schedule',
    ),
    (
      title: 'Outage coordination',
      route: 'Unit B → Feeder 11',
      status: AppEntityStatus.delayed,
      eta: '+45 min',
    ),
    (
      title: 'Meter replacement',
      route: 'Unit C → Consumer service',
      status: AppEntityStatus.pending,
      eta: '15:30',
    ),
  ];

  static const _alerts = [
    (
      title: 'Feeder 11 delayed',
      message: 'Consumer access pending at Unit B.',
      tone: AppAlertVariant.warning,
    ),
    (
      title: 'Store issue complete',
      message: '3 CT meters released for Crew 3.',
      tone: AppAlertVariant.success,
    ),
    (
      title: 'Storm watch',
      message: 'Coastal feeders may need switching.',
      tone: AppAlertVariant.error,
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final now = DateTime.now();
    final tablet = !AppBreakpoints.isCompact(MediaQuery.sizeOf(context).width);

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(dashboardProvider),
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              tablet ? AppSpacing.lg : AppSpacing.md,
              AppSpacing.md,
              tablet ? AppSpacing.lg : AppSpacing.md,
              AppSpacing.xl,
            ),
            sliver: SliverList.list(
              children: [
                _Header(
                  greeting: '${now.greeting}, ${user.firstName}',
                  dateLabel: now.longDate,
                  tablet: tablet,
                ),
                const SizedBox(height: AppSpacing.lg),
                if (tablet)
                  _TabletBody(summaries: data.summaries)
                else
                  _PhoneBody(summaries: data.summaries),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.greeting,
    required this.dateLabel,
    required this.tablet,
  });

  final String greeting;
  final String dateLabel;
  final bool tablet;

  @override
  Widget build(BuildContext context) {
    final title = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: context.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          dateLabel,
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
      ],
    );

    if (!tablet) return title;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: title),
        AppButton(
          label: 'New job',
          leadingIcon: Icons.add,
          expand: false,
          onPressed: () => AppFeedback.toast(context, 'New job (demo)'),
        ),
      ],
    );
  }
}

class _PhoneBody extends StatelessWidget {
  const _PhoneBody({required this.summaries});

  final List<DashboardSummaryItem> summaries;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SummaryGrid(items: summaries, columns: 2),
        const SizedBox(height: AppSpacing.lg),
        const _NetworkMapCard(height: 240),
        const SizedBox(height: AppSpacing.lg),
        const _OperationsCard(),
        const SizedBox(height: AppSpacing.md),
        const _AlertsCard(),
      ],
    );
  }
}

class _TabletBody extends StatelessWidget {
  const _TabletBody({required this.summaries});

  final List<DashboardSummaryItem> summaries;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: _SummaryGrid(items: summaries, columns: 2),
            ),
            const SizedBox(width: AppSpacing.md),
            const Expanded(flex: 3, child: _NetworkMapCard(height: 280)),
            const SizedBox(width: AppSpacing.md),
            const Expanded(flex: 2, child: _AlertsCard()),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        const _OperationsCard(),
      ],
    );
  }
}

class _NetworkMapCard extends StatelessWidget {
  const _NetworkMapCard({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return AppDashboardSection(
      title: 'Network map',
      subtitle: 'Live crew and feeder positions',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppMap(
            height: height,
            center: EdlNetworkSites.colombo,
            markers: EdlNetworkSites.all,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppMapLegend(markers: EdlNetworkSites.all),
        ],
      ),
    );
  }
}

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({required this.items, required this.columns});

  final List<DashboardSummaryItem> items;
  final int columns;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final gap = AppSpacing.sm;
        final width = (constraints.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final item in items)
              SizedBox(
                width: width,
                child: AppKpiCard(
                  icon: _icon(item.type),
                  value: item.value,
                  label: item.label,
                  deltaLabel: item.trendLabel,
                  iconColor: _color(context, item.type),
                  trendColor: _color(context, item.type),
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

class _OperationsCard extends StatelessWidget {
  const _OperationsCard();

  @override
  Widget build(BuildContext context) {
    return AppDashboardSection(
      title: 'Current operations',
      subtitle: 'Jobs moving across the network',
      child: AppCard(
        child: Column(
          children: [
            for (final job in _DashboardBody._operations) ...[
              if (job != _DashboardBody._operations.first)
                const AppDivider(height: AppSpacing.md),
              AppListTile(
                leading: AppIconBox(
                  icon: Icons.bolt_outlined,
                  color: context.colors.primary,
                  size: 36,
                ),
                title: job.title,
                subtitle: '${job.route} · ${job.eta}',
                trailing: AppStatusBadge(status: job.status),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AlertsCard extends StatelessWidget {
  const _AlertsCard();

  @override
  Widget build(BuildContext context) {
    return AppDashboardSection(
      title: 'Alerts',
      subtitle: 'Needs a decision today',
      child: Column(
        children: [
          for (final alert in _DashboardBody._alerts) ...[
            AppAlert(
              variant: alert.tone,
              title: alert.title,
              message: alert.message,
            ),
            if (alert != _DashboardBody._alerts.last)
              const SizedBox(height: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}
