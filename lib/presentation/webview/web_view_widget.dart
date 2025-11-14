// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';

/// Web-specific WebView implementation using IFrame
/// Only used when running on web platform
class WebIFrameWidget extends StatefulWidget {
  final String url;
  final Function(String)? onMessageReceived;

  const WebIFrameWidget({
    super.key,
    required this.url,
    this.onMessageReceived,
  });

  @override
  State<WebIFrameWidget> createState() => _WebIFrameWidgetState();
}

class _WebIFrameWidgetState extends State<WebIFrameWidget> {
  late html.IFrameElement _iframeElement;
  final String _viewType = 'iframe-${DateTime.now().millisecondsSinceEpoch}';

  @override
  void initState() {
    super.initState();
    _setupIFrame();
  }

  void _setupIFrame() {
    _iframeElement = html.IFrameElement()
      ..src = widget.url
      ..style.border = 'none'
      ..style.width = '100%'
      ..style.height = '100%'
      ..allow = 'camera; microphone; geolocation; payment';

    // Register the iframe element
    // ignore: undefined_prefixed_name
    ui_web.platformViewRegistry.registerViewFactory(
      _viewType,
      (int viewId) => _iframeElement,
    );

    // Listen for messages from iframe (if needed)
    if (widget.onMessageReceived != null) {
      html.window.onMessage.listen((event) {
        // Only handle messages from the iframe origin
        if (event.data != null) {
          widget.onMessageReceived?.call(event.data.toString());
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(
      viewType: _viewType,
    );
  }

  @override
  void dispose() {
    _iframeElement.remove();
    super.dispose();
  }
}
