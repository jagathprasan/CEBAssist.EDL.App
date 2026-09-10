import 'package:flutter/material.dart';

import '../../app/theme/app_breakpoints.dart';
import '../../app/theme/app_spacing.dart';
import '../../core/extensions/context_extensions.dart';
import '../../shared/data/edl_network_sites.dart';
import '../../shared/widgets/widgets.dart';
import '../../showcase/app_widget_catalog.dart';

/// Outdoor crew workspace: large sunlight-friendly targets plus the shared kit.
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
    final tokens = AppDesignTokens.ofContext(context);
    final tablet = !AppBreakpoints.isCompact(MediaQuery.sizeOf(context).width);
    return AppRefreshIndicator(
      onRefresh: () async {
        await Future<void>.delayed(const Duration(milliseconds: 500));
        if (!context.mounted) return;
        AppFeedback.toast(context, 'Jobs refreshed');
      },
      child: AppScrollableColumn(
        padding: EdgeInsets.fromLTRB(
          tokens.cardPadding,
          AppSpacing.sm,
          tokens.cardPadding,
          AppSpacing.xl,
        ),
        children: [
          AppAlert(
            variant: AppAlertVariant.success,
            title: 'On site',
            message: 'GPS locked · Unit A feeder · 120 m from the job.',
          ),
          SizedBox(height: tokens.gap),
          AppCard(
            elevated: false,
            padding: EdgeInsets.all(tokens.cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Current job',
                      style: context.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: tokens.labelSize,
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                    const Spacer(),
                    AppStatusBadge(
                      status: _jobStarted
                          ? AppEntityStatus.inProgress
                          : AppEntityStatus.pending,
                    ),
                  ],
                ),
                SizedBox(height: tokens.gap / 2),
                Text(
                  'Feeder inspection',
                  style: context.textTheme.headlineMedium?.copyWith(
                    fontWeight: tokens.titleWeight,
                    fontSize: tokens.titleSize,
                    height: 1.1,
                  ),
                ),
                SizedBox(height: tokens.gap / 3),
                Text(
                  'Unit A · Crew 3',
                  style: context.textTheme.titleMedium?.copyWith(
                    color: context.colors.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                    fontSize: tokens.subtitleSize,
                  ),
                ),
                SizedBox(height: tokens.gap),
                AppIconLabel(
                  icon: Icons.place_outlined,
                  label: 'Feeder 11, pole 24',
                ),
                SizedBox(height: tokens.gap / 3),
                const AppIconLabel(
                  icon: Icons.schedule_outlined,
                  label: 'Due 13:00 · 2 hours left',
                ),
                SizedBox(height: tokens.sectionGap / 2),
                AppButton(
                  label: _jobStarted ? 'Job in progress' : 'Start job',
                  leadingIcon: Icons.play_arrow_rounded,
                  onPressed: () {
                    setState(() => _jobStarted = true);
                    AppFeedback.toast(context, 'Job started');
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: tokens.gap),
          AppDashboardSection(
            title: 'Job map',
            subtitle: 'Your current site and next stops',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppMap(
                  height: tablet ? 320 : 260,
                  center: EdlNetworkSites.colombo,
                  markers: EdlNetworkSites.field,
                ),
                SizedBox(height: tokens.gap / 2),
                AppMapLegend(markers: EdlNetworkSites.field),
              ],
            ),
          ),
          AppQuickActionGrid(
            crossAxisCount: tablet ? 4 : 2,
            actions: [
              AppQuickAction(
                icon: Icons.near_me_outlined,
                label: 'Navigate',
                onTap: () => AppFeedback.toast(context, 'Opening maps (demo)'),
              ),
              AppQuickAction(
                icon: Icons.call_outlined,
                label: 'Call office',
                onTap: () =>
                    AppFeedback.toast(context, 'Calling dispatch (demo)'),
              ),
              AppQuickAction(
                icon: Icons.photo_camera_outlined,
                label: _photoAttached ? 'Photo saved' : 'Capture photo',
                onTap: () {
                  setState(() => _photoAttached = true);
                  AppFeedback.toast(context, 'Photo captured (demo)');
                },
              ),
              AppQuickAction(
                icon: Icons.wifi_off_outlined,
                label: 'Work offline',
                onTap: () => AppFeedback.toast(
                  context,
                  'Notes will sync when signal returns',
                ),
              ),
            ],
          ),
          SizedBox(height: tokens.sectionGap),
          AppDashboardSection(
            title: 'Up next',
            subtitle: 'Large cards. Tap to open the next site.',
            child: Column(
              children: [
                AppMobileDataCard(
                  title: 'Meter replacement',
                  entries: const {
                    'Location': 'Unit C, consumer service',
                    'When': '15:30',
                    'Crew': 'Crew 3',
                  },
                  trailing: const AppStatusBadge(
                    status: AppEntityStatus.pending,
                  ),
                ),
                SizedBox(height: tokens.gap),
                AppMobileDataCard(
                  title: 'Complaint follow-up',
                  entries: const {
                    'Location': 'Unit B, access pending',
                    'When': '16:45',
                    'Crew': 'Crew 3',
                  },
                  trailing: const AppStatusBadge(
                    status: AppEntityStatus.delayed,
                  ),
                ),
              ],
            ),
          ),
          AppDashboardSection(
            title: 'Site notes',
            child: AppCard(
              elevated: false,
              padding: EdgeInsets.all(tokens.cardPadding),
              child: Column(
                children: [
                  AppTextArea(
                    controller: _notesController,
                    label: 'What did you find?',
                    hint: 'Short note. Gloves-friendly keyboard.',
                    minLines: 4,
                    maxLines: 6,
                  ),
                  AppCheckbox(
                    label: 'Photo attached',
                    value: _photoAttached,
                    onChanged: (value) =>
                        setState(() => _photoAttached = value),
                  ),
                  SizedBox(height: tokens.gap),
                  AppButton(
                    label: 'Submit report',
                    leadingIcon: Icons.cloud_upload_outlined,
                    onPressed: () =>
                        AppFeedback.toast(context, 'Report sent to office'),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: tokens.sectionGap),
          const AppWidgetCatalog(),
        ],
      ),
    );
  }
}
