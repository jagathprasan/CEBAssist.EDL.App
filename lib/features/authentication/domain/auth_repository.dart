import '../../../shared/models/user_profile.dart';

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Authentication contract. Replace [MockAuthRepository] with a REST client later.
abstract class AuthRepository {
  Future<UserProfile> login({
    required String identifier,
    required String password,
    required bool rememberMe,
  });

  Future<void> logout();

  Future<UserProfile?> restoreSession();

  Future<void> requestPasswordReset(String identifier);
}
