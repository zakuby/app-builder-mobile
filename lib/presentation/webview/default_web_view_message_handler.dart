import 'package:app_builder_mobile/core/di/injection.dart';
import 'package:app_builder_mobile/data/datasources/device_info_datasource.dart';
import 'package:app_builder_mobile/domain/repositories/auth_repository.dart';
import 'package:app_builder_mobile/presentation/webview/web_view_message_handler.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Default implementation of WebViewMessageHandler
/// Handles authentication-related actions: SAVE_SECURE, GET_SECURE, DELETE_SECURE, LOGOUT, GET_DEVICE_INFO, GET_APP_VERSION
class DefaultWebViewMessageHandler extends WebViewMessageHandler {
  final AuthRepository _authRepository = getIt<AuthRepository>();
  final DeviceInfoDataSource _deviceInfoDataSource =
      getIt<DeviceInfoDataSource>();
  final VoidCallback? onLogout;

  DefaultWebViewMessageHandler({this.onLogout});

  @override
  Future<void> handleMessage(
    Map<String, dynamic> data,
    String? callbackId,
  ) async {
    try {
      final action = data['action'] as String?;

      debugPrint('Handling action: $action');

      switch (action) {
        case 'SAVE_SECURE':
          await _handleSaveSecure(data, callbackId);
          break;
        case 'GET_SECURE':
          await _handleGetSecure(data, callbackId);
          break;
        case 'DELETE_SECURE':
          await _handleDeleteSecure(data, callbackId);
          break;
        case 'LOGOUT':
        case 'logout':
          await _handleLogout(callbackId);
          break;
        case 'GET_DEVICE_INFO':
          await _handleGetDeviceInfo(callbackId);
          break;
        case 'GET_APP_VERSION':
          await _handleGetAppVersion(callbackId);
          break;
        default:
          debugPrint('Unknown action: $action');
          sendCallback(callbackId, false, 'Unknown action: $action');
      }
    } catch (e) {
      debugPrint('Error handling message: $e');
      sendCallback(callbackId, false, 'Error: $e');
    }
  }

  /// Handle SAVE_SECURE action from web
  Future<void> _handleSaveSecure(
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

      await _authRepository.saveSecure(key, value);
      debugPrint('Saved secure data with key: $key');

      sendCallback(callbackId, true, 'Data saved successfully');
    } catch (e) {
      debugPrint('Error handling SAVE_SECURE: $e');
      sendCallback(callbackId, false, 'Error saving data: $e');
    }
  }

  /// Handle GET_SECURE action from web
  Future<void> _handleGetSecure(
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

      if (key == null || key.isEmpty) {
        sendCallback(callbackId, false, 'No key provided');
        return;
      }

      final value = await _authRepository.getSecure(key);
      debugPrint('Retrieved secure data with key: $key');

      // ✅ Send data as a Map with both key and value
      sendCallback(callbackId, true, 'Data retrieved successfully', {
        'key': key, // Include the key
        'value': value, // The actual value
      });
    } catch (e) {
      debugPrint('Error handling GET_SECURE: $e');
      sendCallback(callbackId, false, 'Error retrieving data: $e');
    }
  }

  /// Handle DELETE_SECURE action from web
  Future<void> _handleDeleteSecure(
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

      if (key == null || key.isEmpty) {
        sendCallback(callbackId, false, 'No key provided');
        return;
      }

      await _authRepository.deleteSecure(key);
      debugPrint('Deleted secure data with key: $key');

      sendCallback(callbackId, true, 'Data deleted successfully');
    } catch (e) {
      debugPrint('Error handling DELETE_SECURE: $e');
      sendCallback(callbackId, false, 'Error deleting data: $e');
    }
  }

  /// Handle LOGOUT action from web
  Future<void> _handleLogout(String? callbackId) async {
    try {
      await _authRepository.logout();
      debugPrint('User logged out successfully');

      sendCallback(callbackId, true, 'Logged out successfully');

      // Navigate to auth page after logout
      onLogout?.call();
    } catch (e) {
      debugPrint('Error handling LOGOUT: $e');
      sendCallback(callbackId, false, 'Error logging out: $e');
    }
  }

  /// Handle GET_DEVICE_INFO action from web
  Future<void> _handleGetDeviceInfo(String? callbackId) async {
    try {
      final deviceInfo = await _deviceInfoDataSource.getDeviceInfo();
      debugPrint('Retrieved device info: $deviceInfo');

      sendCallback(
        callbackId,
        true,
        'Device info retrieved successfully',
        deviceInfo,
      );
    } catch (e) {
      debugPrint('Error handling GET_DEVICE_INFO: $e');
      sendCallback(callbackId, false, 'Error retrieving device info: $e');
    }
  }

  /// Handle GET_APP_VERSION action from web
  Future<void> _handleGetAppVersion(String? callbackId) async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();

      final versionData = {
        'version': packageInfo.version,
        'buildNumber': packageInfo.buildNumber,
      };

      debugPrint('Retrieved app version: $versionData');

      sendCallback(
        callbackId,
        true,
        'App version retrieved successfully',
        versionData,
      );
    } catch (e) {
      debugPrint('Error handling GET_APP_VERSION: $e');
      sendCallback(callbackId, false, 'Error retrieving app version: $e');
    }
  }
}
