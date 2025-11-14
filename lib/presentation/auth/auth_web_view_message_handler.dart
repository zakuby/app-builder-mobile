import 'package:app_builder_mobile/presentation/auth/cubit/auth_cubit.dart';
import 'package:app_builder_mobile/presentation/webview/default_web_view_message_handler.dart';
import 'package:flutter/material.dart';

/// Authentication-specific WebView message handler
/// Extends DefaultWebViewMessageHandler with login-specific actions
class AuthWebViewMessageHandler extends DefaultWebViewMessageHandler {
  final AuthCubit authCubit;
  final VoidCallback? onLoginSuccess;

  AuthWebViewMessageHandler({
    required this.authCubit,
    this.onLoginSuccess,
  });

  @override
  Future<void> handleMessage(
    Map<String, dynamic> data,
    String? callbackId,
  ) async {
    try {
      final action = data['action'] as String?;

      debugPrint('Auth handler - Handling action: $action');

      // Handle login-specific actions
      switch (action) {
        case 'SAVE_SECURE':
          await _handleAuthSaveSecure(data, callbackId);
          break;
        case 'login_success':
        case 'auth_success':
          await _handleLoginSuccess(data);
          break;
        default:
          // Delegate to parent for standard actions (GET_SECURE, DELETE_SECURE, LOGOUT)
          await super.handleMessage(data, callbackId);
      }
    } catch (e) {
      debugPrint('Error handling message in auth handler: $e');
      sendCallback(callbackId, false, 'Error: $e');
    }
  }

  /// Handle SAVE_SECURE action with login navigation
  Future<void> _handleAuthSaveSecure(
    Map<String, dynamic> message,
    String? callbackId,
  ) async {
    try {
      final messageData = message['data'] as Map<String, dynamic>?;
      if (messageData == null) {
        sendCallback(callbackId, false, 'No data provided');
        return;
      }

      final key = messageData['key'] as String?;
      final value = messageData['value'];

      if (key == null || key.isEmpty) {
        sendCallback(callbackId, false, 'No key provided');
        return;
      }

      // Save using auth cubit
      await authCubit.saveSecure(key, value);
      debugPrint('Saved secure data with key: $key');

      // Send success callback
      sendCallback(callbackId, true, 'Data saved successfully');

      // If the key is 'user', trigger login success
      if (key == 'user') {
        await Future.delayed(const Duration(milliseconds: 100));
        onLoginSuccess?.call();
      }
    } catch (e) {
      debugPrint('Error handling SAVE_SECURE in auth: $e');
      sendCallback(callbackId, false, 'Error saving data: $e');
    }
  }

  /// Handle legacy login_success and auth_success actions
  Future<void> _handleLoginSuccess(Map<String, dynamic> data) async {
    try {
      final userData = data['user'] as Map<String, dynamic>? ?? data;
      await authCubit.login(userData);
      onLoginSuccess?.call();
    } catch (e) {
      debugPrint('Error handling login success: $e');
    }
  }
}
