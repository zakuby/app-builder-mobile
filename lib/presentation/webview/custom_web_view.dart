import 'package:app_builder_mobile/presentation/webview/web_view_message_handler.dart';
import 'package:app_builder_mobile/util/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Reusable WebView widget with JavaScript channel support
///
/// Uses a message handler pattern to process JavaScript messages from the web app.
/// By default, uses [DefaultWebViewMessageHandler] for auth operations.
///
/// Example usage with default handler:
/// ```dart
/// CustomWebView(url: 'https://example.com')
/// ```
///
/// Example usage with custom handler:
/// ```dart
/// CustomWebView(
///   url: 'https://example.com',
///   messageHandler: MyCustomMessageHandler(),
/// )
/// ```
class CustomWebView extends StatefulWidget {
  final String url;
  final WebViewMessageHandler messageHandler;
  final String channelName;
  final void Function(bool canGoBack)? onNavigationStateChanged;
  final void Function(String? title)? onTitleChanged;

  const CustomWebView({
    super.key,
    required this.url,
    required this.messageHandler,
    this.channelName = 'AppBuilderChannel',
    this.onNavigationStateChanged,
    this.onTitleChanged,
  });

  @override
  State<CustomWebView> createState() => CustomWebViewState();
}

class CustomWebViewState extends State<CustomWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;

  /// Expose controller for external navigation control
  WebViewController get controller => _controller;

  @override
  void initState() {
    super.initState();
    // Use provided handler or keep it null (will be set by parent if needed)
    _initializeWebView();
  }

  /// Go back in WebView history
  Future<void> goBack() async {
    if (await _controller.canGoBack()) {
      await _controller.goBack();
    }
  }

  /// Initialize WebView with JavaScript channel
  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setOnConsoleMessage((message) {
        debugPrint('[WebView Console] ${message.level.name}: ${message.message}');
      })
      ..addJavaScriptChannel(
        widget.channelName,
        onMessageReceived: _handleMessageFromWeb,
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            if (mounted) {
              setState(() {
                _isLoading = true;
              });
            }
          },
          onPageFinished: (url) async {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }

            // Check navigation state
            final canGoBack = await _controller.canGoBack();
            widget.onNavigationStateChanged?.call(canGoBack);

            // Get page title
            final title = await _controller.getTitle();
            widget.onTitleChanged?.call(title);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));

    // Provide controller to message handler for callbacks
    widget.messageHandler.setController(_controller);
  }

  /// Handle messages from the web app via JavaScript channel
  /// Delegates to the message handler for processing
  void _handleMessageFromWeb(JavaScriptMessage message) async {
    try {
      debugPrint('Message from web: ${message.message}');

      final data = widget.messageHandler.parseMessage(message.message);
      if (data == null) {
        debugPrint('Failed to parse message from web');
        return;
      }

      final callbackId = data['callbackId'] as String?;
      await widget.messageHandler.handleMessage(data, callbackId);
    } catch (e) {
      debugPrint('Error handling message from web: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (_isLoading)
          Container(
            color: AppColors.primary,
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.secondary,
              ),
            ),
          ),
      ],
    );
  }
}
