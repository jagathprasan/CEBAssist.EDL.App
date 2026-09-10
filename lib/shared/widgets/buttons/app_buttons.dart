import 'package:flutter/material.dart';

import '../../../app/theme/app_design_tokens.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_ui_mode.dart';
import '../../../core/extensions/context_extensions.dart';

enum AppButtonSize { sm, md, lg }

enum AppButtonVariant { primary, secondary, outline, text, danger }

AppButtonSizeToken _sizeToken(AppButtonSize size) => switch (size) {
  AppButtonSize.sm => AppButtonSizeToken.sm,
  AppButtonSize.md => AppButtonSizeToken.md,
  AppButtonSize.lg => AppButtonSizeToken.lg,
};

/// Shared button used by Field and Office. Pass [mode] or inherit [AppUiModeScope].
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.mode,
    this.variant = AppButtonVariant.primary,
    this.leadingIcon,
    this.trailingIcon,
    this.isLoading = false,
    this.expand = true,
    this.size,
    this.semanticLabel,
    this.backgroundColor,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppUiMode? mode;
  final AppButtonVariant variant;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final bool isLoading;
  final bool expand;
  final AppButtonSize? size;
  final String? semanticLabel;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final resolvedMode = resolveAppUiMode(context, mode);
    final tokens = AppDesignTokens.of(resolvedMode);
    final resolvedSize =
        size ?? (resolvedMode.isField ? AppButtonSize.lg : AppButtonSize.md);
    final height = tokens.buttonHeightFor(_sizeToken(resolvedSize));
    final iconSize = tokens.buttonIconSize;
    final enabled = onPressed != null && !isLoading;
    final progressColor = switch (variant) {
      AppButtonVariant.primary ||
      AppButtonVariant.danger => context.colors.onPrimary,
      AppButtonVariant.secondary ||
      AppButtonVariant.outline ||
      AppButtonVariant.text => context.colors.primary,
    };

    final child = isLoading
        ? SizedBox(
            width: iconSize,
            height: iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              color: progressColor,
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leadingIcon != null) ...[
                Icon(leadingIcon, size: iconSize),
                SizedBox(width: tokens.gap / 2),
              ],
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: resolvedMode.isField ? tokens.bodySize : null,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (trailingIcon != null) ...[
                SizedBox(width: tokens.gap / 2),
                Icon(trailingIcon, size: iconSize),
              ],
            ],
          );

    final style = ButtonStyle(
      minimumSize: WidgetStatePropertyAll(
        Size(expand ? double.infinity : 0, height),
      ),
      elevation: const WidgetStatePropertyAll(0),
      shape: const WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: AppRadius.borderSm),
      ),
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(
          horizontal: tokens.fieldPaddingH,
          vertical: resolvedMode.isField ? AppSpacing.sm : AppSpacing.xs,
        ),
      ),
    );

    final primaryFill = backgroundColor ?? context.colors.primary;
    final dangerFill = backgroundColor ?? context.colors.error;

    final button = switch (variant) {
      AppButtonVariant.primary => FilledButton(
        onPressed: enabled ? onPressed : null,
        style: style.copyWith(
          backgroundColor: WidgetStatePropertyAll(primaryFill),
          foregroundColor: WidgetStatePropertyAll(context.colors.onPrimary),
        ),
        child: child,
      ),
      AppButtonVariant.secondary => FilledButton.tonal(
        onPressed: enabled ? onPressed : null,
        style: style,
        child: child,
      ),
      AppButtonVariant.outline => OutlinedButton(
        onPressed: enabled ? onPressed : null,
        style: style,
        child: child,
      ),
      AppButtonVariant.text => TextButton(
        onPressed: enabled ? onPressed : null,
        style: style,
        child: child,
      ),
      AppButtonVariant.danger => FilledButton(
        onPressed: enabled ? onPressed : null,
        style: style.copyWith(
          backgroundColor: WidgetStatePropertyAll(dangerFill),
          foregroundColor: WidgetStatePropertyAll(context.colors.onError),
        ),
        child: child,
      ),
    };

    return Semantics(
      button: true,
      enabled: enabled,
      label: semanticLabel ?? label,
      child: SizedBox(
        height: height,
        width: expand ? double.infinity : null,
        child: button,
      ),
    );
  }
}

class FieldButton extends StatelessWidget {
  const FieldButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.leadingIcon,
    this.isLoading = false,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? leadingIcon;
  final bool isLoading;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      mode: AppUiMode.field,
      label: label,
      onPressed: onPressed,
      variant: variant,
      leadingIcon: leadingIcon,
      isLoading: isLoading,
      expand: expand,
    );
  }
}

class OfficeButton extends StatelessWidget {
  const OfficeButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.leadingIcon,
    this.isLoading = false,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? leadingIcon;
  final bool isLoading;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      mode: AppUiMode.office,
      label: label,
      onPressed: onPressed,
      variant: variant,
      leadingIcon: leadingIcon,
      isLoading: isLoading,
      expand: expand,
    );
  }
}

class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.leadingIcon,
    this.trailingIcon,
    this.isLoading = false,
    this.expand = true,
    this.size,
    this.semanticLabel,
    this.backgroundColor,
    this.mode,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final bool isLoading;
  final bool expand;
  final AppButtonSize? size;
  final String? semanticLabel;
  final Color? backgroundColor;
  final AppUiMode? mode;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      mode: mode,
      label: label,
      onPressed: onPressed,
      variant: AppButtonVariant.primary,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      isLoading: isLoading,
      expand: expand,
      size: size,
      semanticLabel: semanticLabel,
      backgroundColor: backgroundColor,
    );
  }
}

class AppSecondaryButton extends StatelessWidget {
  const AppSecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.leadingIcon,
    this.isLoading = false,
    this.expand = true,
    this.size,
    this.mode,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? leadingIcon;
  final bool isLoading;
  final bool expand;
  final AppButtonSize? size;
  final AppUiMode? mode;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      mode: mode,
      label: label,
      onPressed: onPressed,
      variant: AppButtonVariant.secondary,
      leadingIcon: leadingIcon,
      isLoading: isLoading,
      expand: expand,
      size: size,
    );
  }
}

class AppOutlineButton extends StatelessWidget {
  const AppOutlineButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.leadingIcon,
    this.isLoading = false,
    this.expand = true,
    this.size,
    this.mode,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? leadingIcon;
  final bool isLoading;
  final bool expand;
  final AppButtonSize? size;
  final AppUiMode? mode;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      mode: mode,
      label: label,
      onPressed: onPressed,
      variant: AppButtonVariant.outline,
      leadingIcon: leadingIcon,
      isLoading: isLoading,
      expand: expand,
      size: size,
    );
  }
}

class AppTextButton extends StatelessWidget {
  const AppTextButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.leadingIcon,
    this.mode,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? leadingIcon;
  final AppUiMode? mode;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      mode: mode,
      label: label,
      onPressed: onPressed,
      variant: AppButtonVariant.text,
      leadingIcon: leadingIcon,
      expand: false,
      size: AppButtonSize.md,
    );
  }
}

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.semanticLabel,
    this.mode,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final String? semanticLabel;
  final AppUiMode? mode;

  @override
  Widget build(BuildContext context) {
    final tokens = AppDesignTokens.of(resolveAppUiMode(context, mode));
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, size: tokens.iconSize),
      tooltip: tooltip,
      style: IconButton.styleFrom(
        minimumSize: Size(tokens.touchTarget, tokens.touchTarget),
      ),
      constraints: BoxConstraints(
        minWidth: tokens.touchTarget,
        minHeight: tokens.touchTarget,
      ),
    );
  }
}

class AppDangerButton extends StatelessWidget {
  const AppDangerButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.leadingIcon,
    this.isLoading = false,
    this.expand = true,
    this.mode,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? leadingIcon;
  final bool isLoading;
  final bool expand;
  final AppUiMode? mode;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      mode: mode,
      label: label,
      onPressed: onPressed,
      variant: AppButtonVariant.danger,
      leadingIcon: leadingIcon,
      isLoading: isLoading,
      expand: expand,
    );
  }
}

class AppFloatingButton extends StatelessWidget {
  const AppFloatingButton({
    super.key,
    required this.onPressed,
    this.icon = Icons.add,
    this.label,
    this.tooltip,
  });

  final VoidCallback? onPressed;
  final IconData icon;
  final String? label;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    if (label == null) {
      return FloatingActionButton(
        onPressed: onPressed,
        tooltip: tooltip,
        child: Icon(icon),
      );
    }
    return FloatingActionButton.extended(
      onPressed: onPressed,
      tooltip: tooltip,
      icon: Icon(icon),
      label: Text(label!),
    );
  }
}
