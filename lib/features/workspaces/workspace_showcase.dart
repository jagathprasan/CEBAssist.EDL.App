import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/widgets/app_status_chip.dart';
import '../../shared/widgets/widgets.dart';
import 'workspace_kit.dart';

/// Office dashboard built from the Metronic-aligned shared widget kit.
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
  late final List<AppFeedPost> _posts;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    _events = [
      WorkspaceCalendarEvent(
        date: today,
        title: 'Team briefing',
        timeLabel: '08:30',
        subtitle: 'Dispatch desk · daily assignments',
        location: 'Area office',
        tone: AppStatusTone.info,
      ),
      WorkspaceCalendarEvent(
        date: today,
        title: 'Site inspection',
        timeLabel: '13:00',
        subtitle: 'Feeder walk-down with crew 3',
        location: 'Unit A',
        tone: AppStatusTone.warning,
      ),
      WorkspaceCalendarEvent(
        date: today.add(const Duration(days: 1)),
        title: 'Meter replacement',
        timeLabel: '10:00',
        subtitle: 'Account 038601 · booked with store',
        location: 'Unit C',
        tone: AppStatusTone.success,
      ),
      WorkspaceCalendarEvent(
        date: today.add(const Duration(days: 3)),
        title: 'Outage coordination',
        timeLabel: '09:15',
        subtitle: 'Planned switching with NSO',
        location: 'Unit B',
        tone: AppStatusTone.error,
      ),
    ];
    _posts = [
      const AppFeedPost(
        title: 'Crew 3 started feeder inspection',
        timeLabel: '08:42',
        subtitle: 'EDL-1042 · Unit A · GPS ping received',
        author: 'Field',
        tone: AppStatusTone.info,
      ),
      const AppFeedPost(
        title: 'Material request approved',
        timeLabel: '09:05',
        subtitle: '3 CT meters issued from store',
        author: 'Store',
        tone: AppStatusTone.success,
      ),
      const AppFeedPost(
        title: 'Complaint follow-up delayed',
        timeLabel: '09:18',
        subtitle: 'Waiting for consumer access at Unit B',
        author: 'Office',
        tone: AppStatusTone.warning,
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
    final gap = AppSpacing.md;
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
        padding: AppSpacing.pagePadding,
        children: [
          AppBreadcrumb(
            items: const [
              AppBreadcrumbItem(label: 'Workspaces'),
              AppBreadcrumbItem(label: 'Office'),
              AppBreadcrumbItem(label: 'Dashboard'),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          AppPageHeader(title: widget.title, subtitle: widget.subtitle),
          AppAlert(
            variant: AppAlertVariant.info,
            title: 'Desk operations',
            message:
                'Review assignments, track field posts, and clear delayed work from one dashboard.',
          ),
          SizedBox(height: gap),
          AppDashboardSection(
            title: 'Key metrics',
            subtitle: 'Live operational snapshot',
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AppKpiCard(
                        label: 'Active jobs',
                        value: '24',
                        icon: Icons.assignment_outlined,
                        iconColor: context.colors.primary,
                        deltaLabel: '+3 today',
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: AppKpiCard(
                        label: 'At risk',
                        value: '5',
                        icon: Icons.warning_amber_outlined,
                        iconColor: context.semantic.warning,
                        deltaLabel: '2 overdue',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: AppKpiCard(
                        label: 'Completed',
                        value: '18',
                        icon: Icons.task_alt_outlined,
                        iconColor: context.semantic.success,
                        deltaLabel: '75% of plan',
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: AppKpiCard(
                        label: 'Delayed',
                        value: '3',
                        icon: Icons.schedule_outlined,
                        iconColor: context.colors.error,
                        deltaLabel: 'Needs attention',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          AppDashboardSection(
            title: 'Attention needed',
            subtitle: 'Items that should be cleared from the desk today',
            child: AppCard(
              elevated: false,
              child: Column(
                children: [
                  AppListTile(
                    leading: AppIconBox(
                      icon: Icons.warning_amber_outlined,
                      color: context.semantic.warning,
                      size: 36,
                    ),
                    title: 'Outage coordination',
                    subtitle: 'EDL-1051 · delayed consumer access',
                    trailing: const AppStatusBadge(
                      status: AppEntityStatus.delayed,
                    ),
                  ),
                  const AppDivider(height: AppSpacing.md),
                  AppListTile(
                    leading: AppIconBox(
                      icon: Icons.hourglass_bottom,
                      color: context.colors.primary,
                      size: 36,
                    ),
                    title: 'Meter replacement',
                    subtitle: 'EDL-1048 · waiting store issue',
                    trailing: const AppStatusBadge(
                      status: AppEntityStatus.inProgress,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AppDashboardSection(
            title: 'Jobs',
            child: Column(
              children: [
                AppSearchField(
                  controller: _searchController,
                  hint: 'Search jobs, areas, accounts',
                  onChanged: (value) => setState(() => _search = value),
                ),
                const SizedBox(height: AppSpacing.sm),
                AppToggleGroup(
                  options: const ['All', 'Open', 'In progress', 'Waiting'],
                  selected: _filter,
                  onChanged: (value) => setState(() => _filter = value),
                ),
                const SizedBox(height: AppSpacing.md),
                AppAdaptiveDataTable(
                  columns: _columns,
                  rows: filteredRows,
                  onRowTap: (row) =>
                      AppFeedback.toast(context, 'Opened ${row['id']}'),
                ),
              ],
            ),
          ),
          AppDashboardSection(
            title: 'Status distribution',
            child: AppStatusDistribution(
              slices: [
                AppStatusSlice(
                  label: 'Open',
                  count: 24,
                  color: context.colors.primary,
                ),
                AppStatusSlice(
                  label: 'In progress',
                  count: 16,
                  color: context.semantic.warning,
                ),
                AppStatusSlice(
                  label: 'Closed',
                  count: 48,
                  color: context.semantic.success,
                ),
              ],
            ),
          ),
          AppDashboardSection(
            title: 'Posts',
            subtitle: 'Live field and office updates',
            child: Column(
              children: [
                for (final post in _posts) ...[
                  post,
                  const SizedBox(height: AppSpacing.sm),
                ],
              ],
            ),
          ),
          AppDashboardSection(
            title: 'Schedule',
            subtitle: 'Select a day to view calendar posts',
            child: AppCard(
              elevated: false,
              child: WorkspaceCalendar(events: _events),
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
              ],
            ),
          ),
          AppDashboardSection(
            title: 'Work form',
            child: AppCard(
              elevated: false,
              child: Column(
                children: [
                  AppStepper(
                    steps: const ['Details', 'Assign', 'Confirm'],
                    currentStep: 0,
                  ),
                  const SizedBox(height: AppSpacing.md),
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
          SizedBox(height: gap * 2),
        ],
      ),
    );
  }
}
