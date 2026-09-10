import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_constants.dart';
import '../shared/providers/theme_mode_provider.dart';
import '../shared/widgets/layout/app_page_background.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class ElectricityBoardApp extends ConsumerWidget {
  const ElectricityBoardApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      routerConfig: router,
      builder: (context, child) {
        return AppPageBackground(child: child ?? const SizedBox.shrink());
      },
    );
  }
}
