import 'package:flutter/material.dart';

/// Typography scale helpers. Prefer [Theme.of(context).textTheme] in widgets.
class AppTypography {
  AppTypography._();

  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;

  static const double displayLarge = 32;
  static const double displayMedium = 28;
  static const double headline = 24;
  static const double titleLarge = 20;
  static const double titleMedium = 16;
  static const double bodyLarge = 16;
  static const double bodyMedium = 14;
  static const double bodySmall = 12;
  static const double labelLarge = 14;
  static const double labelSmall = 11;
}
