import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';
import '../../shared/widgets/widgets.dart';
import 'workspace_kit.dart';

/// Office/Field demo surface built on the shared design-system widgets.
/// Mode density still comes from [WorkspaceScope].
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
  DateTime? _dueDate = DateTime.now().add(const Duration(days: 1));
  bool _notifyOffice = true;
  bool _attachPhotos = false;
  String _search = '';
  Set<String> _viewModes = {'List'};

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
    AppDataColumn(keyName: 'id', label: 'Job'),
    AppDataColumn(keyName: 'area', label: 'Area'),
    AppDataColumn(keyName: 'status', label: 'Status'),
    AppDataColumn(keyName: 'eta', label: 'ETA'),
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
    final gap = metrics.gap;
    final filteredRows = _rows.where((row) {
      final matchesFilter = _filter == 'All' || row['status'] == _filter;
      final matchesSearch =
          _search.isEmpty ||
          row.values.any(
            (value) => value.toLowerCase().contains(_search.toLowerCase()),
          );
      return matchesFilter && matchesSearch;
    }).toList();

    return AppRefreshIndicator(
      onRefresh: () async {
        await Future<void>.delayed(const Duration(milliseconds: 600));
        if (!context.mounted) return;
        AppFeedback.toast(context, 'Workspace refreshed');
      },
      child: AppScrollableColumn(
        padding: EdgeInsets.all(
          metrics.isField ? AppSpacing.lg : AppSpacing.md,
        ),
        children: [
          AppPageHeader(title: widget.title, subtitle: widget.subtitle),
          AppInfoCard(
            title: metrics.isField ? 'Field mode' : 'Office mode',
            message: metrics.isField
                ? 'Larger type and controls for outdoor use. Built with shared design-system widgets.'
                : 'Denser layout for desk work. Built with the same shared widgets as Field.',
          ),
          SizedBox(height: gap),
          AppDashboardSection(
            title: 'Key metrics',
            child: metrics.isField
                ? Column(
                    children: [
                      AppMetricCard(
                        label: 'Jobs today',
                        value: '6',
                        icon: Icons.engineering_outlined,
                      ),
                      SizedBox(height: gap),
                      AppMetricCard(
                        label: 'Completed',
                        value: '2',
                        icon: Icons.task_alt_outlined,
                      ),
                    ],
                  )
                : Row(
                    children: [
                      const Expanded(
                        child: AppKpiCard(
                          label: 'Open tickets',
                          value: '24',
                          icon: Icons.assignment_outlined,
                          deltaLabel: '+3 today',
                        ),
                      ),
                      SizedBox(width: gap),
                      const Expanded(
                        child: AppKpiCard(
                          label: 'In review',
                          value: '8',
                          icon: Icons.fact_check_outlined,
                          deltaLabel: '2 urgent',
                        ),
                      ),
                    ],
                  ),
          ),
          AppDashboardSection(
            title: 'Quick actions',
            child: Column(
              children: [
                AppPrimaryButton(
                  label: metrics.isField ? 'Start job' : 'Review assignments',
                  leadingIcon: metrics.isField
                      ? Icons.play_arrow_rounded
                      : Icons.inbox_outlined,
                  onPressed: () =>
                      AppFeedback.toast(context, 'Primary action (demo)'),
                ),
                SizedBox(height: gap / 2),
                AppSecondaryButton(
                  label: metrics.isField ? 'Report issue' : 'Approve requests',
                  leadingIcon: metrics.isField
                      ? Icons.report_outlined
                      : Icons.done_all_outlined,
                  onPressed: () {},
                ),
                SizedBox(height: gap / 2),
                AppOutlineButton(
                  label: metrics.isField ? 'Call office' : 'Export summary',
                  leadingIcon: metrics.isField
                      ? Icons.call_outlined
                      : Icons.file_download_outlined,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          AppDashboardSection(
            title: 'Search & filters',
            child: AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppSearchField(
                    controller: _searchController,
                    hint: 'Search jobs, areas, accounts',
                    onChanged: (value) => setState(() => _search = value),
                  ),
                  SizedBox(height: gap),
                  Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: [
                      for (final option in const [
                        'All',
                        'Open',
                        'In progress',
                        'Waiting',
                      ])
                        AppChip(
                          label: option,
                          selected: _filter == option,
                          onSelected: (_) => setState(() => _filter = option),
                        ),
                    ],
                  ),
                  SizedBox(height: gap),
                  AppMultiSelect<String>(
                    label: 'View',
                    options: const ['List', 'Board', 'Map'],
                    labels: const ['List', 'Board', 'Map'],
                    selected: _viewModes,
                    onChanged: (value) => setState(() => _viewModes = value),
                  ),
                ],
              ),
            ),
          ),
          AppDashboardSection(
            title: 'Jobs',
            child: AppAdaptiveDataTable(
              columns: _columns,
              rows: filteredRows,
              onRowTap: (row) =>
                  AppFeedback.toast(context, 'Opened ${row['id']}'),
            ),
          ),
          AppDashboardSection(
            title: 'Status board',
            child: AppCard(
              child: Column(
                children: [
                  AppListTile(
                    title: 'Feeder inspection',
                    subtitle: 'Unit A · assigned to crew 3',
                    trailing: const AppStatusBadge(
                      status: AppEntityStatus.pending,
                    ),
                  ),
                  AppListTile(
                    title: 'Meter replacement',
                    subtitle: 'Unit C · parts confirmed',
                    trailing: const AppStatusBadge(
                      status: AppEntityStatus.inProgress,
                    ),
                  ),
                  AppListTile(
                    title: 'Complaint follow-up',
                    subtitle: 'Closed by supervisor',
                    trailing: const AppStatusBadge(
                      status: AppEntityStatus.completed,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AppDashboardSection(
            title: 'Analytics',
            child: Column(
              children: [
                AppChartContainer(
                  title: 'Trend',
                  child: const WorkspaceLineChart(points: _linePoints),
                ),
                SizedBox(height: gap),
                AppChartContainer(
                  title: 'Area workload',
                  child: const WorkspaceBarChart(points: _barPoints),
                ),
                SizedBox(height: gap),
                AppChartContainer(
                  title: 'Job mix',
                  child: const WorkspaceDonutChart(
                    segments: _donutPoints,
                    centerLabel: '88\njobs',
                  ),
                ),
              ],
            ),
          ),
          AppDashboardSection(
            title: 'Progress',
            child: Column(
              children: [
                AppProgressSummary(
                  title: 'Daily completion',
                  progress: 0.62,
                  caption: '12 of 19 planned tasks finished',
                ),
                SizedBox(height: gap),
                AppProgressSummary(
                  title: 'Material requests',
                  progress: 0.35,
                  caption: 'Awaiting store issue for 3 items',
                ),
                SizedBox(height: gap),
                AppStatusDistribution(
                  slices: const [
                    AppStatusSlice(label: 'Open', count: 24),
                    AppStatusSlice(label: 'In progress', count: 16),
                    AppStatusSlice(label: 'Closed', count: 48),
                  ],
                ),
              ],
            ),
          ),
          AppDashboardSection(
            title: 'Schedule',
            child: AppCard(child: WorkspaceCalendar(events: _events)),
          ),
          AppDashboardSection(
            title: 'Work form',
            child: AppCard(
              child: Column(
                children: [
                  AppTextField(
                    controller: _accountController,
                    label: 'Account / location',
                    hint: 'Enter account or site reference',
                    prefixIcon: Icons.place_outlined,
                    required: true,
                  ),
                  SizedBox(height: gap),
                  AppDropdown<String>(
                    label: 'Priority',
                    value: _priority,
                    items: const [
                      DropdownMenuItem(value: 'Low', child: Text('Low')),
                      DropdownMenuItem(value: 'Normal', child: Text('Normal')),
                      DropdownMenuItem(value: 'High', child: Text('High')),
                      DropdownMenuItem(
                        value: 'Critical',
                        child: Text('Critical'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) setState(() => _priority = value);
                    },
                  ),
                  SizedBox(height: gap),
                  AppDatePickerField(
                    label: 'Due date',
                    value: _dueDate,
                    onChanged: (value) => setState(() => _dueDate = value),
                  ),
                  SizedBox(height: gap),
                  AppTextArea(
                    controller: _notesController,
                    label: 'Notes',
                    hint: 'Add observations or instructions',
                    minLines: metrics.isField ? 4 : 3,
                    maxLines: metrics.isField ? 6 : 5,
                  ),
                  AppCheckbox(
                    label: 'Attach site photos',
                    value: _attachPhotos,
                    onChanged: (value) => setState(() => _attachPhotos = value),
                  ),
                  AppSwitch(
                    label: 'Notify office',
                    subtitle: 'Send update to dispatch when saved',
                    value: _notifyOffice,
                    onChanged: (value) => setState(() => _notifyOffice = value),
                  ),
                  SizedBox(height: gap),
                  AppPrimaryButton(
                    label: 'Save work record',
                    leadingIcon: Icons.save_outlined,
                    onPressed: () =>
                        AppFeedback.toast(context, 'Work record saved (demo)'),
                  ),
                ],
              ),
            ),
          ),
          AppInfoCard(
            title: 'Shared component kit',
            message:
                'Office and Field now compose screens from lib/shared/widgets. Charts and calendar remain workspace-specific; density still follows WorkspaceMode.',
          ),
          SizedBox(height: gap * 2),
        ],
      ),
    );
  }
}
