import 'package:app_builder_mobile/core/di/injection.dart';
import 'package:app_builder_mobile/data/datasources/device_info_datasource.dart';
import 'package:app_builder_mobile/domain/repositories/auth_repository.dart';
import 'package:app_builder_mobile/presentation/webview/web_view_message_handler.dart';
import 'package:app_builder_mobile/services/fcm_service.dart';
import 'package:app_builder_mobile/services/tts_service.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';

/// Default implementation of WebViewMessageHandler
/// Handles actions: SAVE_SECURE, GET_SECURE, DELETE_SECURE, LOGOUT, GET_DEVICE_INFO, GET_APP_VERSION, GENERATE_FCM_TOKEN, TTS_SPEAK, TTS_CANCEL, TTS_AWAIT_COMPLETION, TTS_GET_LANGUAGES, TTS_IS_LANGUAGE_AVAILABLE, TTS_IS_LANGUAGE_INSTALLED, TTS_OPEN_SETTINGS
///
/// TTS completion is handled via callbacks:
/// - TTS_AWAIT_COMPLETION: SDK sends this to wait for a specific ttsId to complete
/// - When TTS finishes, the stored callback is resolved with the completion status
class DefaultWebViewMessageHandler extends WebViewMessageHandler {
  final AuthRepository _authRepository = getIt<AuthRepository>();
  final DeviceInfoDataSource _deviceInfoDataSource =
      getIt<DeviceInfoDataSource>();
  final TTSService _ttsService = getIt<TTSService>();
  final VoidCallback? onLogout;

  /// Pending TTS completion callbacks: ttsId -> callbackId
  /// When TTS_AWAIT_COMPLETION is received, the callback is stored here
  /// and resolved when the corresponding ttsId completes
  final Map<String, String> _pendingTtsCallbacks = {};

  DefaultWebViewMessageHandler({this.onLogout}) {
    // Set up TTS completion callback to notify JavaScript when speech finishes
    _ttsService.setCompletionCallback(_onTtsCompleted);
  }

  /// Called when TTS speech completes - resolves any pending callbacks
  void _onTtsCompleted(String? ttsId, bool completed) {
    if (controller == null) {
      debugPrint('TTS completion: No WebViewController available');
      return;
    }

    if (ttsId == null) {
      debugPrint('TTS completion: No ttsId to report');
      return;
    }

    // Check if there's a pending callback for this ttsId
    final callbackId = _pendingTtsCallbacks.remove(ttsId);
    if (callbackId != null) {
      debugPrint('TTS completion: Resolving callback for ttsId: $ttsId, completed: $completed');
      sendCallback(callbackId, true, completed ? 'Speech completed' : 'Speech cancelled', {
        'ttsId': ttsId,
        'completed': completed,
      });
    } else {
      debugPrint('TTS completion: No pending callback for ttsId: $ttsId');
    }
  }

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
        case 'GENERATE_FCM_TOKEN':
          await _handleGenerateFcmToken(callbackId);
          break;
        case 'SHARE':
          await _handleShare(data, callbackId);
          break;
        case 'TTS_SPEAK':
          await _handleTtsSpeak(data, callbackId);
          break;
        case 'TTS_CANCEL':
          await _handleTtsCancel(callbackId);
          break;
        case 'TTS_AWAIT_COMPLETION':
          _handleTtsAwaitCompletion(data, callbackId);
          break;
        case 'TTS_GET_LANGUAGES':
          await _handleTtsGetLanguages(callbackId);
          break;
        case 'TTS_IS_LANGUAGE_AVAILABLE':
          await _handleTtsIsLanguageAvailable(data, callbackId);
          break;
        case 'TTS_IS_LANGUAGE_INSTALLED':
          await _handleTtsIsLanguageInstalled(data, callbackId);
          break;
        case 'TTS_OPEN_SETTINGS':
          await _handleTtsOpenSettings(callbackId);
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

      // Regenerate FCM token to invalidate the old one
      await FCMService().regenerateToken();
      debugPrint('FCM token regenerated after logout');

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

  /// Handle GENERATE_FCM_TOKEN action from web
  /// Returns the FCM token from secure storage
  Future<void> _handleGenerateFcmToken(String? callbackId) async {
    try {
      // First try to get token from secure storage
      String? token = await FCMService().getTokenFromSecureStorage();

      // If not in storage, get from FCMService memory
      token ??= FCMService().fcmToken;

      if (token == null) {
        sendCallback(callbackId, false, 'FCM token not available');
        return;
      }

      debugPrint('Retrieved FCM token: $token');

      sendCallback(
        callbackId,
        true,
        'FCM token retrieved successfully',
        {'token': token},
      );
    } catch (e) {
      debugPrint('Error handling GENERATE_FCM_TOKEN: $e');
      sendCallback(callbackId, false, 'Error retrieving FCM token: $e');
    }
  }

  /// Handle SHARE action from web
  /// Opens native share dialog with text and optional URL
  Future<void> _handleShare(
    Map<String, dynamic> message,
    String? callbackId,
  ) async {
    try {
      final messageData = message['data'] as Map<String, dynamic>?;
      if (messageData == null) {
        sendCallback(callbackId, false, 'No data provided');
        return;
      }

      final text = messageData['text'] as String? ?? '';
      final url = messageData['url'] as String? ?? '';

      // Combine text and URL for sharing
      final shareContent = url.isNotEmpty ? '$text\n$url' : text;

      if (shareContent.isEmpty) {
        sendCallback(callbackId, false, 'No content to share');
        return;
      }

      debugPrint('Sharing content: $shareContent');

      final result = await Share.share(shareContent);

      // Check if share was successful
      if (result.status == ShareResultStatus.success) {
        sendCallback(callbackId, true, 'Content shared successfully', {
          'shared': true,
        });
      } else if (result.status == ShareResultStatus.dismissed) {
        sendCallback(callbackId, true, 'Share dismissed', {
          'shared': false,
        });
      } else {
        sendCallback(callbackId, false, 'Share failed');
      }
    } catch (e) {
      debugPrint('Error handling SHARE: $e');
      sendCallback(callbackId, false, 'Error sharing: $e');
    }
  }

  /// Handle TTS_SPEAK action from web
  /// Speaks the provided text using text-to-speech
  Future<void> _handleTtsSpeak(
    Map<String, dynamic> message,
    String? callbackId,
  ) async {
    try {
      final messageData = message['data'] as Map<String, dynamic>?;
      if (messageData == null) {
        sendCallback(callbackId, false, 'No data provided');
        return;
      }

      final text = messageData['text'] as String?;

      if (text == null || text.isEmpty) {
        sendCallback(callbackId, false, 'No text provided');
        return;
      }

      // Optional: ttsId for tracking, language, rate, pitch, volume
      final ttsId = messageData['ttsId'] as String?;
      final language = messageData['language'] as String?;
      final rate = messageData['rate'] as num?;
      final pitch = messageData['pitch'] as num?;
      final volume = messageData['volume'] as num?;

      // Apply optional settings
      if (language != null) {
        await _ttsService.setLanguage(language);
      }
      if (rate != null) {
        await _ttsService.setSpeechRate(rate.toDouble());
      }
      if (pitch != null) {
        await _ttsService.setPitch(pitch.toDouble());
      }
      if (volume != null) {
        await _ttsService.setVolume(volume.toDouble());
      }

      final success = await _ttsService.speak(text, ttsId: ttsId);
      debugPrint('TTS speak result: $success for text: "$text", ttsId: $ttsId');

      if (success) {
        sendCallback(callbackId, true, 'Speech started successfully', {
          'ttsId': ttsId,
        });
      } else {
        sendCallback(callbackId, false, 'Failed to start speech');
      }
    } catch (e) {
      debugPrint('Error handling TTS_SPEAK: $e');
      sendCallback(callbackId, false, 'Error speaking: $e');
    }
  }

  /// Handle TTS_CANCEL action from web
  /// Stops any ongoing text-to-speech and clears pending callbacks
  Future<void> _handleTtsCancel(String? callbackId) async {
    try {
      // Clear all pending callbacks since we're cancelling
      _pendingTtsCallbacks.clear();
      debugPrint('TTS cancel: Cleared pending callbacks');

      final success = await _ttsService.stop();
      debugPrint('TTS cancel result: $success');

      if (success) {
        sendCallback(callbackId, true, 'Speech cancelled successfully');
      } else {
        sendCallback(callbackId, false, 'Failed to cancel speech');
      }
    } catch (e) {
      debugPrint('Error handling TTS_CANCEL: $e');
      sendCallback(callbackId, false, 'Error cancelling speech: $e');
    }
  }

  /// Handle TTS_AWAIT_COMPLETION action from web
  /// Stores the callback to be resolved when the specified ttsId completes
  void _handleTtsAwaitCompletion(
    Map<String, dynamic> message,
    String? callbackId,
  ) {
    try {
      final messageData = message['data'] as Map<String, dynamic>?;
      if (messageData == null) {
        sendCallback(callbackId, false, 'No data provided');
        return;
      }

      final ttsId = messageData['ttsId'] as String?;

      if (ttsId == null || ttsId.isEmpty) {
        sendCallback(callbackId, false, 'No ttsId provided');
        return;
      }

      if (callbackId == null) {
        debugPrint('TTS await completion: No callbackId provided');
        return;
      }

      // Store the callback to be resolved when this ttsId completes
      _pendingTtsCallbacks[ttsId] = callbackId;
      debugPrint('TTS await completion: Stored callback for ttsId: $ttsId, callbackId: $callbackId');

      // Don't send callback yet - it will be sent when TTS completes via _onTtsCompleted
    } catch (e) {
      debugPrint('Error handling TTS_AWAIT_COMPLETION: $e');
      sendCallback(callbackId, false, 'Error: $e');
    }
  }

  /// Handle TTS_GET_LANGUAGES action from web
  /// Returns the list of available TTS languages installed on the device
  Future<void> _handleTtsGetLanguages(String? callbackId) async {
    try {
      final languages = await _ttsService.getLanguages();
      debugPrint('TTS available languages: $languages');

      // Convert to List<String> for consistent typing
      final languageList = languages.map((e) => e.toString()).toList();

      sendCallback(
        callbackId,
        true,
        'Languages retrieved successfully',
        {'languages': languageList},
      );
    } catch (e) {
      debugPrint('Error handling TTS_GET_LANGUAGES: $e');
      sendCallback(callbackId, false, 'Error retrieving languages: $e');
    }
  }

  /// Handle TTS_IS_LANGUAGE_AVAILABLE action from web
  /// Checks if a language is available for TTS (cross-platform)
  Future<void> _handleTtsIsLanguageAvailable(
    Map<String, dynamic> message,
    String? callbackId,
  ) async {
    try {
      final messageData = message['data'] as Map<String, dynamic>?;
      if (messageData == null) {
        sendCallback(callbackId, false, 'No data provided');
        return;
      }

      final language = messageData['language'] as String?;

      if (language == null || language.isEmpty) {
        sendCallback(callbackId, false, 'No language provided');
        return;
      }

      final isAvailable = await _ttsService.isLanguageAvailable(language);
      debugPrint('TTS isLanguageAvailable($language): $isAvailable');

      sendCallback(
        callbackId,
        true,
        isAvailable ? 'Language is available' : 'Language is not available',
        {'language': language, 'available': isAvailable},
      );
    } catch (e) {
      debugPrint('Error handling TTS_IS_LANGUAGE_AVAILABLE: $e');
      sendCallback(callbackId, false, 'Error checking language availability: $e');
    }
  }

  /// Handle TTS_IS_LANGUAGE_INSTALLED action from web
  /// Checks if a language is installed on the device (Android only)
  Future<void> _handleTtsIsLanguageInstalled(
    Map<String, dynamic> message,
    String? callbackId,
  ) async {
    try {
      final messageData = message['data'] as Map<String, dynamic>?;
      if (messageData == null) {
        sendCallback(callbackId, false, 'No data provided');
        return;
      }

      final language = messageData['language'] as String?;

      if (language == null || language.isEmpty) {
        sendCallback(callbackId, false, 'No language provided');
        return;
      }

      final isInstalled = await _ttsService.isLanguageInstalled(language);
      debugPrint('TTS isLanguageInstalled($language): $isInstalled');

      sendCallback(
        callbackId,
        true,
        isInstalled ? 'Language is installed' : 'Language is not installed',
        {'language': language, 'installed': isInstalled},
      );
    } catch (e) {
      debugPrint('Error handling TTS_IS_LANGUAGE_INSTALLED: $e');
      sendCallback(callbackId, false, 'Error checking language installation: $e');
    }
  }

  /// Handle TTS_OPEN_SETTINGS action from web
  /// Opens the device TTS settings so user can install languages
  Future<void> _handleTtsOpenSettings(String? callbackId) async {
    try {
      await AppSettings.openAppSettings(type: AppSettingsType.settings);
      debugPrint('TTS settings opened');

      sendCallback(
        callbackId,
        true,
        'Settings opened successfully',
      );
    } catch (e) {
      debugPrint('Error handling TTS_OPEN_SETTINGS: $e');
      sendCallback(callbackId, false, 'Error opening settings: $e');
    }
  }
}
