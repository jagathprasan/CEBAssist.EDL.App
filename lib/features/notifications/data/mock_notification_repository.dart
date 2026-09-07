import '../domain/notification_models.dart';

class MockNotificationRepository implements NotificationRepository {
  const MockNotificationRepository({
    this.delay = const Duration(milliseconds: 250),
  });

  final Duration delay;

  @override
  Future<List<AppNotification>> fetchNotifications() async {
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }
    final now = DateTime.now();
    return [
      AppNotification(
        id: 'n-1',
        title: 'Unplanned outage in Kandy South',
        description:
            'Feeder KS-14 reported a trip at 08:12. Restoration crews are on site.',
        createdAt: now.subtract(const Duration(minutes: 22)),
        type: NotificationType.outage,
        isRead: false,
      ),
      AppNotification(
        id: 'n-2',
        title: 'Smart meters offline threshold exceeded',
        description:
            '27 meters in Area Office Kandy have been offline for more than 24 hours.',
        createdAt: now.subtract(const Duration(hours: 1, minutes: 5)),
        type: NotificationType.meter,
        isRead: false,
      ),
      AppNotification(
        id: 'n-3',
        title: 'Monthly collection behind target',
        description:
            'Area collection is at 86.4% of the LKR 12.5 B monthly target.',
        createdAt: now.subtract(const Duration(hours: 3)),
        type: NotificationType.billing,
        isRead: false,
      ),
      AppNotification(
        id: 'n-4',
        title: 'Inventory approval waiting',
        description:
            'Transformer spare request INV-8841 needs your approval before 17:00.',
        createdAt: now.subtract(const Duration(hours: 5, minutes: 20)),
        type: NotificationType.inventory,
        isRead: true,
      ),
      AppNotification(
        id: 'n-5',
        title: 'Planned shutdown confirmed',
        description:
            'Scheduled maintenance on feeder KN-03 will run tonight from 22:00 to 02:00.',
        createdAt: now.subtract(const Duration(days: 1, hours: 2)),
        type: NotificationType.outage,
        isRead: true,
      ),
      AppNotification(
        id: 'n-6',
        title: 'Password policy reminder',
        description:
            'Update your CEBAssist password within 12 days to remain compliant.',
        createdAt: now.subtract(const Duration(days: 2)),
        type: NotificationType.system,
        isRead: true,
      ),
    ];
  }
}
