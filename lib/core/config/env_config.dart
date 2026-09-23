import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Loads optional runtime overrides from the project `.env` asset.
///
/// Leave `API_BASE_URL` unset to use the live server.
class EnvConfig {
  EnvConfig._();

  static Future<void> load() async {
    try {
      await dotenv.load(fileName: '.env');
    } catch (_) {
      // A missing .env is fine. The app stays on the live server.
    }
  }

  /// `API_BASE_URL` from `.env`, or null when it is missing or blank.
  static String? get apiBaseUrl {
    if (!dotenv.isInitialized) return null;
    final value = dotenv.env['API_BASE_URL']?.trim();
    if (value == null || value.isEmpty) return null;
    return value.replaceAll(RegExp(r'/$'), '');
  }
}
