import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';
import '../../core/extensions/context_extensions.dart';
import 'workspace_mode.dart';

class WorkspaceInfoBanner extends StatelessWidget {
  const WorkspaceInfoBanner({
    super.key,
    required this.message,
    this.icon = Icons.info_outline,
    this.tone = WorkspaceBannerTone.info,
  });

  final String message;
  final IconData icon;
  final WorkspaceBannerTone tone;

  @override
  Widget build(BuildContext context) {
    final metrics = WorkspaceScope.metricsOf(context);
    final colors = switch (tone) {
      WorkspaceBannerTone.info => (
        bg: context.semantic.infoContainer,
        fg: context.semantic.info,
      ),
      WorkspaceBannerTone.success => (
        bg: context.semantic.successContainer,
        fg: context.semantic.success,
      ),
      WorkspaceBannerTone.warning => (
        bg: context.semantic.warningContainer,
        fg: context.semantic.warning,
      ),
      WorkspaceBannerTone.error => (
        bg: context.colors.errorContainer,
        fg: context.colors.error,
      ),
    };

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(metrics.cardPadding),
      decoration: BoxDecoration(
        color: colors.bg,
        borderRadius: AppRadius.borderMd,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colors.fg, size: metrics.iconSize),
          SizedBox(width: metrics.gap / 2),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: metrics.bodySize,
                fontWeight: FontWeight.w600,
                color: context.colors.onSurface,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum WorkspaceBannerTone { info, success, warning, error }

class WorkspaceProgressBar extends StatelessWidget {
  const WorkspaceProgressBar({
    super.key,
    required this.label,
    required this.value,
    this.helper,
  });

  final String label;
  final double value;
  final String? helper;

  @override
  Widget build(BuildContext context) {
    final metrics = WorkspaceScope.metricsOf(context);
    final clamped = value.clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: metrics.bodySize,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              '${(clamped * 100).round()}%',
              style: TextStyle(
                fontSize: metrics.labelSize,
                fontWeight: FontWeight.w800,
                color: context.colors.primary,
              ),
            ),
          ],
        ),
        SizedBox(height: metrics.gap / 2),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: clamped,
            minHeight: metrics.isField ? 14 : 8,
            backgroundColor: context.colors.surfaceContainerHigh,
          ),
        ),
        if (helper != null) ...[
          SizedBox(height: metrics.gap / 3),
          Text(
            helper!,
            style: TextStyle(
              fontSize: metrics.labelSize,
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}

class WorkspaceSegmentedControl extends StatelessWidget {
  const WorkspaceSegmentedControl({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  final List<String> options;
  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final metrics = WorkspaceScope.metricsOf(context);
    return SegmentedButton<String>(
      segments: [
        for (final option in options)
          ButtonSegment(
            value: option,
            label: Padding(
              padding: EdgeInsets.symmetric(vertical: metrics.isField ? 8 : 2),
              child: Text(
                option,
                style: TextStyle(
                  fontSize: metrics.labelSize,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
      selected: {selected},
      onSelectionChanged: (values) {
        if (values.isNotEmpty) onChanged(values.first);
      },
    );
  }
}

class WorkspaceSectionTitle extends StatelessWidget {
  const WorkspaceSectionTitle({super.key, required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final metrics = WorkspaceScope.metricsOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: metrics.titleSize,
            fontWeight: metrics.titleWeight,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: TextStyle(
              fontSize: metrics.subtitleSize,
              color: context.colors.onSurfaceVariant,
              height: 1.35,
            ),
          ),
        ],
      ],
    );
  }
}
