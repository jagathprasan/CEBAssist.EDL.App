import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_breakpoints.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/extensions/date_extensions.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading_skeleton.dart';
import '../../../../shared/data/edl_network_sites.dart';
import '../../../../shared/widgets/widgets.dart';
import '../domain/dashboard_models.dart';
import 'providers/dashboard_provider.dart';

const Color _ink = Color(0xFF1C1C1E);
const Color _muted = Color(0xFF8B919A);
const Color _sky = Color(0xFF8EC9F5);
const Color _mint = Color(0xFF6FDB96);
const Color _check = Color(0xFF34C759);

const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
const _bars = [46.0, 70.0, 58.0, 96.0, 78.0, 64.0];
const _trend = [22.0, 26.0, 24.0, 30.0, 28.0, 36.0];
const _revenue = [18.0, 34.0, 26.0, 42.0, 30.0, 48.0, 36.0, 52.0, 40.0, 58.0];

/// Soft EstateHub-style dashboard: white cards, mint/sky charts, schedule.
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
    required this.time,
    required this.title,
    required this.detail,
    required this.done,
  });

  final String time;
  final String title;
  final String detail;
  final bool done;
}

const _jobs = [
  _Job(
    time: '09:00',
    title: 'Feeder inspection',
    detail: 'Unit A → Pole 24',
    done: true,
  ),
  _Job(
    time: '10:00',
    title: 'Outage coordination',
    detail: 'Unit B → Feeder 11',
    done: true,
  ),
  _Job(
    time: '11:30',
    title: 'Meter replacement',
    detail: 'Unit C · Consumer service',
    done: false,
  ),
  _Job(
    time: '13:00',
    title: 'Store issue',
    detail: 'Crew 3 · CT meters',
    done: false,
  ),
];

const _alerts = [
  (title: 'Feeder 11 delayed', message: 'Consumer access pending at Unit B.'),
  (title: 'Store issue complete', message: '3 CT meters released for Crew 3.'),
  (title: 'Storm watch', message: 'Coastal feeders may need switching.'),
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
  int _selectedDay = 2;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final wide = !AppBreakpoints.isCompact(MediaQuery.sizeOf(context).width);

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(dashboardProvider),
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(wide ? 24 : 16, 8, wide ? 24 : 16, 28),
            sliver: SliverList.list(
              children: [
                _Heading(dateLabel: now.longDate),
                const SizedBox(height: 14),
                _PillTabs(
                  selected: _tab,
                  onChanged: (tab) => setState(() => _tab = tab),
                ),
                const SizedBox(height: 16),
                if (_tab == _DashTab.overview)
                  _Overview(
                    items: widget.data.summaries,
                    wide: wide,
                    selectedDay: _selectedDay,
                    onDaySelected: (day) => setState(() => _selectedDay = day),
                  )
                else if (_tab == _DashTab.map)
                  const _MapCard(height: 460)
                else
                  const _AlertsCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading({required this.dateLabel});

  final String dateLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Operations Overview',
          style: context.textTheme.headlineMedium?.copyWith(
            color: _inkColor(context),
            fontWeight: FontWeight.w700,
            letterSpacing: -0.8,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          dateLabel,
          style: context.textTheme.bodySmall?.copyWith(color: _muted),
        ),
      ],
    );
  }
}

class _PillTabs extends StatelessWidget {
  const _PillTabs({required this.selected, required this.onChanged});

  final _DashTab selected;
  final ValueChanged<_DashTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: dark ? context.colors.surfaceContainerHigh : Colors.white,
          borderRadius: BorderRadius.circular(999),
          boxShadow: _cardShadow(context),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final tab in _DashTab.values)
              _Pill(
                label: switch (tab) {
                  _DashTab.overview => 'Overview',
                  _DashTab.map => 'Map',
                  _DashTab.alerts => 'Alerts',
                },
                selected: tab == selected,
                onTap: () => onChanged(tab),
              ),
          ],
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: selected ? _ink : Colors.transparent,
        borderRadius: BorderRadius.circular(999),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
            child: Text(
              label,
              style: context.textTheme.labelLarge?.copyWith(
                color: selected ? Colors.white : _muted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  const _Overview({
    required this.items,
    required this.wide,
    required this.selectedDay,
    required this.onDaySelected,
  });

  final List<DashboardSummaryItem> items;
  final bool wide;
  final int selectedDay;
  final ValueChanged<int> onDaySelected;

  @override
  Widget build(BuildContext context) {
    const bars = _BarCard();
    final figures = _FigureRow(items: items);
    const trend = _TrendCard();
    const revenue = _RevenueCard();
    final schedule = _ScheduleCard(
      selectedDay: selectedDay,
      onDaySelected: onDaySelected,
    );

    if (!wide) {
      return Column(
        children: [
          bars,
          const SizedBox(height: 12),
          figures,
          const SizedBox(height: 12),
          trend,
          const SizedBox(height: 12),
          revenue,
          const SizedBox(height: 12),
          schedule,
          const SizedBox(height: 12),
          const _MapCard(height: 220),
        ],
      );
    }

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(flex: 3, child: bars),
                      const SizedBox(width: 12),
                      Expanded(flex: 2, child: figures),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: trend),
                      SizedBox(width: 12),
                      Expanded(child: revenue),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(flex: 2, child: schedule),
          ],
        ),
        const SizedBox(height: 12),
        const _MapCard(height: 240),
      ],
    );
  }
}

class _FigureRow extends StatelessWidget {
  const _FigureRow({required this.items});

  final List<DashboardSummaryItem> items;

  @override
  Widget build(BuildContext context) {
    final wide = !AppBreakpoints.isCompact(MediaQuery.sizeOf(context).width);
    final cards = [for (final item in items) _FigureCard(item: item)];

    if (wide) {
      return Column(
        children: [
          for (var i = 0; i < cards.length; i++) ...[
            if (i > 0) const SizedBox(height: 12),
            cards[i],
          ],
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < cards.length; i++) ...[
          if (i > 0) const SizedBox(width: 12),
          Expanded(child: cards[i]),
        ],
      ],
    );
  }
}

class _FigureCard extends StatelessWidget {
  const _FigureCard({required this.item});

  final DashboardSummaryItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 14, 14),
      decoration: _softCard(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.titleSmall?.copyWith(
                    color: _inkColor(context),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _CornerAction(icon: Icons.north_east_rounded),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            item.value,
            style: context.textTheme.displaySmall?.copyWith(
              color: _inkColor(context),
              fontWeight: FontWeight.w700,
              letterSpacing: -1.4,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.trendLabel,
            style: context.textTheme.bodySmall?.copyWith(
              color: _mint,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _CornerAction extends StatelessWidget {
  const _CornerAction({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 14, color: _inkColor(context)),
    );
  }
}

class _BarCard extends StatelessWidget {
  const _BarCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 12, 10),
      decoration: _softCard(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Network activity',
            style: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: _inkColor(context),
            ),
          ),
          const SizedBox(height: 2),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '86%',
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: _inkColor(context),
                    letterSpacing: -0.6,
                  ),
                ),
                TextSpan(
                  text: ' of plan',
                  style: context.textTheme.bodyMedium?.copyWith(color: _muted),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 132,
            child: BarChart(
              BarChartData(
                maxY: 100,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 50,
                  getDrawingHorizontalLine: (_) => const FlLine(
                    color: Color(0xFFE8EEF2),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 26,
                      interval: 50,
                      getTitlesWidget: (value, meta) {
                        if (value != 0 && value != 50 && value != 100) {
                          return const SizedBox.shrink();
                        }
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(fontSize: 10, color: _muted),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 20,
                      getTitlesWidget: (value, meta) {
                        final i = value.toInt();
                        if (i < 0 || i >= _months.length) {
                          return const SizedBox.shrink();
                        }
                        return Text(
                          _months[i],
                          style: const TextStyle(fontSize: 10, color: _muted),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: [
                  for (var i = 0; i < _bars.length; i++)
                    BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: _bars[i],
                          width: 14,
                          borderRadius: BorderRadius.circular(7),
                          color: _sky,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendCard extends StatelessWidget {
  const _TrendCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 12, 10),
      decoration: _softCard(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lead trends',
            style: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: _inkColor(context),
            ),
          ),
          const SizedBox(height: 2),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '32',
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: _inkColor(context),
                    letterSpacing: -0.6,
                  ),
                ),
                TextSpan(
                  text: ' average per month',
                  style: context.textTheme.bodyMedium?.copyWith(color: _muted),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 120,
            child: LineChart(
              LineChartData(
                minY: 10,
                maxY: 48,
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: const FlTitlesData(show: false),
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (_) => _ink,
                    getTooltipItems: (spots) => spots
                        .map(
                          (s) => LineTooltipItem(
                            '${_months[s.x.toInt()]}: ${s.y.toInt()} leads',
                            const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    curveSmoothness: 0.34,
                    color: _mint,
                    barWidth: 2.4,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          _mint.withValues(alpha: 0.4),
                          _mint.withValues(alpha: 0.02),
                        ],
                      ),
                    ),
                    spots: [
                      for (var i = 0; i < _trend.length; i++)
                        FlSpot(i.toDouble(), _trend[i]),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RevenueCard extends StatelessWidget {
  const _RevenueCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 12, 10),
      decoration: _softCard(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Revenue',
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: _inkColor(context),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: _ink,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '6 months',
                  style: context.textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '\$8,512',
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: _inkColor(context),
                    letterSpacing: -0.6,
                  ),
                ),
                TextSpan(
                  text: ' average per month',
                  style: context.textTheme.bodyMedium?.copyWith(color: _muted),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 96,
            child: BarChart(
              BarChartData(
                maxY: 70,
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barTouchData: BarTouchData(enabled: false),
                titlesData: const FlTitlesData(show: false),
                barGroups: [
                  for (var i = 0; i < _revenue.length; i++)
                    BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: _revenue[i],
                          width: 7,
                          borderRadius: BorderRadius.circular(4),
                          color: _mint,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  const _ScheduleCard({
    required this.selectedDay,
    required this.onDaySelected,
  });

  final int selectedDay;
  final ValueChanged<int> onDaySelected;

  static const _days = [
    (n: 13, label: 'Mon'),
    (n: 14, label: 'Tue'),
    (n: 15, label: 'Wed'),
    (n: 16, label: 'Thu'),
    (n: 17, label: 'Fri'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 12, 10),
      decoration: _softCard(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Schedule',
                  style: context.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: _inkColor(context),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: _ink,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.ios_share_rounded, size: 13, color: Colors.white),
                    const SizedBox(width: 6),
                    Text(
                      'Share',
                      style: context.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var i = 0; i < _days.length; i++)
                _DayChip(
                  day: _days[i].n,
                  label: _days[i].label,
                  selected: i == selectedDay,
                  onTap: () => onDaySelected(i),
                ),
            ],
          ),
          const SizedBox(height: 14),
          for (final job in _jobs) _ScheduleRow(job: job),
        ],
      ),
    );
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({
    required this.day,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final int day;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Column(
        children: [
          Text(
            label,
            style: context.textTheme.labelSmall?.copyWith(
              color: selected ? _inkColor(context) : _muted,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? _ink : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$day',
              style: context.textTheme.labelLarge?.copyWith(
                color: selected ? Colors.white : _inkColor(context),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScheduleRow extends StatelessWidget {
  const _ScheduleRow({required this.job});

  final _Job job;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 46,
            child: Text(
              job.time,
              style: context.textTheme.labelMedium?.copyWith(
                color: _muted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  job.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: _inkColor(context),
                  ),
                ),
                Text(
                  job.detail,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodySmall?.copyWith(color: _muted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: job.done ? _check : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: job.done
                  ? null
                  : Border.all(color: const Color(0xFFD5D8DE), width: 1.4),
            ),
            child: job.done
                ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
                : null,
          ),
        ],
      ),
    );
  }
}

class _MapCard extends StatelessWidget {
  const _MapCard({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 12),
      decoration: _softCard(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 10),
            child: Text(
              'Outage map',
              style: context.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: _inkColor(context),
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: AppMap(
              height: height,
              center: EdlNetworkSites.island,
              zoom: 7.2,
              markers: EdlNetworkSites.all,
              summary: EdlNetworkSites.outageSummary,
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertsCard extends StatelessWidget {
  const _AlertsCard();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final alert in _alerts)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: _softCard(context),
            child: Row(
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFD5D8DE), width: 1.4),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        alert.title,
                        style: context.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: _inkColor(context),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        alert.message,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: _muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

BoxDecoration _softCard(BuildContext context) {
  final dark = Theme.of(context).brightness == Brightness.dark;
  return BoxDecoration(
    color: dark ? context.colors.surfaceContainerLowest : Colors.white,
    borderRadius: BorderRadius.circular(24),
    boxShadow: _cardShadow(context),
  );
}

List<BoxShadow> _cardShadow(BuildContext context) {
  final dark = Theme.of(context).brightness == Brightness.dark;
  return [
    BoxShadow(
      color: const Color(0xFF1B3A4B).withValues(alpha: dark ? 0.28 : 0.07),
      blurRadius: 28,
      offset: const Offset(0, 12),
      spreadRadius: -8,
    ),
  ];
}

Color _inkColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? context.colors.onSurface
      : _ink;
}
