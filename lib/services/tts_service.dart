import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Service for Text-to-Speech functionality
/// Provides speak and cancel capabilities for WebView integration
class TTSService {
  static final TTSService _instance = TTSService._internal();
  factory TTSService() => _instance;
  TTSService._internal();

  FlutterTts? _flutterTts;
  bool _isInitialized = false;
  bool _isSpeaking = false;

  /// Initialize the TTS engine
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _flutterTts = FlutterTts();

      // Set default configuration
      await _flutterTts!.setLanguage('en-US');
      await _flutterTts!.setSpeechRate(0.5);
      await _flutterTts!.setVolume(1.0);
      await _flutterTts!.setPitch(1.0);

      // Set up completion handler
      _flutterTts!.setCompletionHandler(() {
        _isSpeaking = false;
        debugPrint('TTS: Speech completed');
      });

      // Set up error handler
      _flutterTts!.setErrorHandler((message) {
        _isSpeaking = false;
        debugPrint('TTS Error: $message');
      });

      // Set up start handler
      _flutterTts!.setStartHandler(() {
        _isSpeaking = true;
        debugPrint('TTS: Speech started');
      });

      _isInitialized = true;
      debugPrint('TTS Service initialized successfully');
    } catch (e) {
      debugPrint('TTS Service initialization error: $e');
      rethrow;
    }
  }

  /// Speak the given text
  /// Returns true if speech started successfully
  Future<bool> speak(String text) async {
    if (!_isInitialized) {
      await initialize();
    }

    if (text.isEmpty) {
      debugPrint('TTS: Empty text provided');
      return false;
    }

    try {
      // Stop any ongoing speech before starting new one
      if (_isSpeaking) {
        await stop();
      }

      final result = await _flutterTts!.speak(text);
      debugPrint('TTS: Speaking text: "$text", result: $result');
      return result == 1;
    } catch (e) {
      debugPrint('TTS speak error: $e');
      return false;
    }
  }

  /// Stop any ongoing speech
  Future<bool> stop() async {
    if (!_isInitialized || _flutterTts == null) {
      return true;
    }

    try {
      final result = await _flutterTts!.stop();
      _isSpeaking = false;
      debugPrint('TTS: Speech stopped, result: $result');
      return result == 1;
    } catch (e) {
      debugPrint('TTS stop error: $e');
      return false;
    }
  }

  /// Check if TTS is currently speaking
  bool get isSpeaking => _isSpeaking;

  /// Set the language for TTS
  Future<void> setLanguage(String language) async {
    if (!_isInitialized) {
      await initialize();
    }
    await _flutterTts!.setLanguage(language);
  }

  /// Set the speech rate (0.0 to 1.0)
  Future<void> setSpeechRate(double rate) async {
    if (!_isInitialized) {
      await initialize();
    }
    await _flutterTts!.setSpeechRate(rate);
  }

  /// Set the volume (0.0 to 1.0)
  Future<void> setVolume(double volume) async {
    if (!_isInitialized) {
      await initialize();
    }
    await _flutterTts!.setVolume(volume);
  }

  /// Set the pitch (0.5 to 2.0)
  Future<void> setPitch(double pitch) async {
    if (!_isInitialized) {
      await initialize();
    }
    await _flutterTts!.setPitch(pitch);
  }

  /// Get available languages
  Future<List<dynamic>> getLanguages() async {
    if (!_isInitialized) {
      await initialize();
    }
    return await _flutterTts!.getLanguages;
  }

  /// Check if a language is available (cross-platform)
  /// Returns true if the language can be used for TTS
  Future<bool> isLanguageAvailable(String language) async {
    if (!_isInitialized) {
      await initialize();
    }
    try {
      final result = await _flutterTts!.isLanguageAvailable(language);
      debugPrint('TTS: isLanguageAvailable($language) = $result');
      // Result can be 1 (available) or 0 (not available) on some platforms
      return result == true || result == 1;
    } catch (e) {
      debugPrint('TTS isLanguageAvailable error: $e');
      return false;
    }
  }

  /// Check if a language is installed (Android only)
  /// Returns true if the language is installed on the device
  Future<bool> isLanguageInstalled(String language) async {
    if (!_isInitialized) {
      await initialize();
    }
    try {
      final result = await _flutterTts!.isLanguageInstalled(language);
      debugPrint('TTS: isLanguageInstalled($language) = $result');
      return result == true || result == 1;
    } catch (e) {
      debugPrint('TTS isLanguageInstalled error: $e');
      return false;
    }
  }

  /// Dispose the TTS engine
  Future<void> dispose() async {
    if (_flutterTts != null) {
      await _flutterTts!.stop();
      _isInitialized = false;
      _isSpeaking = false;
      debugPrint('TTS Service disposed');
    }
  }
}
