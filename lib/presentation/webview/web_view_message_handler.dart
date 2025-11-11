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
      // Encode data as JSON string (for the 'data' field only)
      final dataJson = data != null ? json.encode(data) : 'null';
      final messageEscaped = message
          .replaceAll("'", "\\'")
          .replaceAll('\n', '\\n');

      // Construct JavaScript object directly
      final jsCode =
          '''
        (function() {
          try {
            if (typeof window.handleFlutterCallback === "function") {
              window.handleFlutterCallback("$callbackId", {
                success: $success,
                message: '$messageEscaped',
                data: $dataJson
              });
            }
          } catch (e) {
            console.error('Error in callback:', e);
          }
        })();
      ''';

      _controller!.runJavaScript(jsCode);
      debugPrint('Sent callback: $callbackId with success: $success');
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
