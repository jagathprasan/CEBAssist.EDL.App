import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import 'app_drawer.dart';
import 'app_main_bar.dart';

/// Shared authenticated layout used by all ERP modules.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  static const _titles = {
    AppRoutes.dashboard: 'Dashboard',
    AppRoutes.officeWorkspace: 'Office Workspace',
    AppRoutes.fieldWorkspace: 'Field Workspace',
    AppRoutes.notifications: 'Notifications',
    AppRoutes.profile: 'Profile',
    AppRoutes.settings: 'Settings',
    AppRoutes.consumerServices: 'Consumer Services',
    AppRoutes.meterManagement: 'Meter Management',
    AppRoutes.billing: 'Billing',
    AppRoutes.outageManagement: 'Outage Management',
    AppRoutes.projects: 'Projects',
    AppRoutes.inventory: 'Inventory',
    AppRoutes.reports: 'Reports',
  };

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final title = _titles[location] ?? 'CEBAssist';

    // Phone-first drawer layout. A navigation rail can replace the drawer
    // here when tablet support is added (breakpoint around 1024px).
    return Scaffold(
      appBar: AppMainBar(title: title),
      drawer: AppDrawer(currentLocation: location),
      body: child,
    );
  }
}
