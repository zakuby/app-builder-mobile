import 'package:app_builder_mobile/presentation/webview/default_web_view_message_handler.dart';
import 'package:flutter/material.dart';

/// Message handler for HomePage WebViews
/// Extends DefaultWebViewMessageHandler with additional actions:
/// HIDE_BOTTOM_BAR, SHOW_BOTTOM_BAR, SHOW_NAVIGATION_BAR, HIDE_NAVIGATION_BAR
class HomeWebViewMessageHandler extends DefaultWebViewMessageHandler {
  final VoidCallback? onHideBottomBar;
  final VoidCallback? onShowBottomBar;
  final VoidCallback? onShowNavigationBar;
  final VoidCallback? onHideNavigationBar;

  HomeWebViewMessageHandler({
    super.onLogout,
    this.onHideBottomBar,
    this.onShowBottomBar,
    this.onShowNavigationBar,
    this.onHideNavigationBar,
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
}
