import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';

/// Must be overridden in [main] and in tests with a ready instance.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden');
});

/// Thin persistence wrapper so feature code does not touch prefs keys.
class LocalStorageService {
  LocalStorageService(this._prefs);

  final SharedPreferences _prefs;

  String? get themeModeName => _prefs.getString(AppConstants.themeModeKey);

  Future<void> setThemeModeName(String value) {
    return _prefs.setString(AppConstants.themeModeKey, value);
  }

  bool get rememberSession =>
      _prefs.getBool(AppConstants.rememberSessionKey) ?? false;

  Future<void> setRememberSession(bool value) {
    return _prefs.setBool(AppConstants.rememberSessionKey, value);
  }

  bool get notificationsEnabled =>
      _prefs.getBool(AppConstants.notificationsEnabledKey) ?? true;

  Future<void> setNotificationsEnabled(bool value) {
    return _prefs.setBool(AppConstants.notificationsEnabledKey, value);
  }

  bool get biometricEnabled =>
      _prefs.getBool(AppConstants.biometricEnabledKey) ?? false;

  Future<void> setBiometricEnabled(bool value) {
    return _prefs.setBool(AppConstants.biometricEnabledKey, value);
  }

  String get languageCode =>
      _prefs.getString(AppConstants.languageCodeKey) ?? 'en';

  Future<void> setLanguageCode(String value) {
    return _prefs.setString(AppConstants.languageCodeKey, value);
  }
}

final localStorageProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService(ref.watch(sharedPreferencesProvider));
});
