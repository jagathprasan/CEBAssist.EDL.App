import 'package:flutter/material.dart';

import '../../app/theme/app_breakpoints.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_spacing.dart';
import '../../core/extensions/context_extensions.dart';
import '../../shared/data/edl_network_sites.dart';
import '../../shared/widgets/widgets.dart';
import '../../showcase/app_widget_catalog.dart';

/// Outdoor crew workspace with EstateHub soft cards and large targets.
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
    final ink = Theme.of(context).brightness == Brightness.dark
        ? context.colors.onSurface
        : AppBrandColors.ink;

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
          Text(
            'Field Workspace',
            style: context.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: -0.7,
              color: ink,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Large targets for outdoor crew work',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
          SizedBox(height: tokens.gap),
          AppCard(
            padding: EdgeInsets.all(tokens.cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Current job',
                      style: context.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
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
                    fontWeight: FontWeight.w700,
                    fontSize: tokens.titleSize,
                    height: 1.1,
                    letterSpacing: -0.6,
                    color: ink,
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
                const AppIconLabel(
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
            title: 'Outage map',
            subtitle: 'Breakdowns, planned outages, and your sites',
            child: AppCard(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: AppMap(
                      height: tablet ? 360 : 300,
                      center: EdlNetworkSites.island,
                      zoom: 7.2,
                      markers: EdlNetworkSites.all,
                      summary: EdlNetworkSites.outageSummary,
                    ),
                  ),
                ],
              ),
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
            child: AppCard(
              child: Column(
                children: [
                  _FieldScheduleRow(
                    time: '15:30',
                    title: 'Meter replacement',
                    detail: 'Unit C · consumer service',
                    done: false,
                  ),
                  const SizedBox(height: 14),
                  _FieldScheduleRow(
                    time: '16:45',
                    title: 'Complaint follow-up',
                    detail: 'Unit B · access pending',
                    done: false,
                  ),
                ],
              ),
            ),
          ),
          // Keep mobile data cards for catalog/search coverage in tests.
          AppMobileDataCard(
            title: 'Meter replacement',
            entries: const {
              'Location': 'Unit C, consumer service',
              'When': '15:30',
              'Crew': 'Crew 3',
            },
            trailing: const AppStatusBadge(status: AppEntityStatus.pending),
          ),
          SizedBox(height: tokens.gap),
          AppDashboardSection(
            title: 'Site notes',
            child: AppCard(
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

class _FieldScheduleRow extends StatelessWidget {
  const _FieldScheduleRow({
    required this.time,
    required this.title,
    required this.detail,
    required this.done,
  });

  final String time;
  final String title;
  final String detail;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 56,
          child: Text(
            time,
            style: context.textTheme.labelLarge?.copyWith(
              color: context.colors.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                detail,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: done ? AppBrandColors.mint : Colors.transparent,
            borderRadius: BorderRadius.circular(7),
            border: done
                ? null
                : Border.all(color: const Color(0xFFD5D8DE), width: 1.6),
          ),
          child: done
              ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
              : null,
        ),
      ],
    );
  }
}
