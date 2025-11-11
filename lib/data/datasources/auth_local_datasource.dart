import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Local data source for authentication and secure storage operations
/// Handles all interactions with Flutter Secure Storage
abstract class AuthLocalDataSource {
  /// Check if user is logged in
  Future<bool> isUserLoggedIn();

  /// Get stored user data as JSON
  Future<Map<String, dynamic>?> getUserData();

  /// Save user data to secure storage
  Future<void> saveUserData(Map<String, dynamic> userData);

  /// Clear user data (logout)
  Future<void> clearUserData();

  /// Clear all secure storage data
  Future<void> clearAll();

  /// Save data to secure storage with a custom key
  Future<void> saveSecure(String key, dynamic value);

  /// Get data from secure storage with a custom key
  Future<dynamic> getSecure(String key);

  /// Delete data from secure storage with a custom key
  Future<void> deleteSecure(String key);

  /// Check if a key exists in secure storage
  Future<bool> hasKey(String key);
}

/// Implementation of AuthLocalDataSource using FlutterSecureStorage
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const String _userDataKey = 'user_data';

  final FlutterSecureStorage _storage;

  AuthLocalDataSourceImpl({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(
                encryptedSharedPreferences: true,
              ),
            );

  @override
  Future<bool> isUserLoggedIn() async {
    try {
      // First check the new 'user' key
      final userData = await _storage.read(key: 'user');
      if (userData != null && userData.isNotEmpty) {
        return true;
      }

      // Fallback to legacy 'user_data' key for backwards compatibility
      final legacyUserData = await _storage.read(key: _userDataKey);
      return legacyUserData != null && legacyUserData.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final userData = await _storage.read(key: _userDataKey);
      if (userData == null || userData.isEmpty) {
        return null;
      }
      return json.decode(userData) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    try {
      final userDataJson = json.encode(userData);
      await _storage.write(key: _userDataKey, value: userDataJson);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> clearUserData() async {
    try {
      await _storage.delete(key: _userDataKey);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> saveSecure(String key, dynamic value) async {
    try {
      String valueToStore;
      if (value is Map<String, dynamic>) {
        valueToStore = json.encode(value);
      } else if (value is String) {
        valueToStore = value;
      } else {
        valueToStore = json.encode(value);
      }
      await _storage.write(key: key, value: valueToStore);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<dynamic> getSecure(String key) async {
    try {
      final value = await _storage.read(key: key);
      if (value == null || value.isEmpty) {
        return null;
      }

      // Try to parse as JSON, if it fails return as string
      try {
        return json.decode(value);
      } catch (_) {
        return value;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> deleteSecure(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> hasKey(String key) async {
    try {
      final value = await _storage.read(key: key);
      return value != null && value.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
