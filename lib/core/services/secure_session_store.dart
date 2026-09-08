import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Encrypted session store. Access tokens never go in SharedPreferences.
class SecureSessionStore {
  SecureSessionStore({FlutterSecureStorage? storage})
    : _storage =
          storage ??
          const FlutterSecureStorage(
            aOptions: AndroidOptions(encryptedSharedPreferences: true),
            iOptions: IOSOptions(
              accessibility: KeychainAccessibility.first_unlock_this_device,
            ),
          );

  static const _tokenKey = 'cebassist.edl.access_token';
  static const _expiryKey = 'cebassist.edl.token_expiry';
  static const _profileKey = 'cebassist.edl.user_profile';

  final FlutterSecureStorage _storage;

  Future<void> saveSession({
    required String accessToken,
    required DateTime expiresAt,
    required Map<String, dynamic> profile,
  }) async {
    await Future.wait([
      _storage.write(key: _tokenKey, value: accessToken),
      _storage.write(key: _expiryKey, value: expiresAt.toIso8601String()),
      _storage.write(key: _profileKey, value: jsonEncode(profile)),
    ]);
  }

  Future<String?> readAccessToken() => _storage.read(key: _tokenKey);

  Future<DateTime?> readExpiry() async {
    final raw = await _storage.read(key: _expiryKey);
    if (raw == null || raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }

  Future<Map<String, dynamic>?> readProfile() async {
    final raw = await _storage.read(key: _profileKey);
    if (raw == null || raw.isEmpty) return null;
    final decoded = jsonDecode(raw);
    if (decoded is Map<String, dynamic>) return decoded;
    if (decoded is Map) return Map<String, dynamic>.from(decoded);
    return null;
  }

  Future<void> clear() async {
    await Future.wait([
      _storage.delete(key: _tokenKey),
      _storage.delete(key: _expiryKey),
      _storage.delete(key: _profileKey),
    ]);
  }
}
