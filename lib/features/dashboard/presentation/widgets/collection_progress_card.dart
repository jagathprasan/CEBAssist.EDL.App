import 'package:flutter/material.dart';

import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../domain/dashboard_models.dart';

class CollectionProgressCard extends StatelessWidget {
  const CollectionProgressCard({super.key, required this.progress});

  final CollectionProgress progress;

  @override
  Widget build(BuildContext context) {
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
          const AppSectionHeader(title: 'Collection Progress'),
          Row(
            children: [
              Expanded(
                child: _Metric(
                  label: 'Monthly Target',
                  value: AppFormatters.lkrBillions(
                    progress.monthlyTargetBillions,
                  ),
                ),
              ),
              Expanded(
                child: _Metric(
                  label: 'Collected',
                  value: AppFormatters.lkrBillions(progress.collectedBillions),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Text(
                'Completion',
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              Text(
                AppFormatters.percent(progress.completionPercent),
                style: context.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: context.semantic.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 10,
              value: progress.completionRatio.clamp(0, 1),
              backgroundColor: context.colors.surfaceContainerHigh,
              color: context.semantic.success,
            ),
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
