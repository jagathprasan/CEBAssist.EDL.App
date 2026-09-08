import '../config/app_config.dart';

/// Turns a CEBAssist picture path into a loadable URL.
String? resolveMediaUrl(String? path) {
  if (path == null) return null;
  final normalized = path.trim().replaceAll('\\', '/');
  if (normalized.isEmpty) return null;
  if (normalized.startsWith('http://') || normalized.startsWith('https://')) {
    return normalized;
  }
  final base = AppConfig.apiBaseUrl.replaceAll(RegExp(r'/$'), '');
  return normalized.startsWith('/') ? '$base$normalized' : '$base/$normalized';
}
