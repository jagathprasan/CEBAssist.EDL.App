import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_confirmation_dialog.dart';
import '../../../core/widgets/app_logo.dart';
import '../../../core/widgets/app_user_avatar.dart';
import '../../../shared/providers/user_provider.dart';
import '../../authentication/presentation/providers/auth_provider.dart';

class DrawerDestination {
  const DrawerDestination({
    required this.route,
    required this.label,
    required this.icon,
  });

  final String route;
  final String label;
  final IconData icon;
}

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key, required this.currentLocation});

  final String currentLocation;

  static const List<DrawerDestination> primaryItems = [
    DrawerDestination(
      route: AppRoutes.dashboard,
      label: 'Dashboard',
      icon: Icons.dashboard_outlined,
    ),
    DrawerDestination(
      route: AppRoutes.consumerServices,
      label: 'Consumer Services',
      icon: Icons.people_outline,
    ),
    DrawerDestination(
      route: AppRoutes.meterManagement,
      label: 'Meter Management',
      icon: Icons.speed_outlined,
    ),
    DrawerDestination(
      route: AppRoutes.billing,
      label: 'Billing',
      icon: Icons.receipt_long_outlined,
    ),
    DrawerDestination(
      route: AppRoutes.outageManagement,
      label: 'Outage Management',
      icon: Icons.power_off_outlined,
    ),
    DrawerDestination(
      route: AppRoutes.projects,
      label: 'Projects',
      icon: Icons.account_tree_outlined,
    ),
    DrawerDestination(
      route: AppRoutes.inventory,
      label: 'Inventory',
      icon: Icons.inventory_2_outlined,
    ),
    DrawerDestination(
      route: AppRoutes.reports,
      label: 'Reports',
      icon: Icons.bar_chart_outlined,
    ),
  ];

  static const List<DrawerDestination> accountItems = [
    DrawerDestination(
      route: AppRoutes.notifications,
      label: 'Notifications',
      icon: Icons.notifications_outlined,
    ),
    DrawerDestination(
      route: AppRoutes.profile,
      label: 'Profile',
      icon: Icons.person_outline,
    ),
    DrawerDestination(
      route: AppRoutes.settings,
      label: 'Settings',
      icon: Icons.settings_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.sm,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppLogo(height: 32, style: AppLogoStyle.full),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      AppUserAvatar(name: user.fullName, radius: 24),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.fullName,
                              style: context.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              user.designation,
                              style: context.textTheme.bodySmall?.copyWith(
                                color: context.colors.onSurfaceVariant,
                              ),
                            ),
                            Text(
                              'Employee ID ${user.employeeId}',
                              style: context.textTheme.labelSmall?.copyWith(
                                color: context.colors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                children: [
                  ...primaryItems.map(
                    (item) => _DrawerTile(
                      destination: item,
                      selected: currentLocation == item.route,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs,
                    ),
                    child: Divider(),
                  ),
                  ...accountItems.map(
                    (item) => _DrawerTile(
                      destination: item,
                      selected: currentLocation == item.route,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.logout_rounded, color: context.colors.error),
              title: Text(
                'Logout',
                style: TextStyle(
                  color: context.colors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () => _logout(context, ref),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Text(
                '${AppConstants.appName}  v${AppConstants.appVersion}',
                style: context.textTheme.labelSmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    Navigator.of(context).pop();
    final confirmed = await AppConfirmationDialog.show(
      context,
      title: 'Sign out?',
      message:
          'You will need to sign in again to access ${AppConstants.appName}.',
      confirmLabel: 'Logout',
      isDestructive: true,
    );
    if (!confirmed) return;
    await ref.read(authProvider.notifier).logout();
    if (context.mounted) {
      context.go(AppRoutes.login);
    }
  }
}

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({required this.destination, required this.selected});

  final DrawerDestination destination;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 2,
      ),
      child: ListTile(
        selected: selected,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderSm),
        leading: Icon(destination.icon),
        title: Text(
          destination.label,
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        selectedTileColor: context.colors.primary.withValues(alpha: 0.1),
        selectedColor: context.colors.primary,
        onTap: () {
          Navigator.of(context).pop();
          if (!selected) {
            context.go(destination.route);
          }
        },
      ),
    );
  }
}
