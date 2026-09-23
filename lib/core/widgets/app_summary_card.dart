import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';
import '../../app/theme/app_theme.dart';
import '../extensions/context_extensions.dart';

class AppSummaryCard extends StatelessWidget {
  const AppSummaryCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.trendLabel,
    required this.color,
    this.trendUp = true,
  });

  final IconData icon;
  final String value;
  final String label;
  final String trendLabel;
  final Color color;
  final bool trendUp;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: AppSurfaces.card(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.labelLarge?.copyWith(
                    color: context.colors.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: -0.7,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            trendLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.labelMedium?.copyWith(
              color: trendUp ? context.semantic.success : context.colors.error,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
