import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';
import '../../core/extensions/context_extensions.dart';
import '../../shared/widgets/widgets.dart';

/// Outdoor crew workspace: one current job, large sunlight-friendly targets.
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
    return AppRefreshIndicator(
      onRefresh: () async {
        await Future<void>.delayed(const Duration(milliseconds: 500));
        if (!context.mounted) return;
        AppFeedback.toast(context, 'Jobs refreshed');
      },
      child: AppScrollableColumn(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.md,
          AppSpacing.xl,
        ),
        children: [
          AppAlert(
            variant: AppAlertVariant.success,
            title: 'On site',
            message: 'GPS locked · Unit A feeder · 120 m from the job.',
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            elevated: false,
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Current job',
                      style: context.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
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
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Feeder inspection',
                  style: context.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Unit A · Crew 3',
                  style: context.textTheme.titleMedium?.copyWith(
                    color: context.colors.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                const AppIconLabel(
                  icon: Icons.place_outlined,
                  label: 'Feeder 11, pole 24',
                ),
                const SizedBox(height: AppSpacing.xs),
                const AppIconLabel(
                  icon: Icons.schedule_outlined,
                  label: 'Due 13:00 · 2 hours left',
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
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: AppSpacing.sm,
            crossAxisSpacing: AppSpacing.sm,
            childAspectRatio: 1.35,
            children: [
              _FieldActionTile(
                icon: Icons.near_me_outlined,
                label: 'Navigate',
                onTap: () => AppFeedback.toast(context, 'Opening maps (demo)'),
              ),
              _FieldActionTile(
                icon: Icons.call_outlined,
                label: 'Call office',
                onTap: () =>
                    AppFeedback.toast(context, 'Calling dispatch (demo)'),
              ),
              _FieldActionTile(
                icon: Icons.photo_camera_outlined,
                label: _photoAttached ? 'Photo saved' : 'Capture photo',
                onTap: () {
                  setState(() => _photoAttached = true);
                  AppFeedback.toast(context, 'Photo captured (demo)');
                },
              ),
              _FieldActionTile(
                icon: Icons.wifi_off_outlined,
                label: 'Work offline',
                onTap: () => AppFeedback.toast(
                  context,
                  'Notes will sync when signal returns',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
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
                const SizedBox(height: AppSpacing.sm),
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
        ],
      ),
    );
  }
}

class _FieldActionTile extends StatelessWidget {
  const _FieldActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      elevated: false,
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: context.colors.primary),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
