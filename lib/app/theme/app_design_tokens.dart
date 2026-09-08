import 'package:flutter/material.dart';

import 'app_sizes.dart';
import 'app_spacing.dart';
import 'app_ui_mode.dart';

/// Mode-specific sizing used by shared widgets. Colours stay on [ColorScheme].
abstract class AppDesignTokens {
  const AppDesignTokens();

  AppUiMode get mode;
  bool get isField => mode == AppUiMode.field;

  double get titleSize;
  double get subtitleSize;
  double get bodySize;
  double get labelSize;
  FontWeight get titleWeight;

  double get iconSize;
  double get actionIconSize;
  double get buttonIconSize;

  double get buttonHeightSm;
  double get buttonHeightMd;
  double get buttonHeightLg;
  double get touchTarget;

  double get fieldPaddingH;
  double get fieldPaddingV;
  double get cardPadding;
  double get gap;
  double get sectionGap;

  double get actionTileAspect;
  int get formColumns;

  double get radius;

  factory AppDesignTokens.of(AppUiMode mode) {
    return mode.isField
        ? const FieldDesignTokens()
        : const OfficeDesignTokens();
  }

  factory AppDesignTokens.ofContext(BuildContext context) {
    return AppDesignTokens.of(resolveAppUiMode(context));
  }

  double buttonHeightFor(AppButtonSizeToken size) => switch (size) {
    AppButtonSizeToken.sm => buttonHeightSm,
    AppButtonSizeToken.md => buttonHeightMd,
    AppButtonSizeToken.lg => buttonHeightLg,
  };
}

enum AppButtonSizeToken { sm, md, lg }

/// Outdoor / sunlight-friendly scale: large type, tall targets, one column.
class FieldDesignTokens extends AppDesignTokens {
  const FieldDesignTokens();

  @override
  AppUiMode get mode => AppUiMode.field;

  @override
  double get titleSize => 30;
  @override
  double get subtitleSize => 18;
  @override
  double get bodySize => 20;
  @override
  double get labelSize => 16;
  @override
  FontWeight get titleWeight => FontWeight.w800;

  @override
  double get iconSize => 40;
  @override
  double get actionIconSize => 56;
  @override
  double get buttonIconSize => 28;

  @override
  double get buttonHeightSm => 56;
  @override
  double get buttonHeightMd => 64;
  @override
  double get buttonHeightLg => 72;
  @override
  double get touchTarget => 56;

  @override
  double get fieldPaddingH => AppSpacing.lg;
  @override
  double get fieldPaddingV => 20;
  @override
  double get cardPadding => AppSpacing.lg;
  @override
  double get gap => AppSpacing.md;
  @override
  double get sectionGap => AppSpacing.xl;

  @override
  double get actionTileAspect => 1.0;
  @override
  int get formColumns => 1;
  @override
  double get radius => AppRadius.md;
}

/// Desk-side scale: denser type, compact controls, two columns when wide.
class OfficeDesignTokens extends AppDesignTokens {
  const OfficeDesignTokens();

  @override
  AppUiMode get mode => AppUiMode.office;

  @override
  double get titleSize => 20;
  @override
  double get subtitleSize => 14;
  @override
  double get bodySize => 14;
  @override
  double get labelSize => 12;
  @override
  FontWeight get titleWeight => FontWeight.w700;

  @override
  double get iconSize => AppSizes.iconMd;
  @override
  double get actionIconSize => AppSizes.iconLg;
  @override
  double get buttonIconSize => AppSizes.iconSm;

  @override
  double get buttonHeightSm => AppSizes.buttonHeightSm;
  @override
  double get buttonHeightMd => AppSizes.buttonHeightMd;
  @override
  double get buttonHeightLg => AppSizes.buttonHeightLg;
  @override
  double get touchTarget => AppSizes.touchTarget;

  @override
  double get fieldPaddingH => AppSpacing.md;
  @override
  double get fieldPaddingV => AppSpacing.md;
  @override
  double get cardPadding => AppSpacing.md;
  @override
  double get gap => AppSpacing.sm;
  @override
  double get sectionGap => AppSpacing.lg;

  @override
  double get actionTileAspect => 1.45;
  @override
  int get formColumns => 2;
  @override
  double get radius => AppRadius.sm;
}
