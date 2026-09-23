import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_breakpoints.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/extensions/date_extensions.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading_skeleton.dart';
import '../../../../shared/data/edl_network_sites.dart';
import '../../../../shared/providers/user_provider.dart';
import '../../../../shared/widgets/widgets.dart';
import '../domain/dashboard_models.dart';
import 'providers/dashboard_provider.dart';

/// Warm highlight used the way the delivery reference uses yellow:
/// status cards and “on the way” chips, not the brand blue.
const Color _statusYellow = Color(0xFFF6C445);
const Color _ink = Color(0xFF1A1A1A);

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

class _Job {
  const _Job({
    required this.title,
    required this.route,
    required this.when,
    required this.status,
    required this.active,
  });

  final String title;
  final String route;
  final String when;
  final String status;
  final bool active;
}

const _jobs = [
  _Job(
    title: 'Feeder inspection',
    route: 'Unit A → Pole 24',
    when: 'On schedule',
    status: 'On the way',
    active: true,
  ),
  _Job(
    title: 'Outage coordination',
    route: 'Unit B → Feeder 11',
    when: '+45 min',
    status: 'Delayed',
    active: false,
  ),
  _Job(
    title: 'Meter replacement',
    route: 'Unit C → Consumer service',
    when: '15:30',
    status: 'Queued',
    active: false,
  ),
];

const _alerts = [
  (
    title: 'Feeder 11 delayed',
    message: 'Consumer access pending at Unit B.',
  ),
  (
    title: 'Store issue complete',
    message: '3 CT meters released for Crew 3.',
  ),
  (
    title: 'Storm watch',
    message: 'Coastal feeders may need switching.',
  ),
];

enum _DashTab { overview, map, alerts }

class _DashboardBody extends ConsumerStatefulWidget {
  const _DashboardBody({required this.data});

  final DashboardSnapshot data;

  @override
  ConsumerState<_DashboardBody> createState() => _DashboardBodyState();
}

class _DashboardBodyState extends ConsumerState<_DashboardBody> {
  _DashTab _tab = _DashTab.overview;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final now = DateTime.now();
    final wide = !AppBreakpoints.isCompact(MediaQuery.sizeOf(context).width);
    final lead = _jobs.first;

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(dashboardProvider),
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              wide ? AppSpacing.lg : 20,
              AppSpacing.sm,
              wide ? AppSpacing.lg : 20,
              AppSpacing.xl,
            ),
            sliver: SliverList.list(
              children: [
                _PageTitle(
                  greeting: now.greeting,
                  name: user.firstName,
                  dateLabel: now.longDate,
                ),
                const SizedBox(height: AppSpacing.md),
                _StatusHero(
                  kicker: 'Latest movement',
                  title: lead.title,
                  subtitle: '${lead.route} · ${lead.when}',
                ),
                const SizedBox(height: AppSpacing.lg),
                _UnderlineTabs(
                  selected: _tab,
                  onChanged: (tab) => setState(() => _tab = tab),
                ),
                const SizedBox(height: AppSpacing.lg),
                if (_tab == _DashTab.overview) ...[
                  _LiveFigures(items: widget.data.summaries),
                  const SizedBox(height: AppSpacing.lg),
                  if (wide)
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _FieldActivity()),
                        SizedBox(width: AppSpacing.lg),
                        Expanded(child: _NetworkMap(height: 280)),
                      ],
                    )
                  else ...[
                    const _FieldActivity(),
                    const SizedBox(height: AppSpacing.lg),
                    const _NetworkMap(height: 220),
                  ],
                ] else if (_tab == _DashTab.map)
                  const _NetworkMap(height: 420)
                else
                  const _AlertsList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PageTitle extends StatelessWidget {
  const _PageTitle({
    required this.greeting,
    required this.name,
    required this.dateLabel,
  });

  final String greeting;
  final String name;
  final String dateLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colors.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          name,
          style: context.textTheme.headlineMedium?.copyWith(
            color: context.colors.onSurface,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.6,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          dateLabel,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _StatusHero extends StatelessWidget {
  const _StatusHero({
    required this.kicker,
    required this.title,
    required this.subtitle,
  });

  final String kicker;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 14, 16),
      decoration: BoxDecoration(
        color: _statusYellow,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  kicker,
                  style: context.textTheme.labelLarge?.copyWith(
                    color: _ink.withValues(alpha: 0.72),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: context.textTheme.titleLarge?.copyWith(
                    color: _ink,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: _ink.withValues(alpha: 0.75),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              Icons.electric_bolt_rounded,
              color: _ink,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }
}

class _UnderlineTabs extends StatelessWidget {
  const _UnderlineTabs({required this.selected, required this.onChanged});

  final _DashTab selected;
  final ValueChanged<_DashTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final tab in _DashTab.values) ...[
          _TabLabel(
            label: switch (tab) {
              _DashTab.overview => 'Overview',
              _DashTab.map => 'Map',
              _DashTab.alerts => 'Alerts',
            },
            selected: tab == selected,
            onTap: () => onChanged(tab),
          ),
          if (tab != _DashTab.alerts) const SizedBox(width: 22),
        ],
      ],
    );
  }
}

class _TabLabel extends StatelessWidget {
  const _TabLabel({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? context.colors.onSurface
        : context.colors.onSurfaceVariant;
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.borderSm,
      child: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: context.textTheme.titleSmall?.copyWith(
                color: color,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: 3,
              width: selected ? 28 : 0,
              decoration: BoxDecoration(
                color: _statusYellow,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LiveFigures extends StatelessWidget {
  const _LiveFigures({required this.items});

  final List<DashboardSummaryItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Live figures',
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
            color: context.colors.onSurface,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Waiting on the operational feed',
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < items.length; i++) ...[
              if (i > 0) const SizedBox(width: AppSpacing.md),
              Expanded(child: _Figure(item: items[i])),
            ],
          ],
        ),
      ],
    );
  }
}

class _Figure extends StatelessWidget {
  const _Figure({required this.item});

  final DashboardSummaryItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: AppSurfaces.card(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.labelLarge?.copyWith(
              color: context.colors.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item.value,
            style: context.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: -0.8,
              height: 1,
              color: context.colors.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item.trendLabel,
            style: context.textTheme.labelMedium?.copyWith(
              color: context.colors.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldActivity extends StatelessWidget {
  const _FieldActivity();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Field activity',
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                      color: context.colors.onSurface,
                    ),
                  ),
                  Text(
                    'Jobs moving across the network',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () =>
                  AppFeedback.toast(context, 'Full activity list (demo)'),
              child: const Text('See all'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        for (var i = 0; i < _jobs.length; i++)
          _TimelineRow(job: _jobs[i], last: i == _jobs.length - 1),
      ],
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.job, required this.last});

  final _Job job;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 28,
          child: Column(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: job.active ? _statusYellow : Colors.white,
                  border: Border.all(
                    color: job.active ? _statusYellow : context.colors.outline,
                  ),
                ),
                child: Icon(
                  job.active ? Icons.near_me_rounded : Icons.check_rounded,
                  size: 12,
                  color: _ink,
                ),
              ),
              if (!last)
                Container(
                  width: 1.5,
                  height: 40,
                  color: context.colors.outline,
                ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: last ? 0 : 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  job.title,
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: context.colors.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${job.route} · ${job.when}',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        _StatusPill(label: job.status, filled: job.active),
      ],
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.filled});

  final String label;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: filled ? _statusYellow : const Color(0xFFF1F2F4),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: context.textTheme.labelSmall?.copyWith(
          color: _ink,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _NetworkMap extends StatelessWidget {
  const _NetworkMap({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Network map',
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
            color: context.colors.onSurface,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Live crew and feeder positions',
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: SizedBox(
            height: height,
            child: Stack(
              children: [
                AppMap(
                  height: height,
                  center: EdlNetworkSites.colombo,
                  markers: EdlNetworkSites.all,
                ),
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 12,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x1A1A1A1A),
                          blurRadius: 16,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 16,
                          backgroundColor: Color(0xFFF1F2F4),
                          child: Icon(Icons.bolt_rounded, size: 16, color: _ink),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Colombo network',
                                style: context.textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: context.colors.onSurface,
                                ),
                              ),
                              Text(
                                'Crews and feeders',
                                style: context.textTheme.labelSmall?.copyWith(
                                  color: context.colors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const _StatusPill(label: 'Live', filled: true),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _AlertsList extends StatelessWidget {
  const _AlertsList();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Needs a decision',
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
            color: context.colors.onSurface,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        for (final alert in _alerts) ...[
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            padding: const EdgeInsets.all(14),
            decoration: AppSurfaces.card(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert.title,
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: context.colors.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  alert.message,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
