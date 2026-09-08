import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_routes.dart';
import '../../app/theme/app_spacing.dart';
import '../../core/extensions/context_extensions.dart';
import 'workspace_components.dart';
import 'workspace_mode.dart';

class FieldWorkspaceScreen extends StatelessWidget {
  const FieldWorkspaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const WorkspaceScope(mode: WorkspaceMode.field, child: _FieldBody());
  }
}

class _FieldBody extends StatelessWidget {
  const _FieldBody();

  @override
  Widget build(BuildContext context) {
    final metrics = WorkspaceScope.metricsOf(context);
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Text(
          'Field Workspace',
          style: context.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: metrics.titleSize,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Outdoor crew layout: large type, simple taps, gloves-friendly buttons.',
          style: TextStyle(
            fontSize: metrics.subtitleSize,
            color: context.colors.onSurfaceVariant,
            height: 1.35,
          ),
        ),
        SizedBox(height: metrics.gap),
        WorkspaceMetricTile(
          label: 'Jobs today',
          value: '6',
          icon: Icons.engineering_outlined,
        ),
        SizedBox(height: metrics.gap),
        WorkspaceCard(
          title: 'Field actions',
          icon: Icons.handyman_outlined,
          child: Column(
            children: [
              WorkspaceActionButton(
                label: 'Start job',
                icon: Icons.play_arrow_rounded,
                onPressed: () {},
              ),
              SizedBox(height: metrics.gap),
              WorkspaceActionButton(
                label: 'Report issue',
                icon: Icons.report_outlined,
                tone: WorkspaceButtonTone.secondary,
                onPressed: () {},
              ),
              SizedBox(height: metrics.gap),
              WorkspaceActionButton(
                label: 'Call office',
                icon: Icons.call_outlined,
                tone: WorkspaceButtonTone.outline,
                onPressed: () => context.go(AppRoutes.officeWorkspace),
              ),
            ],
          ),
        ),
        SizedBox(height: metrics.gap),
        WorkspaceCard(
          title: 'Same components, larger',
          icon: Icons.touch_app_outlined,
          child: WorkspaceEmptyHint(
            message:
                'This page uses the same WorkspaceActionButton, WorkspaceCard, and WorkspaceMetricTile as Office Workspace. Only WorkspaceMode.field changes size and tap targets.',
          ),
        ),
      ],
    );
  }
}
