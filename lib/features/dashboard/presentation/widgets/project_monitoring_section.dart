import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/app_status_chip.dart';
import '../../domain/dashboard_models.dart';

class ProjectMonitoringSection extends StatelessWidget {
  const ProjectMonitoringSection({
    super.key,
    required this.portfolio,
    required this.onRefresh,
  });

  final ProjectPortfolio portfolio;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Project Monitoring Dashboard',
                    style: context.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Live portfolio view of all projects — health, schedule risk, budget and progress',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            TextButton.icon(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Refresh'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        _ProjectMetricGrid(metrics: portfolio.metrics),
        const SizedBox(height: AppSpacing.lg),
        AppSectionHeader(
          title: 'Attention Needed',
          subtitle:
              'Projects that require follow-up — health issues, blocked stages, overdue dates, or progress lag',
          trailing: IconButton(
            tooltip: 'How attention is calculated',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Projects appear here when health is at risk, a stage is blocked, the planned end date has passed, or physical progress is lagging.',
                  ),
                ),
              );
            },
            icon: Icon(
              Icons.info_outline_rounded,
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ),
        _AttentionProjectList(projects: portfolio.attentionProjects),
      ],
    );
  }
}

class _ProjectMetricGrid extends StatelessWidget {
  const _ProjectMetricGrid({required this.metrics});

  final List<ProjectPortfolioMetric> metrics;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final gap = AppSpacing.sm;
        final width = (constraints.maxWidth - gap) / 2;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final metric in metrics)
              SizedBox(
                width: width,
                child: _ProjectMetricCard(metric: metric),
              ),
          ],
        );
      },
    );
  }
}

class _ProjectMetricCard extends StatelessWidget {
  const _ProjectMetricCard({required this.metric});

  final ProjectPortfolioMetric metric;

  @override
  Widget build(BuildContext context) {
    final color = _color(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLowest,
        borderRadius: AppRadius.borderMd,
        boxShadow: appCardShadow(context),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  metric.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.colors.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  metric.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.6,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  metric.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.labelSmall?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          CircleAvatar(
            radius: 18,
            backgroundColor: color.withValues(alpha: 0.14),
            child: Icon(_icon, color: color, size: 18),
          ),
        ],
      ),
    );
  }

  IconData get _icon {
    return switch (metric.type) {
      ProjectMetricType.active => Icons.monitor_heart_outlined,
      ProjectMetricType.attention => Icons.warning_amber_rounded,
      ProjectMetricType.overdue => Icons.event_busy_outlined,
      ProjectMetricType.budget => Icons.account_balance_wallet_outlined,
    };
  }

  Color _color(BuildContext context) {
    return switch (metric.type) {
      ProjectMetricType.active => context.colors.primary,
      ProjectMetricType.attention => context.semantic.warning,
      ProjectMetricType.overdue => context.colors.error,
      ProjectMetricType.budget => AppBrandColors.portfolio,
    };
  }
}

class _AttentionProjectList extends StatelessWidget {
  const _AttentionProjectList({required this.projects});

  final List<ProjectAttentionItem> projects;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final useTwoColumns = constraints.maxWidth >= 640;
        if (!useTwoColumns) {
          return Column(
            children: [
              for (final project in projects)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: _AttentionProjectTile(project: project),
                ),
            ],
          );
        }

        final gap = AppSpacing.sm;
        final width = (constraints.maxWidth - gap) / 2;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final project in projects)
              SizedBox(
                width: width,
                child: _AttentionProjectTile(project: project),
              ),
          ],
        );
      },
    );
  }
}

class _AttentionProjectTile extends StatelessWidget {
  const _AttentionProjectTile({required this.project});

  final ProjectAttentionItem project;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.surfaceContainerLowest,
      borderRadius: AppRadius.borderMd,
      child: InkWell(
        borderRadius: AppRadius.borderMd,
        onTap: () => context.go(AppRoutes.projects),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: _statusColor(context).withValues(alpha: 0.14),
                child: Icon(
                  _statusIcon,
                  size: 16,
                  color: _statusColor(context),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      project.projectCode,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${project.progressLabel} — $_statusLabel',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.labelSmall?.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              AppStatusChip(
                label: _statusLabel,
                tone: _statusTone,
                compact: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String get _statusLabel {
    return switch (project.status) {
      ProjectAttentionStatus.delayed => 'Delayed',
      ProjectAttentionStatus.overdue => 'Overdue',
      ProjectAttentionStatus.blocked => 'Blocked',
    };
  }

  IconData get _statusIcon {
    return switch (project.status) {
      ProjectAttentionStatus.delayed => Icons.schedule_rounded,
      ProjectAttentionStatus.overdue => Icons.event_busy_outlined,
      ProjectAttentionStatus.blocked => Icons.block_rounded,
    };
  }

  AppStatusTone get _statusTone {
    return switch (project.status) {
      ProjectAttentionStatus.delayed => AppStatusTone.warning,
      ProjectAttentionStatus.overdue => AppStatusTone.error,
      ProjectAttentionStatus.blocked => AppStatusTone.error,
    };
  }

  Color _statusColor(BuildContext context) {
    return switch (project.status) {
      ProjectAttentionStatus.delayed => context.semantic.warning,
      ProjectAttentionStatus.overdue => context.colors.error,
      ProjectAttentionStatus.blocked => context.colors.error,
    };
  }
}
