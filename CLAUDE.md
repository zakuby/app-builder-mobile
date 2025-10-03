# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter mobile application called "App Builder Mobile" that provides a configurable WebView-based app with customizable tabs, colors, and URLs. The app is driven by JSON configuration files that control its appearance and behavior.

## Development Commands

### Running the App
```bash
# Run with development config
flutter run --dart-define-from-file=lib/config/development.json

# Build APK for Android
flutter build apk --dart-define-from-file=lib/config/development.json

# Build iOS
flutter build ios --dart-define-from-file=lib/config/development.json
```

### Code Generation
The project uses `freezed` and `json_serializable` for model generation:
```bash
# Generate model files (*.freezed.dart, *.g.dart)
dart run build_runner build

# Watch mode for continuous generation
dart run build_runner watch

# Clean and rebuild
dart run build_runner build --delete-conflicting-outputs
```

### Testing & Quality
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Run analyzer
flutter analyze
```

### Dependency Management
```bash
# Get dependencies
flutter pub get

# Upgrade dependencies
flutter pub upgrade
```

## Architecture

### Configuration System
The app uses a unique configuration approach where JSON config is passed via compile-time constants:
- Configuration files are in `lib/config/` (e.g., `development.json`)
- Configs are passed using `--dart-define-from-file` flag
- `AppUtil.config` (in `lib/util/app_util.dart`) parses the config from the `config` environment variable
- The config is a double-encoded JSON string (JSON inside JSON)

### State Management
- Uses **BLoC pattern** via `flutter_bloc` and `bloc` packages
- Main cubit: `MyHomeCubit` manages bottom navigation tab index
- State is an integer representing the currently selected tab

### Domain Models
Models are in `lib/domain/` and use:
- **Freezed** for immutable data classes and union types
- **JSON serialization** with snake_case field naming
- Custom `ColorConverter` for hex string ↔ Color conversion

Key models:
- `ConfigModel`: Root configuration (app_name, app_icon, styles, urls)
- `Styles` / `StyleColors`: Theming (primary, secondary, text colors, etc.)
- `Urls`: Login, signup, and tab URLs
- `TabItem`: Individual tab configuration (title, url)

### UI Structure
- `lib/presentation/` contains all UI code
- `MyHomePage`: Main scaffold with `IndexedStack` for tab navigation
- `CustomWebView`: WebView wrapper with JavaScript enabled
- `BottomNavigationBar` for tab switching
- Uses `AppColors` utility for centralized color access

### Code Organization
```
lib/
├── config/           # JSON configuration files
├── domain/           # Data models (freezed)
├── presentation/     # UI layer
│   ├── webview/      # WebView widgets
│   └── *_cubit.dart  # BLoC cubits
├── util/             # Utilities (colors, app config)
└── main.dart         # App entry point
```

## Important Notes

- Always regenerate freezed/json files after modifying models in `lib/domain/`
- The app expects config JSON to be double-encoded (string inside the JSON)
- WebViews are kept in memory using `IndexedStack` to preserve state when switching tabs
- Configuration structure supports customizable colors, URLs, and tab layouts
