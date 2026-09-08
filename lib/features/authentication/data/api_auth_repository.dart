import '../../../core/config/app_config.dart';
import '../../../core/network/api_client.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../core/services/secure_session_store.dart';
import '../../../shared/models/user_profile.dart';
import '../domain/auth_repository.dart';

class ApiAuthRepository implements AuthRepository {
  ApiAuthRepository({
    required this.api,
    required this.sessionStore,
    required this.storage,
  });

  final ApiClient api;
  final SecureSessionStore sessionStore;
  final LocalStorageService storage;

  String? _memoryToken;

  String get _loginPath => '/${AppConfig.companyId}/Login';
  String get _mePath => '/${AppConfig.companyId}/Me';
  String get _logoutPath => '/${AppConfig.companyId}/Logout';

  @override
  Future<UserProfile> login({
    required String identifier,
    required String password,
    required bool rememberMe,
  }) async {
    try {
      final payload = await api.postJson(
        _loginPath,
        body: {'username': identifier.trim(), 'password': password},
      );

      final token = _readString(payload, 'accessToken', 'AccessToken');
      if (token == null || token.isEmpty) {
        throw const AuthException(
          'We could not sign you in. Please try again.',
        );
      }

      final expiresIn = _readInt(payload, 'expiresIn', 'ExpiresIn') ?? 28800;
      final userJson = _readMap(payload, 'user', 'User') ?? payload;
      final user = UserProfile.fromJson(userJson);

      _memoryToken = token;
      await storage.setRememberSession(rememberMe);

      if (rememberMe) {
        await sessionStore.saveSession(
          accessToken: token,
          expiresAt: DateTime.now().toUtc().add(Duration(seconds: expiresIn)),
          profile: user.toJson(),
        );
      } else {
        await sessionStore.clear();
      }

      return user;
    } on AuthException {
      rethrow;
    } on ApiException catch (error) {
      throw AuthException(error.message);
    }
  }

  @override
  Future<void> logout() async {
    final token = await _currentToken();
    if (token != null) {
      try {
        await api.postJson(_logoutPath, accessToken: token);
      } catch (_) {
        // Always clear local credentials even if the network call fails.
      }
    }
    _memoryToken = null;
    await sessionStore.clear();
    await storage.setRememberSession(false);
  }

  @override
  Future<UserProfile?> restoreSession() async {
    if (!storage.rememberSession) {
      await sessionStore.clear();
      return null;
    }

    final expiry = await sessionStore.readExpiry();
    final token = await sessionStore.readAccessToken();
    if (token == null || token.isEmpty) {
      await sessionStore.clear();
      return null;
    }

    if (expiry != null && DateTime.now().toUtc().isAfter(expiry)) {
      await sessionStore.clear();
      await storage.setRememberSession(false);
      return null;
    }

    try {
      final payload = await api.getJson(_mePath, accessToken: token);
      final user = UserProfile.fromJson(payload);
      _memoryToken = token;
      await sessionStore.saveSession(
        accessToken: token,
        expiresAt:
            expiry ?? DateTime.now().toUtc().add(const Duration(hours: 8)),
        profile: user.toJson(),
      );
      return user;
    } on ApiException catch (error) {
      if (error.statusCode == 401 || error.statusCode == 403) {
        await sessionStore.clear();
        await storage.setRememberSession(false);
        return null;
      }
      final cached = await sessionStore.readProfile();
      if (cached == null) return null;
      _memoryToken = token;
      return UserProfile.fromJson(cached);
    }
  }

  @override
  Future<void> requestPasswordReset(String identifier) async {
    if (identifier.trim().isEmpty) {
      throw const AuthException('Enter your username to continue.');
    }
    throw const AuthException(
      'Password resets are handled by your administrator. Contact CEBAssist support if you cannot sign in.',
    );
  }

  Future<String?> _currentToken() async {
    if (_memoryToken != null && _memoryToken!.isNotEmpty) return _memoryToken;
    return sessionStore.readAccessToken();
  }

  String? _readString(Map<String, dynamic> json, String camel, String pascal) {
    final value = json[camel] ?? json[pascal];
    return value?.toString();
  }

  int? _readInt(Map<String, dynamic> json, String camel, String pascal) {
    final value = json[camel] ?? json[pascal];
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '');
  }

  Map<String, dynamic>? _readMap(
    Map<String, dynamic> json,
    String camel,
    String pascal,
  ) {
    final value = json[camel] ?? json[pascal];
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }
}
