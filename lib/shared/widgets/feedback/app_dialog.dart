import 'package:flutter/material.dart';

import '../../../app/theme/app_shadows.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../buttons/app_buttons.dart';

enum AppDialogTone { info, success, warning, error }

/// Soft, rounded dialog chrome used by confirmations and alerts.
class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    required this.title,
    required this.message,
    this.tone = AppDialogTone.info,
    this.icon,
    this.primaryLabel = 'OK',
    this.secondaryLabel,
    this.isDestructive = false,
  });

  final String title;
  final String message;
  final AppDialogTone tone;
  final IconData? icon;
  final String primaryLabel;
  final String? secondaryLabel;
  final bool isDestructive;

  static Future<T?> show<T>(BuildContext context, {required Widget child}) {
    return showDialog<T>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.38),
      builder: (context) => child,
    );
  }

  static Future<void> alert(
    BuildContext context, {
    required String title,
    required String message,
    AppDialogTone tone = AppDialogTone.info,
    String label = 'OK',
  }) {
    return show<void>(
      context,
      child: AppDialog(
        title: title,
        message: message,
        tone: tone,
        primaryLabel: label,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = _palette(context);
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(AppSpacing.lg),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.xl,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        decoration: BoxDecoration(
          color: context.colors.surfaceContainerLowest,
          borderRadius: AppRadius.borderLg,
          boxShadow: AppShadows.lg(context),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: palette.background,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon ?? palette.icon,
                color: palette.foreground,
                size: 30,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              title,
              textAlign: TextAlign.center,
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colors.onSurfaceVariant,
                height: 1.45,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: primaryLabel,
              variant: isDestructive
                  ? AppButtonVariant.danger
                  : AppButtonVariant.primary,
              onPressed: () => Navigator.of(context).pop(true),
            ),
            if (secondaryLabel != null) ...[
              const SizedBox(height: AppSpacing.sm),
              AppButton(
                label: secondaryLabel!,
                variant: AppButtonVariant.text,
                onPressed: () => Navigator.of(context).pop(false),
              ),
            ],
          ],
        ),
      ),
    );
  }

  ({Color background, Color foreground, IconData icon}) _palette(
    BuildContext context,
  ) {
    final semantic = context.semantic;
    final colors = context.colors;
    return switch (tone) {
      AppDialogTone.info => (
        background: semantic.infoContainer,
        foreground: semantic.info,
        icon: Icons.info_outline_rounded,
      ),
      AppDialogTone.success => (
        background: semantic.successContainer,
        foreground: semantic.success,
        icon: Icons.check_circle_outline_rounded,
      ),
      AppDialogTone.warning => (
        background: semantic.warningContainer,
        foreground: semantic.warning,
        icon: Icons.warning_amber_rounded,
      ),
      AppDialogTone.error => (
        background: colors.errorContainer,
        foreground: colors.error,
        icon: Icons.error_outline_rounded,
      ),
    };
  }
}
