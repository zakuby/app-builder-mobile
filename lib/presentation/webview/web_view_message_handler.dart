import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Abstract interface for handling JavaScript channel messages from WebView
/// Implement this to create custom message handlers for different use cases
abstract class WebViewMessageHandler {
  WebViewController? _controller;

  /// Set the WebViewController to enable sending callbacks
  void setController(WebViewController controller) {
    _controller = controller;
  }

  /// Get the WebViewController
  WebViewController? get controller => _controller;

  /// Handle incoming message from web app via JavaScript channel
  /// Override this method to implement custom message handling logic
  Future<void> handleMessage(Map<String, dynamic> data, String? callbackId);

  /// Send callback response to web app via handleFlutterCallback
  void sendCallback(
    String? callbackId,
    bool success,
    String message, [
    dynamic data,
  ]) {
    if (callbackId == null || _controller == null) return;

    try {
      // Build response object
      final response = {
        'success': success,
        'message': message,
        if (data != null) 'data': data,
      };

      final jsonResponse = json.encode(response);

      // Escape the JSON string for safe embedding in JavaScript
      final escapedJson = jsonResponse
          .replaceAll('\\', '\\\\') // Escape backslashes first
          .replaceAll("'", "\\'") // Escape single quotes
          .replaceAll('\n', '\\n') // Escape newlines
          .replaceAll('\r', '\\r'); // Escape carriage returns

      final jsCode =
          '''
        (function() {
          try {
            var parsedData = JSON.parse('$escapedJson');
            if (typeof window.handleFlutterCallback === "function") {
              window.handleFlutterCallback("$callbackId", parsedData);
            }
          } catch (e) {
            console.error('Error parsing callback data:', e, 'JSON was:', '$escapedJson');
          }
        })();
      ''';

      _controller!.runJavaScript(jsCode);
      debugPrint(
        'Sent callback: $callbackId with success: $success $jsonResponse',
      );
    } catch (e) {
      debugPrint('Error sending callback: $e');
    }
  }

  /// Helper method to parse incoming JavaScript message
  /// Returns null if message cannot be parsed
  Map<String, dynamic>? parseMessage(String messageString) {
    try {
      final data = json.decode(messageString);
      if (data is Map<String, dynamic>) {
        return data;
      }
      return null;
    } catch (e) {
      debugPrint('Error parsing message: $e');
      return null;
    }
  }
}
