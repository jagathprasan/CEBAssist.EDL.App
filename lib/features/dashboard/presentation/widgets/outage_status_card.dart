import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../domain/dashboard_models.dart';

class OutageStatusCard extends StatelessWidget {
  const OutageStatusCard({super.key, required this.outages});

  final OutageBreakdown outages;

  @override
  Widget build(BuildContext context) {
    final total = (outages.planned + outages.unplanned + outages.resolvedToday)
        .clamp(1, 9999);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLowest,
        borderRadius: AppRadius.borderMd,
        boxShadow: appCardShadow(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSectionHeader(title: 'Outage Status'),
          _Segment(
            label: 'Planned',
            value: outages.planned,
            color: context.colors.primary,
            ratio: outages.planned / total,
          ),
          const SizedBox(height: AppSpacing.sm),
          _Segment(
            label: 'Unplanned',
            value: outages.unplanned,
            color: context.semantic.warning,
            ratio: outages.unplanned / total,
          ),
          const SizedBox(height: AppSpacing.sm),
          _Segment(
            label: 'Resolved Today',
            value: outages.resolvedToday,
            color: context.semantic.success,
            ratio: outages.resolvedToday / total,
          ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.value,
    required this.color,
    required this.ratio,
  });

  final String label;
  final int value;
  final Color color;
  final double ratio;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(label, style: context.textTheme.bodyMedium),
            const Spacer(),
            Text(
              '$value',
              style: context.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            minHeight: 8,
            value: ratio.clamp(0, 1),
            color: color,
            backgroundColor: color.withValues(alpha: 0.15),
          ),
        ),
      ],
    );
  }
}
