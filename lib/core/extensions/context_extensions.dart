import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

/// Convenience accessors for theme tokens.
extension ThemeContextX on BuildContext {
  ThemeData get theme => Theme.of(this);

  ColorScheme get colors => Theme.of(this).colorScheme;

  TextTheme get textTheme => Theme.of(this).textTheme;

  AppSemanticColors get semantic {
    return Theme.of(this).extension<AppSemanticColors>() ??
        AppSemanticColors.light();
  }

  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  MediaQueryData get media => MediaQuery.of(this);
}

extension StringX on String {
  String get initials {
    final parts = trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    if (parts.isEmpty) return '?';
    final letters = parts.take(2).map((p) => p[0].toUpperCase());
    return letters.join();
  }
}
