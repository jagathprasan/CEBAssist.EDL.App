import 'package:electricity_board_erp/features/authentication/domain/auth_repository.dart';
import 'package:electricity_board_erp/shared/models/user_profile.dart';

/// In-memory auth used by widget tests. Production uses [ApiAuthRepository].
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({
    this.validUsername = 'edl.user',
    this.validPassword = 'SecurePass1',
    UserProfile? user,
  }) : user = user ?? UserProfile.sample;

  final String validUsername;
  final String validPassword;
  UserProfile user;

  bool _remembered = false;

  @override
  Future<UserProfile> login({
    required String identifier,
    required String password,
    required bool rememberMe,
  }) async {
    if (identifier.trim() == validUsername && password == validPassword) {
      _remembered = rememberMe;
      return user;
    }
    throw const AuthException(
      'We could not sign you in. Check your username and password, then try again.',
    );
  }

  @override
  Future<void> logout() async {
    _remembered = false;
  }

  @override
  Future<UserProfile?> restoreSession() async {
    return _remembered ? user : null;
  }

  @override
  Future<void> requestPasswordReset(String identifier) async {
    if (identifier.trim().isEmpty) {
      throw const AuthException('Enter your username to continue.');
    }
  }

  @override
  Future<UserProfile> refreshProfile() async => user;

  @override
  Future<UserProfile> updateContact({
    required String fullName,
    required String email,
    required String mobile,
    required String landline,
  }) async {
    user = user.copyWith(
      fullName: fullName,
      email: email,
      mobile: mobile,
      landline: landline,
    );
    return user;
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    if (currentPassword != validPassword) {
      throw const AuthException('Current password is incorrect.');
    }
    if (newPassword != confirmPassword) {
      throw const AuthException('New password and confirmation do not match.');
    }
  }
}
