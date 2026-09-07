import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/local_storage_service.dart';

class AppSettings {
  const AppSettings({
    required this.notificationsEnabled,
    required this.biometricEnabled,
    required this.languageCode,
  });

  final bool notificationsEnabled;
  final bool biometricEnabled;
  final String languageCode;

  AppSettings copyWith({
    bool? notificationsEnabled,
    bool? biometricEnabled,
    String? languageCode,
  }) {
    return AppSettings(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      languageCode: languageCode ?? this.languageCode,
    );
  }
}

class AppSettingsNotifier extends Notifier<AppSettings> {
  @override
  AppSettings build() {
    final storage = ref.watch(localStorageProvider);
    return AppSettings(
      notificationsEnabled: storage.notificationsEnabled,
      biometricEnabled: storage.biometricEnabled,
      languageCode: storage.languageCode,
    );
  }

  Future<void> setNotificationsEnabled(bool value) async {
    state = state.copyWith(notificationsEnabled: value);
    await ref.read(localStorageProvider).setNotificationsEnabled(value);
  }

  Future<void> setBiometricEnabled(bool value) async {
    state = state.copyWith(biometricEnabled: value);
    await ref.read(localStorageProvider).setBiometricEnabled(value);
  }

  Future<void> setLanguageCode(String value) async {
    state = state.copyWith(languageCode: value);
    await ref.read(localStorageProvider).setLanguageCode(value);
  }
}

final appSettingsProvider = NotifierProvider<AppSettingsNotifier, AppSettings>(
  AppSettingsNotifier.new,
);
