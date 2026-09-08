import 'package:electricity_board_erp/features/authentication/domain/auth_repository.dart';
import 'package:electricity_board_erp/shared/models/user_profile.dart';

/// In-memory auth used by widget tests. Production uses [ApiAuthRepository].
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({
    this.validUsername = 'edl.user',
    this.validPassword = 'SecurePass1',
    this.user = UserProfile.sample,
  });

  final String validUsername;
  final String validPassword;
  final UserProfile user;

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
}
