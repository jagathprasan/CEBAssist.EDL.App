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
    final pill = const RoundedRectangleBorder(
      borderRadius: AppRadius.borderPill,
    );
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
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
          color: colorScheme.onSurface,
        ),
        iconTheme: IconThemeData(color: colorScheme.onSurface, size: 24),
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainerLowest,
        elevation: 0,
        margin: EdgeInsets.zero,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderLg),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: colorScheme.onSurfaceVariant,
        titleTextStyle: textTheme.titleSmall,
        subtitleTextStyle: textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderSm),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderPill),
        side: BorderSide.none,
        selectedColor: colorScheme.primaryContainer,
        backgroundColor: colorScheme.surfaceContainerHighest,
        checkmarkColor: colorScheme.primary,
        labelStyle: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
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
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w400,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.borderMd,
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderMd,
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderMd,
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderMd,
          borderSide: BorderSide(color: colorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderMd,
          borderSide: BorderSide(color: colorScheme.error, width: 1.5),
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
      navigationBarTheme: NavigationBarThemeData(
        height: 68,
        elevation: 0,
        backgroundColor: colorScheme.surfaceContainerLowest,
        indicatorColor: colorScheme.primary.withValues(alpha: 0.12),
        labelTextStyle: WidgetStatePropertyAll(
          textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      tabBarTheme: TabBarThemeData(
        dividerColor: Colors.transparent,
        labelStyle: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        unselectedLabelStyle: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w500,
          color: colorScheme.onSurfaceVariant,
        ),
        indicatorSize: TabBarIndicatorSize.label,
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: colorScheme.surfaceContainerLowest,
        elevation: 0,
        shape: const RoundedRectangleBorder(),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          elevation: 0,
          shape: pill,
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 48),
          shape: pill,
          side: BorderSide(color: colorScheme.outline),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(48, 40),
          foregroundColor: colorScheme.primary,
          shape: pill,
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
    primaryContainer: Color(0xFFD5EAF4),
    onPrimaryContainer: Color(0xFF0A3A52),
    secondary: AppBrandColors.secondary,
    onSecondary: Color(0xFFFFFFFF),
    secondaryContainer: Color(0xFFD2E4EE),
    onSecondaryContainer: Color(0xFF06293C),
    tertiary: AppBrandColors.accent,
    onTertiary: Color(0xFFFFFFFF),
    tertiaryContainer: Color(0xFFFFE0D2),
    onTertiaryContainer: Color(0xFF5A1C00),
    error: AppBrandColors.error,
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFFE4E2),
    onErrorContainer: Color(0xFF410002),
    surface: Color(0xFFF4F6F8),
    onSurface: Color(0xFF111827),
    onSurfaceVariant: Color(0xFF6B7280),
    outline: Color(0xFFE5E7EB),
    outlineVariant: Color(0xFFF0F2F5),
    surfaceContainerLowest: Color(0xFFFFFFFF),
    surfaceContainerLow: Color(0xFFF7F8FA),
    surfaceContainer: Color(0xFFFFFFFF),
    surfaceContainerHigh: Color(0xFFF1F3F6),
    surfaceContainerHighest: Color(0xFFE8EAEE),
    inverseSurface: Color(0xFF2C333C),
    onInverseSurface: Color(0xFFF0F3F8),
    inversePrimary: Color(0xFF5BAAD4),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
  );

  static const ColorScheme _darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF5BAAD4),
    onPrimary: Color(0xFF06293C),
    primaryContainer: Color(0xFF164E6E),
    onPrimaryContainer: Color(0xFFD5EAF4),
    secondary: Color(0xFF8FCBE4),
    onSecondary: Color(0xFF06293C),
    secondaryContainer: Color(0xFF1B5E82),
    onSecondaryContainer: Color(0xFFD2E4EE),
    tertiary: Color(0xFFFF8A4A),
    onTertiary: Color(0xFF3A1400),
    tertiaryContainer: Color(0xFF8A3200),
    onTertiaryContainer: Color(0xFFFFE0D2),
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
    inversePrimary: Color(0xFF1B7EB5),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),
  );

  static TextTheme _textTheme(TextTheme base) {
    final themed = GoogleFonts.config.allowRuntimeFetching
        ? GoogleFonts.interTextTheme(base)
        : base;
    return themed.copyWith(
      displayLarge: _face(
        themed.displayLarge,
        size: 36,
        weight: FontWeight.w700,
        spacing: -1.1,
        height: 1.08,
      ),
      displayMedium: _face(
        themed.displayMedium,
        size: 32,
        weight: FontWeight.w700,
        spacing: -0.9,
        height: 1.1,
      ),
      displaySmall: _face(
        themed.displaySmall,
        size: 28,
        weight: FontWeight.w700,
        spacing: -0.7,
        height: 1.12,
      ),
      headlineLarge: _face(
        themed.headlineLarge,
        size: 24,
        weight: FontWeight.w700,
        spacing: -0.45,
        height: 1.2,
      ),
      headlineMedium: _face(
        themed.headlineMedium,
        size: 22,
        weight: FontWeight.w700,
        spacing: -0.4,
        height: 1.2,
      ),
      headlineSmall: _face(
        themed.headlineSmall,
        size: 20,
        weight: FontWeight.w600,
        spacing: -0.3,
        height: 1.25,
      ),
      titleLarge: _face(
        themed.titleLarge,
        size: 18,
        weight: FontWeight.w600,
        spacing: -0.25,
        height: 1.3,
      ),
      titleMedium: _face(
        themed.titleMedium,
        size: 16,
        weight: FontWeight.w600,
        spacing: -0.15,
        height: 1.35,
      ),
      titleSmall: _face(
        themed.titleSmall,
        size: 14,
        weight: FontWeight.w600,
        height: 1.35,
      ),
      bodyLarge: _face(
        themed.bodyLarge,
        size: 16,
        weight: FontWeight.w400,
        height: 1.5,
      ),
      bodyMedium: _face(
        themed.bodyMedium,
        size: 14,
        weight: FontWeight.w400,
        height: 1.45,
      ),
      bodySmall: _face(
        themed.bodySmall,
        size: 13,
        weight: FontWeight.w400,
        height: 1.4,
      ),
      labelLarge: _face(
        themed.labelLarge,
        size: 14,
        weight: FontWeight.w500,
        height: 1.3,
      ),
      labelMedium: _face(
        themed.labelMedium,
        size: 12,
        weight: FontWeight.w500,
        height: 1.3,
      ),
      labelSmall: _face(
        themed.labelSmall,
        size: 11,
        weight: FontWeight.w500,
        height: 1.25,
      ),
    );
  }

  static TextStyle? _face(
    TextStyle? style, {
    required double size,
    required FontWeight weight,
    double spacing = 0,
    required double height,
  }) {
    return style?.copyWith(
      fontSize: size,
      fontWeight: weight,
      letterSpacing: spacing,
      height: height,
    );
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
        colors: [Color(0xFF0E1820), Color(0xFF10141C)],
      );
    }
    return const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFFFFFFF), Color(0xFFF6F7F8)],
    );
  }

  /// Soft EstateHub card: white fill, large radius, light shadow, no hard border.
  static BoxDecoration card(
    BuildContext context, {
    Color? color,
    bool elevated = true,
    BorderRadius radius = AppRadius.borderXl,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final dark = scheme.brightness == Brightness.dark;
    return BoxDecoration(
      color: color ?? scheme.surfaceContainerLowest,
      borderRadius: radius,
      border: dark
          ? Border.all(color: scheme.outlineVariant.withValues(alpha: 0.7))
          : null,
      boxShadow: elevated
          ? [
              BoxShadow(
                color: const Color(
                  0xFF1B3A4B,
                ).withValues(alpha: dark ? 0.28 : 0.07),
                blurRadius: 28,
                offset: const Offset(0, 12),
                spreadRadius: -8,
              ),
            ]
          : const [],
    );
  }
}

/// Soft card elevation that stays readable in both themes.
List<BoxShadow> appCardShadow(BuildContext context) => AppShadows.sm(context);
