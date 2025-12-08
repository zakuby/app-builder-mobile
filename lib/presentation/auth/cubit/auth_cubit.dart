import 'package:app_builder_mobile/domain/repositories/auth_repository.dart';
import 'package:app_builder_mobile/presentation/auth/cubit/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit for managing authentication state
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit({required AuthRepository authRepository})
    : _authRepository = authRepository,
      super(const AuthState.initial());

  /// Check if user is logged in
  Future<void> checkAuthStatus() async {
    try {
      emit(const AuthState.loading());

      final isLoggedIn = await _authRepository.isUserLoggedIn();

      if (isLoggedIn) {
        final userData = await _authRepository.getUserData();
        emit(AuthState.authenticated(userData: userData));
      } else {
        emit(const AuthState.unauthenticated());
      }
    } catch (e) {
      debugPrint('Error checking auth status: $e');
      emit(AuthState.error(message: e.toString()));
      emit(const AuthState.unauthenticated());
    }
  }

  /// Save user data (login)
  Future<void> login() async {
    try {
      emit(const AuthState.loading());
      final userData = await _authRepository.getUserData();
      emit(AuthState.authenticated(userData: userData));
    } catch (e) {
      debugPrint('Error during login: $e');
      emit(AuthState.error(message: e.toString()));
      emit(const AuthState.unauthenticated());
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      emit(const AuthState.loading());

      await _authRepository.logout();
      emit(const AuthState.unauthenticated());
    } catch (e) {
      debugPrint('Error during logout: $e');
      emit(AuthState.error(message: e.toString()));
    }
  }

  /// Save secure data
  Future<void> saveSecure(String key, dynamic value) async {
    try {
      await _authRepository.saveSecure(key, value);

      // If saving user data, update auth state
      if (key == 'user') {
        final userData = await _authRepository.getUserData();
        emit(AuthState.authenticated(userData: userData));
      }
    } catch (e) {
      debugPrint('Error saving secure data: $e');
      emit(AuthState.error(message: e.toString()));
    }
  }

  /// Get secure data
  Future<dynamic> getSecure(String key) async {
    try {
      return await _authRepository.getSecure(key);
    } catch (e) {
      debugPrint('Error getting secure data: $e');
      return null;
    }
  }

  /// Delete secure data
  Future<void> deleteSecure(String key) async {
    try {
      await _authRepository.deleteSecure(key);
    } catch (e) {
      debugPrint('Error deleting secure data: $e');
    }
  }
}
