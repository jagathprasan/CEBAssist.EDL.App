import 'package:flutter/foundation.dart';

/// Runtime configuration for the EDL CEBAssist mobile client.
class AppConfig {
  AppConfig._();

  /// Home company for this app build. Sister apps use NTNSP, NSO, or EGL.
  static const String companyId = 'EDL';

  static const String companyName = 'EDL';

  static const String _definedBaseUrl = String.fromEnvironment('API_BASE_URL');

  /// Override at build time:
  /// `flutter run --dart-define=API_BASE_URL=https://edl.cebassist.lk`
  static String get apiBaseUrl {
    if (_definedBaseUrl.isNotEmpty) {
      return _definedBaseUrl.replaceAll(RegExp(r'/$'), '');
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8092';
    }
    return 'http://localhost:8092';
  }

  static const Duration requestTimeout = Duration(seconds: 20);
}
