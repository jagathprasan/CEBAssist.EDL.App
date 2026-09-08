import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_routes.dart';
import '../../app/theme/app_spacing.dart';
import '../../core/extensions/context_extensions.dart';
import 'workspace_components.dart';
import 'workspace_mode.dart';

class OfficeWorkspaceScreen extends StatelessWidget {
  const OfficeWorkspaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const WorkspaceScope(
      mode: WorkspaceMode.office,
      child: _OfficeBody(),
    );
  }
}

class _OfficeBody extends StatelessWidget {
  const _OfficeBody();

  @override
  Widget build(BuildContext context) {
    final metrics = WorkspaceScope.metricsOf(context);
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Text(
          'Office Workspace',
          style: context.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: metrics.titleSize + 4,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Desk-side operations for indoor staff: denser layout, more detail, faster scanning.',
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colors.onSurfaceVariant,
            fontSize: metrics.subtitleSize,
          ),
        ),
        SizedBox(height: metrics.gap),
        Row(
          children: [
            Expanded(
              child: WorkspaceMetricTile(
                label: 'Open tickets',
                value: '24',
                icon: Icons.assignment_outlined,
              ),
            ),
            SizedBox(width: metrics.gap),
            Expanded(
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
          title: 'Office actions',
          icon: Icons.desktop_windows_outlined,
          child: Column(
            children: [
              WorkspaceActionButton(
                label: 'Review assignments',
                icon: Icons.inbox_outlined,
                onPressed: () {},
              ),
              SizedBox(height: metrics.gap / 2),
              WorkspaceActionButton(
                label: 'Approve requests',
                icon: Icons.done_all_outlined,
                tone: WorkspaceButtonTone.secondary,
                onPressed: () {},
              ),
              SizedBox(height: metrics.gap / 2),
              WorkspaceActionButton(
                label: 'Open reports',
                icon: Icons.bar_chart_outlined,
                tone: WorkspaceButtonTone.outline,
                onPressed: () => context.go(AppRoutes.reports),
              ),
            ],
          ),
        ),
        SizedBox(height: metrics.gap),
        WorkspaceCard(
          title: 'Shared components',
          icon: Icons.widgets_outlined,
          child: WorkspaceEmptyHint(
            message:
                'Buttons, cards, and metrics on this page use WorkspaceActionButton, WorkspaceCard, and WorkspaceMetricTile. Field Workspace reuses the same set with a larger density.',
          ),
        ),
      ],
    );
  }
}
