import '../config/app_config.dart';

/// Turns a CEBAssist picture path into a loadable URL.
///
/// Stored values are often `/uploads/prifile-pictures/{file}` or a Windows
/// path. Profile pictures are served from the same host as the API.
String? resolveMediaUrl(String? path) {
  if (path == null) return null;
  var normalized = path.trim().replaceAll('\\', '/');
  if (normalized.isEmpty) return null;
  if (normalized.startsWith('http://') || normalized.startsWith('https://')) {
    return normalized;
  }

  final uploadsAt = normalized.toLowerCase().indexOf('/uploads/');
  if (uploadsAt >= 0) {
    normalized = normalized.substring(uploadsAt);
  } else if (!normalized.contains('/')) {
    normalized = '/uploads/prifile-pictures/$normalized';
  }

  final base = AppConfig.apiBaseUrl.replaceAll(RegExp(r'/$'), '');
  return normalized.startsWith('/') ? '$base$normalized' : '$base/$normalized';
}
