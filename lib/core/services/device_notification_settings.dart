import 'package:permission_handler/permission_handler.dart';

/// Device notification permission for iOS, Android, and Huawei (Android).
///
/// The operating system does not let an app turn its own alerts off.
/// Turning them off opens the system notification screen instead.
class DeviceNotificationSettings {
  DeviceNotificationSettings._();

  static Future<bool> isEnabled() async {
    final status = await Permission.notification.status;
    return status.isGranted || status.isLimited || status.isProvisional;
  }

  /// Returns true when the system notification screen was opened.
  static Future<bool> apply(bool enabled) async {
    if (!enabled) {
      await openAppSettings();
      return true;
    }

    final current = await Permission.notification.status;
    if (current.isGranted || current.isLimited || current.isProvisional) {
      return false;
    }

    final requested = await Permission.notification.request();
    if (requested.isGranted ||
        requested.isLimited ||
        requested.isProvisional) {
      return false;
    }

    await openAppSettings();
    return true;
  }
}
