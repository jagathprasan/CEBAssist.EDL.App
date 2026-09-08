import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/widgets/app_user_avatar.dart';
import '../../../shared/providers/user_provider.dart';
import '../../notifications/presentation/providers/notifications_provider.dart';

class AppMainBar extends ConsumerWidget implements PreferredSizeWidget {
  const AppMainBar({super.key, required this.title});

  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unread = ref.watch(unreadNotificationCountProvider);
    final user = ref.watch(currentUserProvider);

    return AppBar(
      titleSpacing: 0,
      title: Text(title),
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
}
