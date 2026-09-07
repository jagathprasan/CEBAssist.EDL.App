import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_spacing.dart';

/// Builds complete Material 3 [ThemeData] for light and dark modes.
class AppTheme {
  AppTheme._();

  static ThemeData light() => _build(Brightness.light);

  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final colorScheme = isDark ? _darkScheme : _lightScheme;
    final semantic = isDark
        ? AppSemanticColors.dark()
        : AppSemanticColors.light();
    final baseTextTheme = isDark
        ? ThemeData.dark().textTheme
        : ThemeData.light().textTheme;
    final textTheme = _textTheme(
      baseTextTheme.apply(
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      canvasColor: colorScheme.surface,
      textTheme: textTheme,
      extensions: [semantic],
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: false,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: colorScheme.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainerLowest,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMd),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderSm),
        side: BorderSide.none,
        labelStyle: textTheme.labelLarge,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? colorScheme.surfaceContainerHigh
            : colorScheme.surfaceContainerLowest,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.borderSm,
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderSm,
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderSm,
          borderSide: BorderSide(color: colorScheme.primary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderSm,
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderSm,
          borderSide: BorderSide(color: colorScheme.error, width: 1.6),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderSm),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surfaceContainerLowest,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderLg),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surfaceContainerLowest,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.lg),
          ),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        space: 1,
        thickness: 1,
      ),
      navigationDrawerTheme: NavigationDrawerThemeData(
        backgroundColor: colorScheme.surfaceContainerLowest,
        indicatorColor: colorScheme.primary.withValues(alpha: 0.12),
        indicatorShape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderSm,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.borderSm),
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.borderSm),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(48, 40),
          foregroundColor: colorScheme.primary,
        ),
      ),
    );
  }

  static const ColorScheme _lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppBrandColors.primary,
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFD6E6FF),
    onPrimaryContainer: Color(0xFF062A63),
    secondary: AppBrandColors.secondary,
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFC5F4F4),
    onSecondaryContainer: Color(0xFF003838),
    tertiary: AppBrandColors.accent,
    onTertiary: Color(0xFF2A2100),
    tertiaryContainer: Color(0xFFFFE9A8),
    onTertiaryContainer: Color(0xFF3D2E00),
    error: AppBrandColors.error,
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),
    surface: Color(0xFFF5F7FB),
    onSurface: Color(0xFF1B1F24),
    onSurfaceVariant: Color(0xFF4A5563),
    outline: Color(0xFFCBD2DC),
    outlineVariant: Color(0xFFE3E8EF),
    surfaceContainerLowest: Color(0xFFFFFFFF),
    surfaceContainerLow: Color(0xFFEEF2F7),
    surfaceContainer: Color(0xFFFFFFFF),
    surfaceContainerHigh: Color(0xFFE8EDF4),
    surfaceContainerHighest: Color(0xFFE2E8F0),
    inverseSurface: Color(0xFF2C333C),
    onInverseSurface: Color(0xFFF0F3F8),
    inversePrimary: Color(0xFF9DC2FF),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
  );

  static const ColorScheme _darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF7AB4FF),
    onPrimary: Color(0xFF002F6C),
    primaryContainer: Color(0xFF0B5ED7),
    onPrimaryContainer: Color(0xFFE8F1FF),
    secondary: Color(0xFF5EE0E0),
    onSecondary: Color(0xFF003838),
    secondaryContainer: Color(0xFF007A7A),
    onSecondaryContainer: Color(0xFFD7FFFF),
    tertiary: Color(0xFFF5C84D),
    onTertiary: Color(0xFF2A2100),
    tertiaryContainer: Color(0xFF8A6A00),
    onTertiaryContainer: Color(0xFFFFF1C2),
    error: Color(0xFFFF8A80),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    surface: Color(0xFF10151C),
    onSurface: Color(0xFFE8EEF4),
    onSurfaceVariant: Color(0xFFB4BCC8),
    outline: Color(0xFF3E4A58),
    outlineVariant: Color(0xFF2A3340),
    surfaceContainerLowest: Color(0xFF161D26),
    surfaceContainerLow: Color(0xFF1B232D),
    surfaceContainer: Color(0xFF1E2732),
    surfaceContainerHigh: Color(0xFF24303C),
    surfaceContainerHighest: Color(0xFF2C3A48),
    inverseSurface: Color(0xFFE8EEF4),
    onInverseSurface: Color(0xFF1B1F24),
    inversePrimary: Color(0xFF0B5ED7),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
  );

  static TextTheme _textTheme(TextTheme base) {
    if (!GoogleFonts.config.allowRuntimeFetching) {
      return base;
    }
    return GoogleFonts.interTextTheme(base);
  }
}

/// Soft card elevation that stays readable in both themes.
List<BoxShadow> appCardShadow(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return [
    BoxShadow(
      color: Colors.black.withValues(alpha: isDark ? 0.28 : 0.05),
      blurRadius: 18,
      offset: const Offset(0, 6),
    ),
  ];
}
