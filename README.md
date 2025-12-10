# App Builder Mobile

A configurable Flutter mobile application built with Clean Architecture that provides a WebView-based experience with customizable tabs, colors, and URLs. The entire app behavior and appearance is controlled through JSON configuration files.

## Features

- **JSON-Driven Configuration**: Fully customizable app behavior through JSON config files
- **Multi-Tab Navigation**: Bottom navigation with multiple configurable WebView tabs
- **Custom Theming**: Configurable colors for primary, secondary, text, and tab states
- **WebView Integration**: Full-featured web content rendering with JavaScript bridge
- **Secure Storage**: Encrypted data storage using FlutterSecureStorage
- **State Preservation**: Tab states are preserved when switching between tabs
- **Clean Architecture**: Separation of concerns with Data, Domain, and Presentation layers
- **BLoC State Management**: Type-safe state management using Cubit pattern
- **Pluggable Message Handlers**: Extensible WebView JavaScript bridge with custom handlers

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
dart run build_runner build --delete-conflicting-outputs
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
├── config/                      # JSON configuration files
│   └── test_config.json
├── core/                        # Core functionality
│   └── di/
│       └── injection.dart       # Dependency injection setup (GetIt)
├── data/                        # Data layer
│   ├── datasources/
│   │   └── auth_local_datasource.dart    # Secure storage operations
│   └── repositories/
│       └── auth_repository_impl.dart     # Repository implementations
├── domain/                      # Domain layer
│   ├── repositories/
│   │   └── auth_repository.dart          # Repository interfaces
│   ├── config_model.dart                 # Configuration models
│   ├── config_model.freezed.dart
│   └── config_model.g.dart
├── presentation/                # Presentation layer (UI + BLoC)
│   ├── auth/                    # Auth feature
│   │   ├── cubit/
│   │   │   ├── auth_cubit.dart
│   │   │   ├── auth_state.dart
│   │   │   └── auth_state.freezed.dart
│   │   └── auth_page.dart
│   ├── home/                    # Home feature
│   │   ├── cubit/
│   │   │   └── home_cubit.dart
│   │   └── home_page.dart
│   └── webview/                 # WebView feature
│       ├── custom_web_view.dart
│       ├── web_view_message_handler.dart
│       └── default_web_view_message_handler.dart
├── util/                        # Utilities
│   ├── app_util.dart
│   └── app_colors.dart
└── main.dart                    # App entry point
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

This project follows **Clean Architecture** principles with clear separation of concerns:

### Layer Structure

#### Core Layer (`lib/core/`)
- **Dependency Injection**: GetIt setup for singleton management
  - `injection.dart`: Registers all dependencies (repositories, data sources)
  - Initialized at app startup before widget tree is built

#### Data Layer (`lib/data/`)
- **DataSources**: Handle direct interactions with platform APIs
  - `AuthLocalDataSource`: Manages FlutterSecureStorage operations
- **Repositories**: Implement domain repository interfaces
  - `AuthRepositoryImpl`: Bridges data sources and domain layer

#### Domain Layer (`lib/domain/`)
- **Repository Interfaces**: Define contracts for data operations
  - `AuthRepository`: Authentication and secure storage interface
- **Models**: Business entities with freezed + JSON serialization
  - `ConfigModel`, `Styles`, `TabItem`, etc.

#### Presentation Layer (`lib/presentation/`)
Organized by feature, each containing:
- **Cubits**: State management (BLoC pattern)
  - `AuthCubit`: Authentication state management
  - `HomeCubit`: Tab navigation state management
- **Pages**: UI components
  - Feature-based folder structure (`auth/`, `home/`, `webview/`)

### Dependency Injection

Using **GetIt** for singleton management:
- AuthRepository is registered as a lazy singleton
- Same instance shared across the entire app
- Injected into Cubits and message handlers via `getIt<AuthRepository>()`

### State Management
- **BLoC Pattern** with `flutter_bloc` package
- **Freezed** for type-safe, immutable states
- Cubits emit states based on business logic

### WebView Architecture
- **Message Handler Pattern**: Pluggable JavaScript bridge handlers
  - `WebViewMessageHandler`: Abstract interface
  - `DefaultWebViewMessageHandler`: Auth operations implementation
  - Extensible for custom JavaScript actions
- **JavaScript Channel**: Bi-directional communication with web content
- **IndexedStack**: Preserves WebView state when switching tabs

### Data Models
- **Freezed** for immutable data classes and union types
- **JSON Serialization** with snake_case naming convention
- Custom converters (e.g., `ColorConverter` for hex to Color)

## WebView JavaScript Bridge

### Core Components

1. **`WebViewMessageHandler`** - Abstract interface for handling JavaScript messages
2. **`DefaultWebViewMessageHandler`** - Default implementation for auth operations
3. **`CustomWebView`** - Reusable WebView widget with message handler injection

### Usage Examples

#### Basic Usage with Default Handler

```dart
import 'package:app_builder_mobile/presentation/webview/custom_web_view.dart';
import 'package:app_builder_mobile/presentation/webview/default_web_view_message_handler.dart';

// Use WebView with default handler
// Repository is automatically injected via GetIt internally
CustomWebView(
  url: 'https://example.com',
  messageHandler: DefaultWebViewMessageHandler(),
)
```

Default handler supports:
- `SAVE_SECURE` - Save data to encrypted storage
- `GET_SECURE` - Retrieve data from encrypted storage
- `DELETE_SECURE` - Delete data from encrypted storage
- `LOGOUT` - Clear user data and logout
- `GET_DEVICE_INFO` - Get device information (model, manufacturer, OS version, platform)
- `GET_APP_VERSION` - Get app version and build number
- `GENERATE_FCM_TOKEN` - Get Firebase Cloud Messaging token
- `SHARE` - Open native share dialog
- `TTS_SPEAK` - Speak text using text-to-speech
- `TTS_CANCEL` - Cancel ongoing speech
- `TTS_GET_LANGUAGES` - Get list of installed TTS languages
- `TTS_IS_LANGUAGE_AVAILABLE` - Check if a language is available (cross-platform)
- `TTS_IS_LANGUAGE_INSTALLED` - Check if a language is installed (Android only)
- `TTS_OPEN_SETTINGS` - Open device settings for TTS language installation

#### Custom Message Handler

Create your own handler for custom JavaScript actions:

```dart
import 'package:app_builder_mobile/presentation/webview/web_view_message_handler.dart';

class MyCustomMessageHandler extends WebViewMessageHandler {
  @override
  Future<void> handleMessage(Map<String, dynamic> data, String? callbackId) async {
    final action = data['action'] as String?;

    switch (action) {
      case 'SHARE_CONTENT':
        await _handleShare(data, callbackId);
        break;
      default:
        sendCallback(callbackId, false, 'Unknown action: $action');
    }
  }

  Future<void> _handleShare(Map<String, dynamic> data, String? callbackId) async {
    // Your custom logic
    sendCallback(callbackId, true, 'Content shared successfully');
  }
}
```

### JavaScript Integration

From your web app, communicate with Flutter using the JavaScript channel:

```javascript
// Save data securely
window.AppBuilderChannel.postMessage(JSON.stringify({
  action: 'SAVE_SECURE',
  callbackId: 'unique-callback-id',
  data: {
    key: 'user_token',
    value: 'abc123'
  }
}));

// Get data securely
window.AppBuilderChannel.postMessage(JSON.stringify({
  action: 'GET_SECURE',
  callbackId: 'unique-callback-id',
  data: {
    key: 'user_token'
  }
}));

// Get device information
window.AppBuilderChannel.postMessage(JSON.stringify({
  action: 'GET_DEVICE_INFO',
  callbackId: 'device-info-callback'
}));

// Handle callback from Flutter
window.handleFlutterCallback = function(callbackId, response) {
  console.log('Response:', response);
  // response: { success: boolean, message: string, data?: any }

  // For GET_DEVICE_INFO, data will contain:
  // {
  //   model: 'SM-G991B',
  //   manufacturer: 'Samsung',
  //   osVersion: 'Android 13',
  //   platform: 'android'
  // }
};
```

## Dependencies

### Production
- `flutter_bloc: ^9.1.1` - State management
- `bloc: ^9.0.1` - BLoC core
- `webview_flutter: ^4.13.0` - WebView support
- `flutter_secure_storage: ^9.2.2` - Encrypted storage
- `get_it: ^8.0.2` - Dependency injection / service locator
- `device_info_plus: ^11.1.1` - Device information
- `package_info_plus: ^8.1.2` - App version information
- `freezed_annotation: ^3.1.0` - Code generation annotations
- `json_annotation: ^4.9.0` - JSON serialization annotations
- `collection: ^1.19.1` - Collection utilities
- `cupertino_icons: ^1.0.8` - iOS-style icons
- `firebase_core: ^3.10.1` - Firebase core SDK
- `firebase_messaging: ^15.2.0` - Firebase Cloud Messaging
- `flutter_local_notifications: ^18.0.1` - Local notifications
- `share_plus: ^10.1.4` - Native share dialog
- `flutter_tts: ^4.2.0` - Text-to-speech
- `app_settings: ^5.1.1` - Open device settings

### Development
- `build_runner: ^2.4.15` - Code generation runner
- `freezed: ^3.2.3` - Code generation for models and states
- `json_serializable: ^6.8.0` - JSON serialization code gen
- `flutter_lints: ^6.0.0` - Linting rules
- `flutter_launcher_icons: ^0.14.4` - App icon generation

## Common Tasks

### Adding a New Feature

1. Create feature folder in `lib/presentation/your_feature/`
2. Add cubit for state management: `cubit/your_feature_cubit.dart`
3. Define states using freezed: `cubit/your_feature_state.dart`
4. Create UI: `your_feature_page.dart`
5. Wire up in navigation/routing

### Extending WebView Message Handler

1. Create custom handler extending `WebViewMessageHandler`
2. Implement `handleMessage()` method
3. Use `sendCallback()` to respond to JavaScript
4. Inject handler when creating `CustomWebView`

### Adding Repository Operations

1. Add method to repository interface: `lib/domain/repositories/`
2. Implement in repository: `lib/data/repositories/`
3. Add data source method if needed: `lib/data/datasources/`
4. Repository is automatically available via GetIt singleton
5. Use in Cubit for state management

### Adding New Dependencies to DI Container

Edit `lib/core/di/injection.dart`:

```dart
// Register new data source
getIt.registerLazySingleton<MyDataSource>(
  () => MyDataSourceImpl(),
);

// Register new repository
getIt.registerLazySingleton<MyRepository>(
  () => MyRepositoryImpl(
    dataSource: getIt<MyDataSource>(),
  ),
);
```

Then access anywhere:
```dart
final myRepo = getIt<MyRepository>();
```

## License

This project is private and not published to pub.dev.

## Support

For issues or questions, please contact the development team.
