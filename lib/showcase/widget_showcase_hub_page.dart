import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../app/router/app_routes.dart';
import '../app/theme/app_spacing.dart';
import '../shared/widgets/widgets.dart';

/// Debug hub to open Field and Office widget catalogs.
class WidgetShowcaseHubPage extends StatelessWidget {
  const WidgetShowcaseHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: AppSpacing.pagePadding,
      children: [
        const AppPageHeader(
          title: 'Compare Field and Office',
          subtitle:
              'Same components, forms, and sample work data. Only density and layout change.',
        ),
        AppActionCard(
          icon: Icons.wb_sunny_outlined,
          title: 'View Field UI',
          description: 'Large targets for outdoor crew work',
          actionLabel: 'Open Field',
          onAction: () => context.push(AppRoutes.fieldWidgetShowcase),
        ),
        const SizedBox(height: AppSpacing.md),
        AppActionCard(
          icon: Icons.desktop_windows_outlined,
          title: 'View Office UI',
          description: 'Compact desk operations and denser data',
          actionLabel: 'Open Office',
          onAction: () => context.push(AppRoutes.officeWidgetShowcase),
        ),
      ],
    );
  }
}
