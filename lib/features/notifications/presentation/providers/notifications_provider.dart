import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../authentication/presentation/providers/auth_provider.dart';
import '../../data/mock_notification_repository.dart';
import '../../domain/notification_models.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return MockNotificationRepository(
    delay: ref.watch(simulatedNetworkDelayProvider),
  );
});

class NotificationsNotifier extends AsyncNotifier<List<AppNotification>> {
  @override
  Future<List<AppNotification>> build() {
    return ref.read(notificationRepositoryProvider).fetchNotifications();
  }

  Future<void> markAsRead(String id) async {
    final current = state.value;
    if (current == null) return;
    state = AsyncData([
      for (final item in current)
        if (item.id == id) item.copyWith(isRead: true) else item,
    ]);
  }

  Future<void> markAllAsRead() async {
    final current = state.value;
    if (current == null) return;
    state = AsyncData([
      for (final item in current) item.copyWith(isRead: true),
    ]);
  }
}

final notificationsProvider =
    AsyncNotifierProvider<NotificationsNotifier, List<AppNotification>>(
      NotificationsNotifier.new,
    );

final unreadNotificationCountProvider = Provider<int>((ref) {
  final notifications = ref.watch(notificationsProvider).valueOrNull ?? [];
  return notifications.where((item) => !item.isRead).length;
});
