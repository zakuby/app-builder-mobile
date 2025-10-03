# App Builder Mobile

A configurable Flutter mobile application that provides a WebView-based experience with customizable tabs, colors, and URLs. The entire app behavior and appearance is controlled through JSON configuration files.

## Features

- **JSON-Driven Configuration**: Fully customizable app behavior through JSON config files
- **Multi-Tab Navigation**: Bottom navigation with multiple configurable WebView tabs
- **Custom Theming**: Configurable colors for primary, secondary, text, and tab states
- **WebView Integration**: Full-featured web content rendering with JavaScript support
- **State Preservation**: Tab states are preserved when switching between tabs
- **BLoC State Management**: Clean architecture using the BLoC pattern

## Quick Start

### Prerequisites

- Flutter SDK (^3.8.0)
- iOS/Android development environment setup
- Dart SDK

### Installation

```bash
# Clone the repository
git clone <repository-url>
cd app_builder_mobile

# Install dependencies
flutter pub get

# Generate freezed/json models
dart run build_runner build
```

### Running the App

```bash
# Run with test config
flutter run --dart-define-from-file=lib/config/test_config.json

# Run on specific device
flutter run --dart-define-from-file=lib/config/test_config.json -d <device-id>
```

### Building

```bash
# Build APK for Android
flutter build apk --dart-define-from-file=lib/config/test_config.json

# Build for iOS
flutter build ios --dart-define-from-file=lib/config/test_config.json
```

## Configuration

The app is configured through JSON files in `lib/config/`. The configuration uses a double-encoded JSON structure:

```json
{
  "config": "{\"app_name\":\"Your App\",\"app_icon\":\"icon_url\",\"styles\":{...},\"urls\":{...}}"
}
```

### Configuration Schema

```json
{
  "app_name": "String - App display name",
  "app_icon": "String - URL to app icon",
  "styles": {
    "color": {
      "primary": "String - Hex color (#RRGGBB)",
      "secondary": "String - Hex color",
      "text_color": "String - Hex color",
      "tab_select_color": "String - Hex color for selected tab",
      "tab_unselect_color": "String - Hex color for unselected tab"
    }
  },
  "urls": {
    "login": "String - Login page URL",
    "signup": "String - Signup page URL",
    "tabs": [
      {
        "title": "String - Tab title",
        "url": "String - Tab content URL"
      }
    ]
  }
}
```

## Project Structure

```
lib/
├── config/               # JSON configuration files
│   └── test_config.json
├── domain/              # Data models (freezed)
│   ├── config_model.dart
│   ├── config_model.freezed.dart
│   └── config_model.g.dart
├── presentation/        # UI layer
│   ├── my_home_page.dart
│   ├── my_home_cubit.dart
│   └── webview/
│       └── custom_web_view.dart
├── util/               # Utilities
│   ├── app_util.dart
│   └── app_colors.dart
└── main.dart           # App entry point
```

## Development

### Code Generation

The project uses `freezed` and `json_serializable` for model generation. After modifying models in `lib/domain/`, run:

```bash
# One-time generation
dart run build_runner build

# Watch mode for continuous generation
dart run build_runner watch

# Clean and rebuild (fixes conflicts)
dart run build_runner build --delete-conflicting-outputs
```

### Testing

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Run with coverage
flutter test --coverage
```

### Code Quality

```bash
# Run analyzer
flutter analyze

# Format code
dart format .
```

## Architecture

### State Management
- **BLoC Pattern** with `flutter_bloc` package
- `MyHomeCubit` manages bottom navigation tab index
- Stateless widgets for UI components

### Data Models
- **Freezed** for immutable data classes and union types
- **JSON Serialization** with snake_case naming convention
- Custom converters (e.g., `ColorConverter` for hex to Color)

### WebView Integration
- Uses `webview_flutter` package
- JavaScript enabled by default
- `IndexedStack` preserves WebView state when switching tabs

## Dependencies

### Production
- `flutter_bloc: ^9.1.1` - State management
- `bloc: ^9.0.1` - BLoC core
- `webview_flutter: ^4.13.0` - WebView support
- `freezed_annotation: ^3.1.0` - Code generation
- `json_annotation: ^4.9.0` - JSON serialization

### Development
- `build_runner: ^2.4.15` - Code generation runner
- `freezed: ^3.2.3` - Code generation
- `json_serializable: ^6.8.0` - JSON serialization
- `flutter_lints: ^6.0.0` - Linting rules

## License

This project is private and not published to pub.dev.

## Support

For issues or questions, please contact the development team.
