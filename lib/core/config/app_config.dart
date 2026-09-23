import 'env_config.dart';

/// Runtime configuration for the EDL CEBAssist mobile client.
class AppConfig {
  AppConfig._();

  /// Home company for this app build. Sister apps use NTNSP, NSO, or EGL.
  static const String companyId = 'EDL';

  static const String companyName = 'EDL';

  /// Live CEBAssist gateway. Used unless `.env` or a dart-define sets a host.
  static const String liveApiBaseUrl = 'https://edl.cebassist.lk';

  static const String _definedBaseUrl = String.fromEnvironment('API_BASE_URL');

  /// Host for the CEBAssist API aggregator.
  ///
  /// Priority:
  /// 1. `--dart-define=API_BASE_URL=...` (CI or a one-off run)
  /// 2. `API_BASE_URL` in `.env` (local testing)
  /// 3. [liveApiBaseUrl]
  static String get apiBaseUrl {
    final fromDefine = _definedBaseUrl.trim();
    if (fromDefine.isNotEmpty) {
      return _withoutTrailingSlash(fromDefine);
    }

    final fromEnv = EnvConfig.apiBaseUrl;
    if (fromEnv != null && fromEnv.isNotEmpty) {
      return fromEnv;
    }

    return liveApiBaseUrl;
  }

  static String _withoutTrailingSlash(String url) =>
      url.replaceAll(RegExp(r'/$'), '');

  static const Duration requestTimeout = Duration(seconds: 20);
}
