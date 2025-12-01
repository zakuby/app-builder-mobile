import 'package:app_builder_mobile/presentation/webview/default_web_view_message_handler.dart';
import 'package:flutter/material.dart';

/// Callback for showing toast messages
typedef ShowToastCallback = void Function(String message, String duration);

/// Message handler for HomePage WebViews
/// Extends DefaultWebViewMessageHandler with additional actions:
/// HIDE_BOTTOM_BAR, SHOW_BOTTOM_BAR, SHOW_NAVIGATION_BAR, HIDE_NAVIGATION_BAR, SHOW_TOAST
class HomeWebViewMessageHandler extends DefaultWebViewMessageHandler {
  final VoidCallback? onHideBottomBar;
  final VoidCallback? onShowBottomBar;
  final VoidCallback? onShowNavigationBar;
  final VoidCallback? onHideNavigationBar;
  final ShowToastCallback? onShowToast;

  HomeWebViewMessageHandler({
    super.onLogout,
    this.onHideBottomBar,
    this.onShowBottomBar,
    this.onShowNavigationBar,
    this.onHideNavigationBar,
    this.onShowToast,
  });

  @override
  Future<void> handleMessage(
    Map<String, dynamic> data,
    String? callbackId,
  ) async {
    final action = data['action'] as String?;

    debugPrint('HomeWebViewMessageHandler handling action: $action');

    switch (action) {
      case 'HIDE_BOTTOM_BAR':
        _handleHideBottomBar(callbackId);
        return;
      case 'SHOW_BOTTOM_BAR':
        _handleShowBottomBar(callbackId);
        return;
      case 'SHOW_NAVIGATION_BAR':
        _handleShowNavigationBar(callbackId);
        return;
      case 'HIDE_NAVIGATION_BAR':
        _handleHideNavigationBar(callbackId);
        return;
      case 'SHOW_TOAST':
        _handleShowToast(data, callbackId);
        return;
      default:
        // Delegate to parent handler for other actions
        await super.handleMessage(data, callbackId);
    }
  }

  /// Handle HIDE_BOTTOM_BAR action from web
  void _handleHideBottomBar(String? callbackId) {
    debugPrint('Hiding bottom bar');
    onHideBottomBar?.call();
    sendCallback(callbackId, true, 'Bottom bar hidden');
  }

  /// Handle SHOW_BOTTOM_BAR action from web
  void _handleShowBottomBar(String? callbackId) {
    debugPrint('Showing bottom bar');
    onShowBottomBar?.call();
    sendCallback(callbackId, true, 'Bottom bar shown');
  }

  /// Handle SHOW_NAVIGATION_BAR action from web
  void _handleShowNavigationBar(String? callbackId) {
    debugPrint('Showing navigation bar');
    onShowNavigationBar?.call();
    sendCallback(callbackId, true, 'Navigation bar shown');
  }

  /// Handle HIDE_NAVIGATION_BAR action from web
  void _handleHideNavigationBar(String? callbackId) {
    debugPrint('Hiding navigation bar');
    onHideNavigationBar?.call();
    sendCallback(callbackId, true, 'Navigation bar hidden');
  }

  /// Handle SHOW_TOAST action from web
  void _handleShowToast(Map<String, dynamic> data, String? callbackId) {
    final messageData = data['data'] as Map<String, dynamic>?;
    final message = messageData?['message'] as String? ?? '';
    final duration = messageData?['duration'] as String? ?? 'short';

    if (message.isEmpty) {
      sendCallback(callbackId, false, 'No message provided');
      return;
    }

    debugPrint('Showing toast: $message (duration: $duration)');
    onShowToast?.call(message, duration);
    sendCallback(callbackId, true, 'Toast shown');
  }
}
