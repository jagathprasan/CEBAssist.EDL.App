import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_status_chip.dart';

class PlaceholderModuleScreen extends StatelessWidget {
  const PlaceholderModuleScreen({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  factory PlaceholderModuleScreen.forRoute(String route) {
    return switch (route) {
      AppRoutes.consumerServices => const PlaceholderModuleScreen(
        title: 'Consumer Services',
        description:
            'Search accounts, manage connections, and handle consumer requests from the field.',
        icon: Icons.people_outline,
      ),
      AppRoutes.meterManagement => const PlaceholderModuleScreen(
        title: 'Meter Management',
        description:
            'Track smart meter health, installations, and device commissioning workflows.',
        icon: Icons.speed_outlined,
      ),
      AppRoutes.billing => const PlaceholderModuleScreen(
        title: 'Billing',
        description:
            'Review bills, collections, and payment exceptions across area offices.',
        icon: Icons.receipt_long_outlined,
      ),
      AppRoutes.outageManagement => const PlaceholderModuleScreen(
        title: 'Outage Management',
        description:
            'Coordinate planned and unplanned outages with restoration crews in real time.',
        icon: Icons.power_off_outlined,
      ),
      AppRoutes.projects => const PlaceholderModuleScreen(
        title: 'Projects',
        description:
            'Monitor capital works, site progress, and engineering approvals.',
        icon: Icons.account_tree_outlined,
      ),
      AppRoutes.inventory => const PlaceholderModuleScreen(
        title: 'Inventory',
        description:
            'Request materials, track stores balances, and approve warehouse issues.',
        icon: Icons.inventory_2_outlined,
      ),
      _ => const PlaceholderModuleScreen(
        title: 'Reports',
        description:
            'Generate operational, commercial, and engineering reports for management review.',
        icon: Icons.bar_chart_outlined,
      ),
    };
  }

  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: context.colors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: context.colors.primary),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              textAlign: TextAlign.center,
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              description,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            const AppStatusChip(label: 'Coming Soon', tone: AppStatusTone.info),
            const Spacer(),
            TextButton(
              onPressed: () => context.go(AppRoutes.dashboard),
              child: const Text('Back to dashboard'),
            ),
          ],
        ),
      ),
    );
  }
}
