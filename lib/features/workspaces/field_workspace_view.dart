import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/widgets/app_status_chip.dart';
import '../../shared/widgets/widgets.dart';
import 'workspace_kit.dart';

/// Outdoor crew workspace: one job at a time, large targets, GPS, photos, call.
class FieldWorkspaceView extends StatefulWidget {
  const FieldWorkspaceView({super.key});

  @override
  State<FieldWorkspaceView> createState() => _FieldWorkspaceViewState();
}

class _FieldWorkspaceViewState extends State<FieldWorkspaceView> {
  final _notesController = TextEditingController();
  bool _jobStarted = false;
  bool _photoAttached = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final events = [
      WorkspaceCalendarEvent(
        date: today,
        title: 'Team briefing',
        timeLabel: '08:30',
        location: 'Area office',
        tone: AppStatusTone.info,
      ),
      WorkspaceCalendarEvent(
        date: today,
        title: 'Site inspection',
        timeLabel: '13:00',
        location: 'Unit A feeder',
        tone: AppStatusTone.warning,
      ),
    ];

    return AppRefreshIndicator(
      onRefresh: () async {
        await Future<void>.delayed(const Duration(milliseconds: 500));
        if (!context.mounted) return;
        AppFeedback.toast(context, 'Jobs refreshed');
      },
      child: AppScrollableColumn(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          AppBreadcrumb(
            items: const [
              AppBreadcrumbItem(label: 'Workspaces'),
              AppBreadcrumbItem(label: 'Field'),
              AppBreadcrumbItem(label: 'Today'),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          const AppPageHeader(
            title: 'Field Workspace',
            subtitle: 'Gloves-friendly controls for crews on site.',
          ),
          AppAlert(
            variant: AppAlertVariant.success,
            title: 'On site · GPS locked',
            message:
                'Unit A feeder · 120 m from assigned job. Work offline if signal drops.',
          ),
          const SizedBox(height: AppSpacing.lg),
          AppCard(
            elevated: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Current job',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    AppStatusBadge(
                      status: _jobStarted
                          ? AppEntityStatus.inProgress
                          : AppEntityStatus.pending,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Feeder inspection',
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  'EDL-1042 · Unit A · Crew 3',
                  style: context.textTheme.titleMedium?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                const AppIconLabel(
                  icon: Icons.place_outlined,
                  label: 'Feeder 11 · pole 24, Unit A',
                ),
                const SizedBox(height: AppSpacing.xs),
                const AppIconLabel(
                  icon: Icons.schedule_outlined,
                  label: 'Due 13:00 · 2 hours remaining',
                ),
                const SizedBox(height: AppSpacing.lg),
                AppPrimaryButton(
                  label: _jobStarted ? 'Job in progress' : 'Start job',
                  leadingIcon: Icons.play_arrow_rounded,
                  size: AppButtonSize.lg,
                  onPressed: () {
                    setState(() => _jobStarted = true);
                    AppFeedback.toast(context, 'Job started');
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: AppSecondaryButton(
                  label: 'Navigate',
                  leadingIcon: Icons.near_me_outlined,
                  size: AppButtonSize.lg,
                  onPressed: () =>
                      AppFeedback.toast(context, 'Opening maps (demo)'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppOutlineButton(
                  label: 'Call office',
                  leadingIcon: Icons.call_outlined,
                  size: AppButtonSize.lg,
                  onPressed: () =>
                      AppFeedback.toast(context, 'Calling dispatch (demo)'),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AppOutlineButton(
            label: _photoAttached ? 'Photo attached' : 'Capture photo',
            leadingIcon: Icons.photo_camera_outlined,
            size: AppButtonSize.lg,
            onPressed: () {
              setState(() => _photoAttached = true);
              AppFeedback.toast(context, 'Photo captured (demo)');
            },
          ),
          const SizedBox(height: AppSpacing.xl),
          AppDashboardSection(
            title: "Today's jobs",
            subtitle: 'Tap a card. Large targets for outdoor use.',
            child: Column(
              children: [
                AppMobileDataCard(
                  title: 'EDL-1042  Feeder inspection',
                  entries: const {
                    'Area': 'Unit A',
                    'ETA': '13:00',
                    'Status': 'Current',
                  },
                  trailing: const AppStatusBadge(
                    status: AppEntityStatus.inProgress,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                AppMobileDataCard(
                  title: 'EDL-1048  Meter replacement',
                  entries: const {
                    'Area': 'Unit C',
                    'ETA': '15:30',
                    'Status': 'Next',
                  },
                  trailing: const AppStatusBadge(
                    status: AppEntityStatus.pending,
                  ),
                ),
              ],
            ),
          ),
          AppDashboardSection(
            title: "Today's posts",
            subtitle: 'Briefing and site visits for this crew',
            child: AppCard(
              elevated: false,
              child: WorkspaceCalendar(events: events),
            ),
          ),
          AppDashboardSection(
            title: 'Field report',
            child: AppCard(
              elevated: false,
              child: Column(
                children: [
                  AppTextArea(
                    controller: _notesController,
                    label: 'Site notes',
                    hint: 'What did you find? Keep it short.',
                    minLines: 4,
                    maxLines: 6,
                  ),
                  AppCheckbox(
                    label: 'Attach site photos',
                    value: _photoAttached,
                    onChanged: (value) =>
                        setState(() => _photoAttached = value),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppPrimaryButton(
                    label: 'Submit report',
                    leadingIcon: Icons.cloud_upload_outlined,
                    size: AppButtonSize.lg,
                    onPressed: () =>
                        AppFeedback.toast(context, 'Report sent to office'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}
