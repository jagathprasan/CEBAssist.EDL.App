import '../../../shared/models/user_profile.dart';

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Authentication contract implemented by the CEBAssist aggregator client.
abstract class AuthRepository {
  Future<UserProfile> login({
    required String identifier,
    required String password,
    required bool rememberMe,
  });

  Future<void> logout();

  Future<UserProfile?> restoreSession();

  Future<void> requestPasswordReset(String identifier);

  Future<UserProfile> refreshProfile();

  Future<UserProfile> updateContact({
    required String fullName,
    required String email,
    required String mobile,
    required String landline,
  });

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  });
}
