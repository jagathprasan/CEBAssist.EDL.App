import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/app_user_avatar.dart';
import '../../../shared/providers/user_provider.dart';
import '../../../shared/widgets/widgets.dart';
import '../../notifications/presentation/providers/notifications_provider.dart';

class AppMainBar extends ConsumerWidget implements PreferredSizeWidget {
  const AppMainBar({super.key, required this.title, required this.location});

  final String title;
  final String location;

  static const _crumbHeight = 28.0;

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight + _crumbHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unread = ref.watch(unreadNotificationCountProvider);
    final user = ref.watch(currentUserProvider);
    final crumbs = _crumbsFor(location);

    return AppBar(
      titleSpacing: 0,
      title: Text(title),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(_crumbHeight),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              0,
              AppSpacing.md,
              AppSpacing.xs,
            ),
            child: AppBreadcrumb(compact: true, items: crumbs),
          ),
        ),
      ),
      actions: [
        IconButton(
          tooltip: 'Notifications',
          onPressed: () => context.go(AppRoutes.notifications),
          icon: Badge(
            isLabelVisible: unread > 0,
            label: Text('$unread'),
            child: const Icon(Icons.notifications_outlined),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: AppSpacing.md, left: 4),
          child: AppUserAvatar(
            name: user.fullName,
            imageUrl: user.avatarUrl,
            radius: 16,
            onTap: () => context.go(AppRoutes.profile),
          ),
        ),
      ],
    );
  }

  List<AppBreadcrumbItem> _crumbsFor(String location) {
    return switch (location) {
      AppRoutes.dashboard => const [
        AppBreadcrumbItem(label: 'Home'),
        AppBreadcrumbItem(label: 'Dashboard'),
      ],
      AppRoutes.officeWorkspace => const [
        AppBreadcrumbItem(label: 'Workspaces'),
        AppBreadcrumbItem(label: 'Office'),
      ],
      AppRoutes.fieldWorkspace => const [
        AppBreadcrumbItem(label: 'Workspaces'),
        AppBreadcrumbItem(label: 'Field'),
      ],
      AppRoutes.profile => const [
        AppBreadcrumbItem(label: 'My Account'),
        AppBreadcrumbItem(label: 'Profile'),
      ],
      AppRoutes.settings => const [
        AppBreadcrumbItem(label: 'My Account'),
        AppBreadcrumbItem(label: 'Settings'),
      ],
      AppRoutes.notifications => const [
        AppBreadcrumbItem(label: 'Home'),
        AppBreadcrumbItem(label: 'Notifications'),
      ],
      _ => [
        const AppBreadcrumbItem(label: 'Home'),
        AppBreadcrumbItem(label: title),
      ],
    };
  }
}
