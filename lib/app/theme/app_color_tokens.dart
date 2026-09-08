import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Canonical colour tokens for the CEBAssist design system.
/// Prefer [Theme.of(context).colorScheme] in widgets; use these for branding.
class AppColors {
  AppColors._();

  static const Color primary = AppBrandColors.primary;
  static const Color secondary = AppBrandColors.secondary;
  static const Color accent = AppBrandColors.accent;
  static const Color success = AppBrandColors.success;
  static const Color warning = AppBrandColors.warning;
  static const Color error = AppBrandColors.error;
  static const Color info = AppBrandColors.primary;

  static const Color logoGrey = AppBrandColors.logoGrey;
  static const Color logoNavy = AppBrandColors.logoNavy;
  static const Color logoOrange = AppBrandColors.logoOrange;
}
