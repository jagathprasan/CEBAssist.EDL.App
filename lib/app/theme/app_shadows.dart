import 'package:flutter/material.dart';

/// Soft, diffused elevation used by cards, dialogs, and floating bars.
class AppShadows {
  AppShadows._();

  static List<BoxShadow> none = const [];

  static List<BoxShadow> sm(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: const Color(0xFF2A3A55).withValues(alpha: dark ? 0.28 : 0.06),
        blurRadius: 16,
        offset: const Offset(0, 4),
      ),
    ];
  }

  static List<BoxShadow> md(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: const Color(0xFF2A3A55).withValues(alpha: dark ? 0.32 : 0.07),
        blurRadius: 28,
        offset: const Offset(0, 10),
        spreadRadius: -4,
      ),
    ];
  }

  static List<BoxShadow> lg(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return [
      BoxShadow(
        color: const Color(0xFF2A3A55).withValues(alpha: dark ? 0.4 : 0.1),
        blurRadius: 40,
        offset: const Offset(0, 16),
        spreadRadius: -6,
      ),
    ];
  }
}
