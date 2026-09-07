import '../../../core/constants/app_constants.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../shared/models/user_profile.dart';
import '../domain/auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  MockAuthRepository({
    required this.storage,
    this.networkDelay = const Duration(milliseconds: 700),
  });

  final LocalStorageService storage;
  final Duration networkDelay;

  Future<void> _wait() async {
    if (networkDelay > Duration.zero) {
      await Future<void>.delayed(networkDelay);
    }
  }

  @override
  Future<UserProfile> login({
    required String identifier,
    required String password,
    required bool rememberMe,
  }) async {
    await _wait();

    final username = identifier.trim().toLowerCase();
    final expectedUser = AppConstants.demoUsername.toLowerCase();
    final valid =
        (username == expectedUser ||
            identifier.trim() == UserProfile.sample.employeeId) &&
        password == AppConstants.demoPassword;

    if (!valid) {
      throw const AuthException(
        'We could not sign you in. Check your employee ID or email and password, then try again.',
      );
    }

    await storage.setRememberSession(rememberMe);
    return UserProfile.sample;
  }

  @override
  Future<void> logout() async {
    await _wait();
    await storage.setRememberSession(false);
  }

  @override
  Future<UserProfile?> restoreSession() async {
    await _wait();
    if (storage.rememberSession) {
      return UserProfile.sample;
    }
    return null;
  }

  @override
  Future<void> requestPasswordReset(String identifier) async {
    await _wait();
    if (identifier.trim().isEmpty) {
      throw const AuthException('Enter your employee ID or email to continue.');
    }
  }
}
