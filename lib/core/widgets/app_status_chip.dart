import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';
import '../extensions/context_extensions.dart';

enum AppStatusTone { success, warning, error, info, neutral }

class AppStatusChip extends StatelessWidget {
  const AppStatusChip({
    super.key,
    required this.label,
    this.tone = AppStatusTone.neutral,
    this.compact = false,
  });

  final String label;
  final AppStatusTone tone;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = _palette(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? AppSpacing.xs : AppSpacing.sm,
        vertical: compact ? 2 : AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: context.textTheme.labelSmall?.copyWith(
          color: colors.foreground,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  ({Color background, Color foreground}) _palette(BuildContext context) {
    final semantic = context.semantic;
    final colors = context.colors;
    return switch (tone) {
      AppStatusTone.success => (
        background: semantic.successContainer,
        foreground: semantic.success,
      ),
      AppStatusTone.warning => (
        background: semantic.warningContainer,
        foreground: semantic.warning,
      ),
      AppStatusTone.error => (
        background: colors.errorContainer,
        foreground: colors.error,
      ),
      AppStatusTone.info => (
        background: semantic.infoContainer,
        foreground: semantic.info,
      ),
      AppStatusTone.neutral => (
        background: colors.surfaceContainerHigh,
        foreground: colors.onSurfaceVariant,
      ),
    };
  }
}
