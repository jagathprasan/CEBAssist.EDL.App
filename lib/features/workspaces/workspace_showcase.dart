import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';
import '../../core/widgets/app_status_chip.dart';
import 'workspace_kit.dart';

/// Shared catalog of professional workspace components.
/// Office and Field pages use the same widgets; density comes from [WorkspaceScope].
class WorkspaceShowcase extends StatefulWidget {
  const WorkspaceShowcase({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  State<WorkspaceShowcase> createState() => _WorkspaceShowcaseState();
}

class _WorkspaceShowcaseState extends State<WorkspaceShowcase> {
  final _searchController = TextEditingController();
  final _accountController = TextEditingController();
  final _notesController = TextEditingController();

  String _filter = 'All';
  String _priority = 'Normal';
  String _viewMode = 'List';
  DateTime? _dueDate = DateTime.now().add(const Duration(days: 1));
  bool _notifyOffice = true;
  bool _attachPhotos = false;
  String _search = '';

  static const _linePoints = [
    WorkspaceChartPoint(label: 'Mon', value: 12),
    WorkspaceChartPoint(label: 'Tue', value: 18),
    WorkspaceChartPoint(label: 'Wed', value: 15),
    WorkspaceChartPoint(label: 'Thu', value: 22),
    WorkspaceChartPoint(label: 'Fri', value: 19),
    WorkspaceChartPoint(label: 'Sat', value: 11),
    WorkspaceChartPoint(label: 'Sun', value: 9),
  ];

  static const _barPoints = [
    WorkspaceChartPoint(label: 'North', value: 34),
    WorkspaceChartPoint(label: 'South', value: 28),
    WorkspaceChartPoint(label: 'East', value: 41),
    WorkspaceChartPoint(label: 'West', value: 22),
  ];

  static const _donutPoints = [
    WorkspaceChartPoint(label: 'Open', value: 24),
    WorkspaceChartPoint(label: 'In progress', value: 16),
    WorkspaceChartPoint(label: 'Closed', value: 48),
  ];

  static const _columns = [
    WorkspaceTableColumn(keyName: 'id', label: 'Job', flex: 2),
    WorkspaceTableColumn(keyName: 'area', label: 'Area', flex: 2),
    WorkspaceTableColumn(keyName: 'status', label: 'Status', flex: 2),
    WorkspaceTableColumn(keyName: 'eta', label: 'ETA', flex: 1, numeric: true),
  ];

  static final _rows = [
    {'id': 'EDL-1042', 'area': 'Unit A', 'status': 'Open', 'eta': '2h'},
    {'id': 'EDL-1048', 'area': 'Unit C', 'status': 'In progress', 'eta': '4h'},
    {'id': 'EDL-1051', 'area': 'Unit B', 'status': 'Waiting', 'eta': '1d'},
  ];

  late final List<WorkspaceCalendarEvent> _events;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    _events = [
      WorkspaceCalendarEvent(
        date: today,
        title: 'Team briefing',
        timeLabel: '08:30',
      ),
      WorkspaceCalendarEvent(
        date: today,
        title: 'Site inspection',
        timeLabel: '13:00',
      ),
      WorkspaceCalendarEvent(
        date: today.add(const Duration(days: 1)),
        title: 'Meter replacement',
        timeLabel: '10:00',
      ),
      WorkspaceCalendarEvent(
        date: today.add(const Duration(days: 3)),
        title: 'Outage coordination',
        timeLabel: '09:15',
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    _accountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final metrics = WorkspaceScope.metricsOf(context);
    final filteredRows = _rows.where((row) {
      final matchesFilter = _filter == 'All' || row['status'] == _filter;
      final matchesSearch =
          _search.isEmpty ||
          row.values.any(
            (value) => value.toLowerCase().contains(_search.toLowerCase()),
          );
      return matchesFilter && matchesSearch;
    }).toList();

    return ListView(
      padding: EdgeInsets.all(metrics.isField ? AppSpacing.lg : AppSpacing.md),
      children: [
        WorkspaceSectionTitle(title: widget.title, subtitle: widget.subtitle),
        SizedBox(height: metrics.gap),
        WorkspaceInfoBanner(
          message: metrics.isField
              ? 'Field mode: larger type and buttons for outdoor use. Same components as Office.'
              : 'Office mode: denser controls for desk work. Same components as Field.',
          tone: WorkspaceBannerTone.info,
        ),
        SizedBox(height: metrics.gap),
        if (metrics.isField) ...[
          WorkspaceMetricTile(
            label: 'Jobs today',
            value: '6',
            icon: Icons.engineering_outlined,
          ),
          SizedBox(height: metrics.gap),
          WorkspaceMetricTile(
            label: 'Completed',
            value: '2',
            icon: Icons.task_alt_outlined,
          ),
        ] else
          Row(
            children: [
              const Expanded(
                child: WorkspaceMetricTile(
                  label: 'Open tickets',
                  value: '24',
                  icon: Icons.assignment_outlined,
                ),
              ),
              SizedBox(width: metrics.gap),
              const Expanded(
                child: WorkspaceMetricTile(
                  label: 'In review',
                  value: '8',
                  icon: Icons.fact_check_outlined,
                ),
              ),
            ],
          ),
        SizedBox(height: metrics.gap),
        WorkspaceCard(
          title: 'Quick actions',
          icon: Icons.flash_on_outlined,
          child: Column(
            children: [
              WorkspaceActionButton(
                label: metrics.isField ? 'Start job' : 'Review assignments',
                icon: metrics.isField
                    ? Icons.play_arrow_rounded
                    : Icons.inbox_outlined,
                onPressed: () {},
              ),
              SizedBox(height: metrics.gap / 2),
              WorkspaceActionButton(
                label: metrics.isField ? 'Report issue' : 'Approve requests',
                icon: metrics.isField
                    ? Icons.report_outlined
                    : Icons.done_all_outlined,
                tone: WorkspaceButtonTone.secondary,
                onPressed: () {},
              ),
              SizedBox(height: metrics.gap / 2),
              WorkspaceActionButton(
                label: metrics.isField ? 'Call office' : 'Export summary',
                icon: metrics.isField
                    ? Icons.call_outlined
                    : Icons.file_download_outlined,
                tone: WorkspaceButtonTone.outline,
                onPressed: () {},
              ),
            ],
          ),
        ),
        SizedBox(height: metrics.gap),
        WorkspaceCard(
          title: 'Search & filters',
          icon: Icons.filter_alt_outlined,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WorkspaceSearchField(
                controller: _searchController,
                hint: 'Search jobs, areas, accounts',
                onChanged: (value) => setState(() => _search = value),
              ),
              SizedBox(height: metrics.gap),
              WorkspaceFilterChips(
                options: const ['All', 'Open', 'In progress', 'Waiting'],
                selected: _filter,
                onSelected: (value) => setState(() => _filter = value),
              ),
              SizedBox(height: metrics.gap),
              WorkspaceSegmentedControl(
                options: const ['List', 'Board', 'Map'],
                selected: _viewMode,
                onChanged: (value) => setState(() => _viewMode = value),
              ),
            ],
          ),
        ),
        SizedBox(height: metrics.gap),
        WorkspaceCard(
          title: 'Data table',
          icon: Icons.table_chart_outlined,
          child: WorkspaceDataTable(
            columns: _columns,
            rows: filteredRows,
            onRowTap: (row) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Opened ${row['id']}')));
            },
          ),
        ),
        SizedBox(height: metrics.gap),
        WorkspaceCard(
          title: 'Status list',
          icon: Icons.view_list_outlined,
          child: Column(
            children: [
              WorkspaceStatusRow(
                title: 'Feeder inspection',
                subtitle: 'Unit A · assigned to crew 3',
                status: 'Open',
                tone: AppStatusTone.info,
              ),
              WorkspaceStatusRow(
                title: 'Meter replacement',
                subtitle: 'Unit C · parts confirmed',
                status: 'In progress',
                tone: AppStatusTone.warning,
              ),
              WorkspaceStatusRow(
                title: 'Complaint follow-up',
                subtitle: 'Closed by supervisor',
                status: 'Done',
                tone: AppStatusTone.success,
              ),
            ],
          ),
        ),
        SizedBox(height: metrics.gap),
        WorkspaceCard(
          title: 'Trend chart',
          icon: Icons.show_chart,
          child: const WorkspaceLineChart(points: _linePoints),
        ),
        SizedBox(height: metrics.gap),
        WorkspaceCard(
          title: 'Area workload',
          icon: Icons.bar_chart_outlined,
          child: const WorkspaceBarChart(points: _barPoints),
        ),
        SizedBox(height: metrics.gap),
        WorkspaceCard(
          title: 'Job mix',
          icon: Icons.pie_chart_outline,
          child: const WorkspaceDonutChart(
            segments: _donutPoints,
            centerLabel: '88\njobs',
          ),
        ),
        SizedBox(height: metrics.gap),
        WorkspaceCard(
          title: 'Progress',
          icon: Icons.trending_up,
          child: Column(
            children: [
              WorkspaceProgressBar(
                label: 'Daily completion',
                value: 0.62,
                helper: '12 of 19 planned tasks finished',
              ),
              SizedBox(height: metrics.gap),
              WorkspaceProgressBar(
                label: 'Material requests',
                value: 0.35,
                helper: 'Awaiting store issue for 3 items',
              ),
            ],
          ),
        ),
        SizedBox(height: metrics.gap),
        WorkspaceCard(
          title: 'Calendar',
          icon: Icons.calendar_month_outlined,
          child: WorkspaceCalendar(events: _events),
        ),
        SizedBox(height: metrics.gap),
        WorkspaceCard(
          title: 'Work form',
          icon: Icons.edit_note_outlined,
          child: Column(
            children: [
              WorkspaceTextField(
                label: 'Account / location',
                controller: _accountController,
                hint: 'Enter account or site reference',
                prefixIcon: Icons.place_outlined,
              ),
              SizedBox(height: metrics.gap),
              WorkspaceDropdown<String>(
                label: 'Priority',
                value: _priority,
                items: const [
                  DropdownMenuItem(value: 'Low', child: Text('Low')),
                  DropdownMenuItem(value: 'Normal', child: Text('Normal')),
                  DropdownMenuItem(value: 'High', child: Text('High')),
                  DropdownMenuItem(value: 'Critical', child: Text('Critical')),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _priority = value);
                },
              ),
              SizedBox(height: metrics.gap),
              WorkspaceDateField(
                label: 'Due date',
                value: _dueDate,
                onChanged: (value) => setState(() => _dueDate = value),
              ),
              SizedBox(height: metrics.gap),
              WorkspaceTextField(
                label: 'Notes',
                controller: _notesController,
                hint: 'Add observations or instructions',
                maxLines: metrics.isField ? 4 : 3,
                prefixIcon: Icons.notes_outlined,
              ),
              SizedBox(height: metrics.gap),
              WorkspaceCheckboxTile(
                label: 'Attach site photos',
                value: _attachPhotos,
                onChanged: (value) => setState(() => _attachPhotos = value),
              ),
              WorkspaceSwitchTile(
                label: 'Notify office',
                subtitle: 'Send update to dispatch when saved',
                value: _notifyOffice,
                onChanged: (value) => setState(() => _notifyOffice = value),
              ),
              SizedBox(height: metrics.gap),
              WorkspaceActionButton(
                label: 'Save work record',
                icon: Icons.save_outlined,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Work record saved (demo).')),
                  );
                },
              ),
            ],
          ),
        ),
        SizedBox(height: metrics.gap),
        WorkspaceCard(
          title: 'Component kit',
          icon: Icons.widgets_outlined,
          child: WorkspaceEmptyHint(
            message:
                'Shared kit: buttons, cards, metrics, banners, search, filters, segmented control, tables, status rows, line/bar/donut charts, progress, calendar, and forms. Field and Office only change density through WorkspaceMode.',
          ),
        ),
        SizedBox(height: metrics.gap * 2),
      ],
    );
  }
}
