import 'package:app_builder_mobile/data/datasources/auth_local_datasource.dart';
import 'package:app_builder_mobile/domain/repositories/auth_repository.dart';

/// Implementation of AuthRepository
/// Delegates to AuthLocalDataSource for actual data operations
class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl({required AuthLocalDataSource localDataSource})
      : _localDataSource = localDataSource;

  @override
  Future<bool> isUserLoggedIn() async {
    return await _localDataSource.isUserLoggedIn();
  }

  @override
  Future<Map<String, dynamic>?> getUserData() async {
    return await _localDataSource.getUserData();
  }

  @override
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _localDataSource.saveUserData(userData);
  }

  @override
  Future<void> logout() async {
    await _localDataSource.clearUserData();
    await _localDataSource.deleteSecure('user');
  }

  @override
  Future<void> clearAll() async {
    await _localDataSource.clearAll();
  }

  @override
  Future<void> saveSecure(String key, dynamic value) async {
    await _localDataSource.saveSecure(key, value);
  }

  @override
  Future<dynamic> getSecure(String key) async {
    return await _localDataSource.getSecure(key);
  }

  @override
  Future<void> deleteSecure(String key) async {
    await _localDataSource.deleteSecure(key);
  }

  @override
  Future<bool> hasKey(String key) async {
    return await _localDataSource.hasKey(key);
  }
}
