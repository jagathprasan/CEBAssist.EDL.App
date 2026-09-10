import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';
import '../extensions/context_extensions.dart';

class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final child = isLoading
        ? SizedBox(
            height: 22,
            width: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.4,
              color: colors.onPrimary,
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20),
                const SizedBox(width: AppSpacing.xs),
              ],
              Text(label),
            ],
          );

    final button = FilledButton(
      onPressed: isLoading ? null : onPressed,
      style: FilledButton.styleFrom(
        // Keep the primary fill while loading so the button stays visible
        // on dark surfaces (Material's default disabled tint is too muted).
        disabledBackgroundColor: colors.primary,
        disabledForegroundColor: colors.onPrimary,
      ),
      child: child,
    );

    if (!expand) return button;
    return SizedBox(width: double.infinity, child: button);
  }
}
