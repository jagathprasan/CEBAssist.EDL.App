import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/local_storage_service.dart';
import '../../../../shared/models/user_profile.dart';
import '../../data/mock_auth_repository.dart';
import '../../domain/auth_repository.dart';

/// When true, auth starts initialized so tests can skip the splash bootstrap.
final skipAuthBootstrapProvider = Provider<bool>((ref) => false);

/// Optional seeded user for widget tests that start already signed in.
final seededUserProvider = Provider<UserProfile?>((ref) => null);

final simulatedNetworkDelayProvider = Provider<Duration>((ref) {
  return const Duration(milliseconds: 700);
});

final splashDelayProvider = Provider<Duration>((ref) {
  return const Duration(milliseconds: 1600);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return MockAuthRepository(
    storage: ref.watch(localStorageProvider),
    networkDelay: ref.watch(simulatedNetworkDelayProvider),
  );
});

class AuthState {
  const AuthState({
    this.isInitialized = false,
    this.isAuthenticated = false,
    this.isLoading = false,
    this.user,
    this.errorMessage,
  });

  final bool isInitialized;
  final bool isAuthenticated;
  final bool isLoading;
  final UserProfile? user;
  final String? errorMessage;

  AuthState copyWith({
    bool? isInitialized,
    bool? isAuthenticated,
    bool? isLoading,
    UserProfile? user,
    String? errorMessage,
    bool clearError = false,
    bool clearUser = false,
  }) {
    return AuthState(
      isInitialized: isInitialized ?? this.isInitialized,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      user: clearUser ? null : user ?? this.user,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    if (ref.read(skipAuthBootstrapProvider)) {
      final seeded = ref.read(seededUserProvider);
      return AuthState(
        isInitialized: true,
        isAuthenticated: seeded != null,
        user: seeded,
      );
    }
    return const AuthState();
  }

  AuthRepository get _repository => ref.read(authRepositoryProvider);

  /// Simulated startup check. Ready to be replaced with token validation.
  Future<void> initialize() async {
    if (state.isInitialized) return;
    try {
      final user = await _repository.restoreSession();
      state = AuthState(
        isInitialized: true,
        isAuthenticated: user != null,
        user: user,
      );
    } catch (_) {
      state = const AuthState(isInitialized: true);
    }
  }

  Future<bool> login({
    required String identifier,
    required String password,
    required bool rememberMe,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _repository.login(
        identifier: identifier,
        password: password,
        rememberMe: rememberMe,
      );
      state = AuthState(isInitialized: true, isAuthenticated: true, user: user);
      return true;
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        isInitialized: true,
        isAuthenticated: false,
        errorMessage: error.toString(),
        clearUser: true,
      );
      return false;
    }
  }

  void clearError() {
    if (state.errorMessage != null) {
      state = state.copyWith(clearError: true);
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AuthState(isInitialized: true);
  }

  Future<void> requestPasswordReset(String identifier) {
    return _repository.requestPasswordReset(identifier);
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
