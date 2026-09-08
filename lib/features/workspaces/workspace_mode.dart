import 'package:flutter/material.dart';

import '../../app/theme/app_design_tokens.dart';
import '../../app/theme/app_ui_mode.dart';

export '../../app/theme/app_ui_mode.dart';

/// Workspace density. Alias of [AppUiMode] so existing screens keep compiling.
typedef WorkspaceMode = AppUiMode;

class WorkspaceMetrics {
  const WorkspaceMetrics(this.mode);

  final AppUiMode mode;

  bool get isField => mode.isField;

  double get titleSize => tokens.titleSize;
  double get subtitleSize => tokens.subtitleSize;
  double get bodySize => tokens.bodySize;
  double get labelSize => tokens.labelSize;
  double get iconSize => tokens.iconSize;
  double get buttonHeight => tokens.buttonHeightMd;
  double get cardPadding => tokens.cardPadding;
  double get gap => tokens.gap;
  FontWeight get titleWeight => tokens.titleWeight;

  AppDesignTokens get tokens => AppDesignTokens.of(mode);
}

/// Lookup helpers for the inherited [AppUiModeScope].
class WorkspaceScope {
  const WorkspaceScope._();

  static AppUiMode of(BuildContext context) => AppUiModeScope.of(context);

  static WorkspaceMetrics metricsOf(BuildContext context) {
    return WorkspaceMetrics(AppUiModeScope.of(context));
  }
}
