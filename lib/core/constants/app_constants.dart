/// Central branding and configuration values.
///
/// Update [appName], colours in `app_colors.dart`, and the logo
/// asset paths to rebrand the application without touching screens.
class AppConstants {
  AppConstants._();

  /// Primary product name shown in the UI.
  static const String appName = 'CEBAssist';

  /// Longer product description used in about copy and login.
  static const String appFullName = 'EDL · Electricity Board ERP';

  /// Short line displayed on the splash screen.
  static const String tagline = 'Powering Smarter Operations';

  /// Semantic version shown in settings and on the login footer.
  static const String appVersion = '1.0.0';

  /// Full logo with hex icon and wordmark (`ca-logo-new.png`).
  static const String logoFullAsset = 'assets/images/ca-logo-new.png';

  /// Wordmark-only logo (`logo.png`).
  static const String logoWordmarkAsset = 'assets/images/logo.png';

  static const String themeModeKey = 'theme_mode';
  static const String rememberSessionKey = 'remember_session';
  static const String notificationsEnabledKey = 'notifications_enabled';
  static const String biometricEnabledKey = 'biometric_enabled';
  static const String languageCodeKey = 'language_code';
}
