import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  // Create an instance of FlutterSecureStorage
  static final _storage = FlutterSecureStorage();

  // Keys for secure storage
  static const _tokenKey = 'auth_token';
  static const _userIdKey = 'user_id';
  static const _userEmailKey = 'user_email';

  /// Save authentication data securely
  static Future<void> saveAuthData({
    required String token,
    required int userId,
    required String email,
  }) async {
    await _storage.write(key: _tokenKey, value: token);
    await _storage.write(key: _userIdKey, value: userId.toString());
    await _storage.write(key: _userEmailKey, value: email);
  }

  /// Retrieve token
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// Retrieve user ID
  static Future<int?> getUserId() async {
    final value = await _storage.read(key: _userIdKey);
    return value != null ? int.tryParse(value) : null;
  }

  /// Retrieve email
  static Future<String?> getUserEmail() async {
    return await _storage.read(key: _userEmailKey);
  }

  /// Check if the user is authenticated
  static Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Clear authentication data (logout)
  static Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userIdKey);
    await _storage.delete(key: _userEmailKey);
  }

  /// Update token (useful for refresh tokens)
  static Future<void> updateToken(String newToken) async {
    await _storage.write(key: _tokenKey, value: newToken);
  }
}
