import 'package:flutter/material.dart';

import '../../../app/theme/app_theme.dart';

/// Full-screen soft gradient used by shells and auth screens.
class AppPageBackground extends StatelessWidget {
  const AppPageBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(gradient: AppSurfaces.pageGradient(context)),
      child: child,
    );
  }
}
