/// Repository interface for authentication operations
/// This defines the contract for authentication-related data operations
abstract class AuthRepository {
  /// Check if user is currently logged in
  Future<bool> isUserLoggedIn();

  /// Get stored user data
  Future<Map<String, dynamic>?> getUserData();

  /// Save user data (login)
  Future<void> saveUserData(Map<String, dynamic> userData);

  /// Clear user data (logout)
  Future<void> logout();

  /// Clear all stored data
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
