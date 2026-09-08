import 'package:flutter/material.dart';

import 'app_design_tokens.dart';

/// Visual language for outdoor crew work vs desk operations.
enum AppUiMode { field, office }

extension AppUiModeX on AppUiMode {
  bool get isField => this == AppUiMode.field;
  bool get isOffice => this == AppUiMode.office;

  String get label => isField ? 'Field' : 'Office';
}

/// Provides [AppUiMode] to the subtree so shared widgets can size themselves.
class AppUiModeScope extends InheritedWidget {
  const AppUiModeScope({super.key, required this.mode, required super.child});

  final AppUiMode mode;

  static AppUiMode of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppUiModeScope>()?.mode ??
        AppUiMode.office;
  }

  static AppUiMode? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppUiModeScope>()?.mode;
  }

  static AppDesignTokens tokensOf(BuildContext context) {
    return AppDesignTokens.of(of(context));
  }

  @override
  bool updateShouldNotify(AppUiModeScope oldWidget) => mode != oldWidget.mode;
}

/// Resolves an explicit [mode] override, then inherited scope, then office.
AppUiMode resolveAppUiMode(BuildContext context, [AppUiMode? mode]) {
  return mode ?? AppUiModeScope.maybeOf(context) ?? AppUiMode.office;
}
