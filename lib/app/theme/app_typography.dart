import 'package:flutter/material.dart';

/// Typography scale for the app.
///
/// The face is Inter, the same family Metronic loads in Web1B
/// (`Inter` 300–700). Sizes follow Metronic’s scale, including the
/// custom `2sm` (13px) and `2xs` (11px) steps.
/// Prefer [Theme.of(context).textTheme] in widgets.
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
  static const double bodySmall = 13;
  static const double labelLarge = 14;
  static const double labelMedium = 12;
  static const double labelSmall = 11;

  static const double trackingDisplay = -0.8;
  static const double trackingTitle = -0.3;
}
