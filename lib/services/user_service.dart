import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:doctor_gen_app/models/user.dart';
import 'package:doctor_gen_app/database/db_helper.dart';

class UserService {
  static const _storage = FlutterSecureStorage();
  final DBHelper _dbHelper = DBHelper();

  /// Save a new user (sign up)
  Future<int> registerUser(User user) async {
    // Save user in the local database
    final userId = await _dbHelper.createUser(user);

    // Optionally store session info securely
    await _storage.write(key: 'user_id', value: userId.toString());
    await _storage.write(key: 'is_logged_in', value: 'true');

    return userId;
  }

  /// Log in user using email and password
  Future<User?> login(String email, String password) async {
    final user = await _dbHelper.getUserByEmail(email);

    if (user != null && user.passwordHash == password) {
      // Store session securely
      await _storage.write(key: 'user_id', value: user.id.toString());
      await _storage.write(key: 'is_logged_in', value: 'true');
      return user;
    }
    return null;
  }

  /// Update user profile
  Future<void> updateUser(User user) async {
    await _dbHelper.updateUser(user);
  }

  /// Get currently logged-in user
  Future<User?> getCurrentUser() async {
    final userId = await _storage.read(key: 'user_id');
    if (userId == null) return null;
    return await _dbHelper.getUserById(int.parse(userId));
  }

  /// Log out user (clear secure session)
  Future<void> logout() async {
    await _storage.delete(key: 'user_id');
    await _storage.delete(key: 'is_logged_in');
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final status = await _storage.read(key: 'is_logged_in');
    return status == 'true';
  }

  /// Delete account
  Future<void> deleteUserAccount(int userId) async {
    await _dbHelper.deleteUser(userId);
    await logout(); // Clear session
  }
}
