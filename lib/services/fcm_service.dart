import 'dart:io';
import 'package:app_builder_mobile/core/di/injection.dart';
import 'package:app_builder_mobile/domain/repositories/auth_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';

/// Background message handler - must be top-level function
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('Handling background message: ${message.messageId}');
  debugPrint('Title: ${message.notification?.title}');
  debugPrint('Body: ${message.notification?.body}');
}

/// Key used to store FCM token in secure storage
const String _fcmTokenStorageKey = 'fcm_token';

class FCMService {
  static final FCMService _instance = FCMService._internal();
  factory FCMService() => _instance;
  FCMService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  /// Initialize FCM and request permissions
  Future<void> initialize() async {
    try {
      // Request permission for iOS
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        debugPrint('User granted notification permission');
      } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
        debugPrint('User granted provisional notification permission');
      } else {
        debugPrint('User declined notification permission');
        return;
      }

      // Initialize local notifications
      await _initializeLocalNotifications();

      // Get FCM token and save to secure storage
      _fcmToken = await _firebaseMessaging.getToken();
      debugPrint('FCM Token: $_fcmToken');
      await _saveTokenToSecureStorage(_fcmToken);

      // Listen to token refresh
      _firebaseMessaging.onTokenRefresh.listen((newToken) async {
        _fcmToken = newToken;
        debugPrint('FCM Token refreshed: $newToken');
        await _saveTokenToSecureStorage(newToken);
      });

      // Configure foreground notification presentation options for iOS
      await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Handle notification taps when app is in background
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

      // Check if app was opened from a notification
      RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        _handleMessageOpenedApp(initialMessage);
      }

      debugPrint('FCM Service initialized successfully');
    } catch (e, stackTrace) {
      debugPrint('Error initializing FCM: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  /// Initialize local notifications for Android
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create notification channel for Android
    if (Platform.isAndroid) {
      const channel = AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications',
        importance: Importance.high,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }

  /// Handle foreground messages
  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('Received foreground message: ${message.messageId}');
    debugPrint('Title: ${message.notification?.title}');
    debugPrint('Body: ${message.notification?.body}');
    debugPrint('Data: ${message.data}');

    // Show local notification when app is in foreground
    _showLocalNotification(message);
  }

  /// Show local notification
  Future<void> _showLocalNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription: 'This channel is used for important notifications',
            importance: Importance.high,
            priority: Priority.high,
            icon: android?.smallIcon ?? '@mipmap/ic_launcher',
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: message.data.toString(),
      );
    }
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('Notification tapped: ${response.payload}');
    // TODO: Navigate to specific screen based on payload
  }

  /// Handle message when app is opened from background
  void _handleMessageOpenedApp(RemoteMessage message) {
    debugPrint('App opened from notification: ${message.messageId}');
    debugPrint('Data: ${message.data}');
    // TODO: Navigate to specific screen based on data
  }

  /// Subscribe to a topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      debugPrint('Subscribed to topic: $topic');
    } catch (e) {
      debugPrint('Error subscribing to topic: $e');
    }
  }

  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      debugPrint('Unsubscribed from topic: $topic');
    } catch (e) {
      debugPrint('Error unsubscribing from topic: $e');
    }
  }

  /// Delete FCM token
  Future<void> deleteToken() async {
    try {
      await _firebaseMessaging.deleteToken();
      _fcmToken = null;
      await _deleteTokenFromSecureStorage();
      debugPrint('FCM token deleted');
    } catch (e) {
      debugPrint('Error deleting FCM token: $e');
    }
  }

  /// Regenerate FCM token (delete old token and get new one)
  /// Used when user logs out to invalidate the current token
  Future<String?> regenerateToken() async {
    try {
      // Delete the old token
      await _firebaseMessaging.deleteToken();
      await _deleteTokenFromSecureStorage();
      debugPrint('Old FCM token deleted for regeneration');

      // Get a new token
      _fcmToken = await _firebaseMessaging.getToken();
      debugPrint('New FCM Token generated: $_fcmToken');
      await _saveTokenToSecureStorage(_fcmToken);

      return _fcmToken;
    } catch (e) {
      debugPrint('Error regenerating FCM token: $e');
      return null;
    }
  }

  /// Get FCM token from secure storage
  Future<String?> getTokenFromSecureStorage() async {
    try {
      final authRepository = getIt<AuthRepository>();
      final token = await authRepository.getSecure(_fcmTokenStorageKey);
      return token as String?;
    } catch (e) {
      debugPrint('Error getting FCM token from secure storage: $e');
      return null;
    }
  }

  /// Save FCM token to secure storage
  Future<void> _saveTokenToSecureStorage(String? token) async {
    if (token == null) return;
    try {
      final authRepository = getIt<AuthRepository>();
      await authRepository.saveSecure(_fcmTokenStorageKey, token);
      debugPrint('FCM token saved to secure storage');
    } catch (e) {
      debugPrint('Error saving FCM token to secure storage: $e');
    }
  }

  /// Delete FCM token from secure storage
  Future<void> _deleteTokenFromSecureStorage() async {
    try {
      final authRepository = getIt<AuthRepository>();
      await authRepository.deleteSecure(_fcmTokenStorageKey);
      debugPrint('FCM token deleted from secure storage');
    } catch (e) {
      debugPrint('Error deleting FCM token from secure storage: $e');
    }
  }
}
