import 'package:flutter/material.dart';

import '../../../app/theme/app_sizes.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';

enum AppButtonSize { sm, md, lg }

double _height(AppButtonSize size) => switch (size) {
  AppButtonSize.sm => AppSizes.buttonHeightSm,
  AppButtonSize.md => AppSizes.buttonHeightMd,
  AppButtonSize.lg => AppSizes.buttonHeightLg,
};

/// Shared button shell used by all App*Button variants.
class _AppButtonShell extends StatelessWidget {
  const _AppButtonShell({
    required this.label,
    required this.onPressed,
    required this.builder,
    this.leadingIcon,
    this.trailingIcon,
    this.isLoading = false,
    this.expand = false,
    this.size = AppButtonSize.md,
    this.semanticLabel,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget Function(
    BuildContext context,
    Widget child,
    VoidCallback? onPressed,
  )
  builder;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final bool isLoading;
  final bool expand;
  final AppButtonSize size;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !isLoading;
    final child = isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              color: context.colors.onPrimary,
            ),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (leadingIcon != null) ...[
                Icon(leadingIcon, size: AppSizes.iconSm),
                const SizedBox(width: AppSpacing.xs),
              ],
              Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
              if (trailingIcon != null) ...[
                const SizedBox(width: AppSpacing.xs),
                Icon(trailingIcon, size: AppSizes.iconSm),
              ],
            ],
          );

    final button = builder(context, child, enabled ? onPressed : null);

    final sized = SizedBox(
      height: _height(size),
      width: expand ? double.infinity : null,
      child: button,
    );

    return Semantics(
      button: true,
      enabled: enabled,
      label: semanticLabel ?? label,
      child: sized,
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
    this.size = AppButtonSize.md,
    this.semanticLabel,
    this.backgroundColor,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final bool isLoading;
  final bool expand;
  final AppButtonSize size;
  final String? semanticLabel;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return _AppButtonShell(
      label: label,
      onPressed: onPressed,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      isLoading: isLoading,
      expand: expand,
      size: size,
      semanticLabel: semanticLabel,
      builder: (context, child, pressed) => FilledButton(
        onPressed: pressed,
        style: backgroundColor == null
            ? null
            : FilledButton.styleFrom(backgroundColor: backgroundColor),
        child: child,
      ),
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
    this.size = AppButtonSize.md,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? leadingIcon;
  final bool isLoading;
  final bool expand;
  final AppButtonSize size;

  @override
  Widget build(BuildContext context) {
    return _AppButtonShell(
      label: label,
      onPressed: onPressed,
      leadingIcon: leadingIcon,
      isLoading: isLoading,
      expand: expand,
      size: size,
      builder: (context, child, pressed) =>
          FilledButton.tonal(onPressed: pressed, child: child),
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
    this.size = AppButtonSize.md,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? leadingIcon;
  final bool isLoading;
  final bool expand;
  final AppButtonSize size;

  @override
  Widget build(BuildContext context) {
    return _AppButtonShell(
      label: label,
      onPressed: onPressed,
      leadingIcon: leadingIcon,
      isLoading: isLoading,
      expand: expand,
      size: size,
      builder: (context, child, pressed) {
        final loadingChild = isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  color: context.colors.primary,
                ),
              )
            : child;
        return OutlinedButton(onPressed: pressed, child: loadingChild);
      },
    );
  }
}

class AppTextButton extends StatelessWidget {
  const AppTextButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.leadingIcon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? leadingIcon;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: leadingIcon == null
          ? const SizedBox.shrink()
          : Icon(leadingIcon, size: AppSizes.iconSm),
      label: Text(label),
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
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      tooltip: tooltip,
      style: IconButton.styleFrom(
        minimumSize: const Size(AppSizes.touchTarget, AppSizes.touchTarget),
      ),
      constraints: const BoxConstraints(
        minWidth: AppSizes.touchTarget,
        minHeight: AppSizes.touchTarget,
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
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? leadingIcon;
  final bool isLoading;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    return AppPrimaryButton(
      label: label,
      onPressed: onPressed,
      leadingIcon: leadingIcon,
      isLoading: isLoading,
      expand: expand,
      backgroundColor: context.colors.error,
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
