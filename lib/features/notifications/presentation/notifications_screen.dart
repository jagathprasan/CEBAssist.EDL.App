import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/extensions/date_extensions.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_error_state.dart';
import '../../../core/widgets/app_loading_skeleton.dart';
import '../../../core/widgets/app_status_chip.dart';
import '../domain/notification_models.dart';
import 'providers/notifications_provider.dart';

enum _NotificationFilter { all, unread }

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  _NotificationFilter _filter = _NotificationFilter.all;

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(notificationsProvider);
    return async.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            AppLoadingSkeleton(height: 72),
            SizedBox(height: AppSpacing.sm),
            AppLoadingSkeleton(height: 72),
            SizedBox(height: AppSpacing.sm),
            AppLoadingSkeleton(height: 72),
          ],
        ),
      ),
      error: (_, _) => AppErrorState(
        message: 'Notifications could not be loaded.',
        onRetry: () => ref.invalidate(notificationsProvider),
      ),
      data: (items) {
        final visible = _filter == _NotificationFilter.unread
            ? items.where((item) => !item.isRead).toList()
            : items;
        final unreadCount = items.where((item) => !item.isRead).length;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.xs,
              ),
              child: Row(
                children: [
                  ChoiceChip(
                    label: const Text('All'),
                    selected: _filter == _NotificationFilter.all,
                    onSelected: (_) {
                      setState(() => _filter = _NotificationFilter.all);
                    },
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  ChoiceChip(
                    label: Text('Unread ($unreadCount)'),
                    selected: _filter == _NotificationFilter.unread,
                    onSelected: (_) {
                      setState(() => _filter = _NotificationFilter.unread);
                    },
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: unreadCount == 0
                        ? null
                        : () => ref
                              .read(notificationsProvider.notifier)
                              .markAllAsRead(),
                    child: const Text('Mark all as read'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: visible.isEmpty
                  ? AppEmptyState(
                      title: _filter == _NotificationFilter.unread
                          ? 'You are all caught up'
                          : 'No notifications yet',
                      message: _filter == _NotificationFilter.unread
                          ? 'There are no unread operational alerts.'
                          : 'New alerts from outages, meters, and billing will appear here.',
                      icon: Icons.notifications_none_outlined,
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.md,
                        AppSpacing.sm,
                        AppSpacing.md,
                        AppSpacing.xl,
                      ),
                      itemCount: visible.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, index) {
                        final item = visible[index];
                        return _NotificationTile(
                          notification: item,
                          onMarkRead: () => ref
                              .read(notificationsProvider.notifier)
                              .markAsRead(item.id),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.notification,
    required this.onMarkRead,
  });

  final AppNotification notification;
  final VoidCallback onMarkRead;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: notification.isRead
          ? context.colors.surfaceContainerLowest
          : context.semantic.infoContainer.withValues(alpha: 0.45),
      borderRadius: AppRadius.borderMd,
      child: InkWell(
        onTap: notification.isRead ? null : onMarkRead,
        borderRadius: AppRadius.borderMd,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  color: context.colors.surfaceContainerHigh,
                  borderRadius: AppRadius.borderSm,
                ),
                child: Icon(
                  _icon(notification.type),
                  color: context.colors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: context.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: context.colors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.description,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        Text(
                          '${notification.createdAt.shortDate} · ${notification.createdAt.timeOfDay}',
                          style: context.textTheme.labelSmall?.copyWith(
                            color: context.colors.onSurfaceVariant,
                          ),
                        ),
                        const Spacer(),
                        if (!notification.isRead)
                          AppStatusChip(
                            label: 'Mark as read',
                            tone: AppStatusTone.info,
                            compact: true,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _icon(NotificationType type) {
    return switch (type) {
      NotificationType.outage => Icons.power_off_outlined,
      NotificationType.billing => Icons.receipt_long_outlined,
      NotificationType.meter => Icons.speed_outlined,
      NotificationType.inventory => Icons.inventory_2_outlined,
      NotificationType.system => Icons.security_outlined,
    };
  }
}
