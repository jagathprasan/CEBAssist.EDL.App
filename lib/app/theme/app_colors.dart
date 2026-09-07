import 'package:flutter/material.dart';

/// Brand and semantic colours used by [AppTheme].
///
/// Change values here to restyle the entire application.
class AppBrandColors {
  AppBrandColors._();

  static const Color primary = Color(0xFF0B5ED7);
  static const Color secondary = Color(0xFF00A6A6);
  static const Color accent = Color(0xFFF5B700);
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFDC2626);
  static const Color portfolio = Color(0xFF6D28D9);

  /// Wordmark colours matching the CEBAssist logo artwork.
  static const Color logoGrey = Color(0xFF58595B);
  static const Color logoNavy = Color(0xFF1B5E82);
  static const Color logoOrange = Color(0xFFF25F18);
}

/// Semantic colours exposed through [ThemeData.extensions].
@immutable
class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  const AppSemanticColors({
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.warning,
    required this.onWarning,
    required this.warningContainer,
    required this.accent,
    required this.onAccent,
    required this.info,
    required this.infoContainer,
  });

  factory AppSemanticColors.light() {
    return const AppSemanticColors(
      success: AppBrandColors.success,
      onSuccess: Colors.white,
      successContainer: Color(0xFFDCFCE7),
      warning: AppBrandColors.warning,
      onWarning: Color(0xFF3F2B00),
      warningContainer: Color(0xFFFEF3C7),
      accent: AppBrandColors.accent,
      onAccent: Color(0xFF2A2100),
      info: AppBrandColors.primary,
      infoContainer: Color(0xFFD6E6FF),
    );
  }

  factory AppSemanticColors.dark() {
    return const AppSemanticColors(
      success: Color(0xFF4ADE80),
      onSuccess: Color(0xFF052E16),
      successContainer: Color(0xFF14532D),
      warning: Color(0xFFFBBF24),
      onWarning: Color(0xFF422006),
      warningContainer: Color(0xFF3F2F0A),
      accent: Color(0xFFF5C84D),
      onAccent: Color(0xFF2A2100),
      info: Color(0xFF7AB4FF),
      infoContainer: Color(0xFF163A6B),
    );
  }

  final Color success;
  final Color onSuccess;
  final Color successContainer;
  final Color warning;
  final Color onWarning;
  final Color warningContainer;
  final Color accent;
  final Color onAccent;
  final Color info;
  final Color infoContainer;

  @override
  AppSemanticColors copyWith({
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? warning,
    Color? onWarning,
    Color? warningContainer,
    Color? accent,
    Color? onAccent,
    Color? info,
    Color? infoContainer,
  }) {
    return AppSemanticColors(
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successContainer: successContainer ?? this.successContainer,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      warningContainer: warningContainer ?? this.warningContainer,
      accent: accent ?? this.accent,
      onAccent: onAccent ?? this.onAccent,
      info: info ?? this.info,
      infoContainer: infoContainer ?? this.infoContainer,
    );
  }

  @override
  AppSemanticColors lerp(ThemeExtension<AppSemanticColors>? other, double t) {
    if (other is! AppSemanticColors) return this;
    return AppSemanticColors(
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      successContainer: Color.lerp(
        successContainer,
        other.successContainer,
        t,
      )!,
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      warningContainer: Color.lerp(
        warningContainer,
        other.warningContainer,
        t,
      )!,
      accent: Color.lerp(accent, other.accent, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
      info: Color.lerp(info, other.info, t)!,
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t)!,
    );
  }
}
