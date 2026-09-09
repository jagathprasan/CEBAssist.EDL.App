import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_shadows.dart';
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
    final rounded = RoundedRectangleBorder(borderRadius: AppRadius.borderSm);
    final sheet = RoundedRectangleBorder(borderRadius: AppRadius.borderLg);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: Colors.transparent,
      canvasColor: colorScheme.surface,
      textTheme: textTheme,
      extensions: [semantic],
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w800,
          color: colorScheme.onSurface,
        ),
        iconTheme: IconThemeData(color: colorScheme.onSurface, size: 24),
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainerLowest,
        elevation: 0,
        margin: EdgeInsets.zero,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMd),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderPill),
        side: BorderSide.none,
        selectedColor: colorScheme.primaryContainer,
        backgroundColor: colorScheme.surfaceContainerHighest,
        checkmarkColor: colorScheme.primary,
        labelStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
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
          borderSide: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.6),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderSm,
          borderSide: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.8),
          ),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: isDark
            ? colorScheme.surfaceContainerHighest
            : const Color(0xFF1B2330),
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMd),
        insetPadding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.lg,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surfaceContainerLowest,
        elevation: 0,
        insetPadding: const EdgeInsets.all(AppSpacing.lg),
        shape: sheet,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surfaceContainerLowest,
        elevation: 0,
        showDragHandle: true,
        dragHandleColor: colorScheme.outlineVariant,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.lg),
          ),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: colorScheme.surfaceContainerLowest,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMd),
      ),
      datePickerTheme: DatePickerThemeData(
        shape: sheet,
        headerBackgroundColor: colorScheme.primary,
        headerForegroundColor: colorScheme.onPrimary,
      ),
      timePickerTheme: TimePickerThemeData(shape: sheet),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant.withValues(alpha: 0.7),
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
          minimumSize: const Size.fromHeight(48),
          elevation: 0,
          shape: rounded,
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 48),
          shape: rounded,
          side: BorderSide(color: colorScheme.outline.withValues(alpha: 0.7)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(48, 40),
          foregroundColor: colorScheme.primary,
          shape: rounded,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMd),
        elevation: 2,
        highlightElevation: 4,
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(shape: const CircleBorder()),
      ),
    );
  }

  static const ColorScheme _lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppBrandColors.primary,
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFFE4EDFF),
    onPrimaryContainer: Color(0xFF10245A),
    secondary: AppBrandColors.secondary,
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFD8F6F6),
    onSecondaryContainer: Color(0xFF003838),
    tertiary: AppBrandColors.accent,
    onTertiary: Color(0xFF2A2100),
    tertiaryContainer: Color(0xFFFFEFC2),
    onTertiaryContainer: Color(0xFF3D2E00),
    error: AppBrandColors.error,
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFFE4E2),
    onErrorContainer: Color(0xFF410002),
    surface: Color(0xFFF4F6FA),
    onSurface: Color(0xFF1B1F27),
    onSurfaceVariant: Color(0xFF667085),
    outline: Color(0xFFD5DCE8),
    outlineVariant: Color(0xFFE8ECF3),
    surfaceContainerLowest: Color(0xFFFFFFFF),
    surfaceContainerLow: Color(0xFFF3F5FA),
    surfaceContainer: Color(0xFFFFFFFF),
    surfaceContainerHigh: Color(0xFFEEF1F8),
    surfaceContainerHighest: Color(0xFFE6EAF3),
    inverseSurface: Color(0xFF2C333C),
    onInverseSurface: Color(0xFFF0F3F8),
    inversePrimary: Color(0xFF9DC2FF),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
  );

  static const ColorScheme _darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF8FB4FF),
    onPrimary: Color(0xFF0A2458),
    primaryContainer: Color(0xFF2A4FA8),
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
    surface: Color(0xFF10141C),
    onSurface: Color(0xFFE8EEF4),
    onSurfaceVariant: Color(0xFFB4BCC8),
    outline: Color(0xFF3E4A58),
    outlineVariant: Color(0xFF2A3340),
    surfaceContainerLowest: Color(0xFF171C26),
    surfaceContainerLow: Color(0xFF1B232D),
    surfaceContainer: Color(0xFF1E2732),
    surfaceContainerHigh: Color(0xFF24303C),
    surfaceContainerHighest: Color(0xFF2C3A48),
    inverseSurface: Color(0xFFE8EEF4),
    onInverseSurface: Color(0xFF1B1F24),
    inversePrimary: Color(0xFF3B6FF5),
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

/// Soft page wash used behind cards and the app bar.
class AppSurfaces {
  AppSurfaces._();

  static LinearGradient pageGradient(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    if (dark) {
      return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF10141C), Color(0xFF15101A)],
      );
    }
    return const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFF4F6FA), Color(0xFFF4F6FA)],
    );
  }
}

/// Soft card elevation that stays readable in both themes.
List<BoxShadow> appCardShadow(BuildContext context) => AppShadows.md(context);
