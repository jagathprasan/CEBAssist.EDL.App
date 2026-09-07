enum NotificationType { outage, billing, meter, inventory, system }

class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.type,
    required this.isRead,
  });

  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final NotificationType type;
  final bool isRead;

  AppNotification copyWith({bool? isRead}) {
    return AppNotification(
      id: id,
      title: title,
      description: description,
      createdAt: createdAt,
      type: type,
      isRead: isRead ?? this.isRead,
    );
  }
}

/// Contract for notification feeds. Swap with a REST implementation later.
abstract class NotificationRepository {
  Future<List<AppNotification>> fetchNotifications();
}
