# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter mobile application called "App Builder Mobile" that provides a configurable WebView-based app with customizable tabs, colors, and URLs. The app is driven by JSON configuration files that control its appearance and behavior.

**Key Characteristics:**
- **Clean Architecture**: Separation of Data, Domain, and Presentation layers
- JSON-driven configuration for complete app customization
- Multi-tab WebView navigation with state preservation
- BLoC pattern with Cubit for state management
- Repository pattern with data sources
- Freezed models with JSON serialization
- Compile-time configuration injection
- Pluggable WebView message handlers

## Development Commands

### Running the App
```bash
# Run with test config
flutter run --dart-define-from-file=lib/config/test_config.json

# Run on specific device
flutter run --dart-define-from-file=lib/config/test_config.json -d <device-id>

# Build APK for Android
flutter build apk --dart-define-from-file=lib/config/test_config.json

# Build for iOS
flutter build ios --dart-define-from-file=lib/config/test_config.json
```

### Code Generation
The project uses `freezed` and `json_serializable` for model generation:
```bash
# Generate model files (*.freezed.dart, *.g.dart)
dart run build_runner build

# Watch mode for continuous generation during development
dart run build_runner watch

# Clean and rebuild (use when conflicts occur)
dart run build_runner build --delete-conflicting-outputs
```

**IMPORTANT:** Always regenerate freezed/json files after modifying models in `lib/domain/`

### Testing & Quality
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Run with coverage
flutter test --coverage

# Run analyzer
flutter analyze

# Format code
dart format .
```

### Dependency Management
```bash
# Get dependencies
flutter pub get

# Upgrade dependencies
flutter pub upgrade

# Check outdated packages
flutter pub outdated
```

## Architecture

### Configuration System
The app uses a unique configuration approach where JSON config is passed via compile-time constants:

**How it works:**
1. Configuration files are stored in `lib/config/` (e.g., `test_config.json`)
2. Configs are passed using `--dart-define-from-file` flag at compile/run time
3. `AppUtil.config` (in `lib/util/app_util.dart`) parses the config from the `config` environment variable
4. **The config is double-encoded** (JSON string inside JSON object)

**Config file structure:**
```json
{
  "config": "{\"app_name\":\"...\",\"app_icon\":\"...\",\"styles\":{...},\"urls\":{...}}"
}
```

**Accessing config:**
```dart
AppUtil.config.appName          // Get app name
AppUtil.config.styles.color     // Get style colors
AppUtil.config.urls.tabs        // Get tab configurations
```

### State Management
- Uses **BLoC pattern** via `flutter_bloc` (^9.1.1) and `bloc` (^9.0.1) packages
- **AuthCubit** in `lib/presentation/auth/cubit/auth_cubit.dart`
  - Manages authentication state using freezed states
  - States: `initial`, `loading`, `authenticated`, `unauthenticated`, `error`
  - Methods: `checkAuthStatus()`, `login()`, `logout()`, `saveSecure()`, `getSecure()`, `deleteSecure()`
- **HomeCubit** in `lib/presentation/home/cubit/home_cubit.dart`
  - Manages bottom navigation tab index
  - State is an integer (0-based) representing the currently selected tab
  - Methods: `changeIndex(int index)` to switch tabs

**Usage pattern:**
```dart
// Read state
context.watch<HomeCubit>().state
context.watch<AuthCubit>().state

// Update state
context.read<HomeCubit>().changeIndex(newIndex)

// Auth operations
context.read<AuthCubit>().login(userData)
context.read<AuthCubit>().logout()
```

### Domain Models
Models are in `lib/domain/` and use:
- **Freezed** (^3.2.3) for immutable data classes and union types
- **JSON serialization** with snake_case field naming convention
- Custom converters like `ColorConverter` for hex string ↔ Color conversion

**Key models:**
- `ConfigModel`: Root configuration containing app_name, app_icon, styles, and urls
- `Styles` / `StyleColors`: Theming configuration (primary, secondary, text_color, tab colors)
- `Urls`: Contains login, signup, and tabs array
- `TabItem`: Individual tab configuration with title and url

**Model annotations:**
```dart
@freezed
@JsonSerializable(fieldRename: FieldRename.snake)
```

### UI Structure
UI code is organized by feature in `lib/presentation/`:

#### Auth Feature (`lib/presentation/auth/`)
- **`AuthPage`**: Login/authentication screen with WebView
  - Handles JavaScript channel messages for authentication
  - Uses `AuthCubit` for state management
  - Navigates to home on successful login

- **`AuthCubit`**: State management for authentication
  - States defined using freezed in `auth_state.dart`
  - Manages login, logout, and secure storage operations

#### Home Feature (`lib/presentation/home/`)
- **`HomePage`**: Main scaffold with `IndexedStack` for tab navigation
  - Uses `IndexedStack` to keep all WebViews in memory (preserves state)
  - Bottom navigation bar for tab switching
  - Dynamically builds tabs from config
  - Injects `DefaultWebViewMessageHandler` to each tab's WebView

- **`HomeCubit`**: Simple state management for tab index

#### WebView Feature (`lib/presentation/webview/`)
- **`CustomWebView`**: Reusable WebView wrapper widget
  - JavaScript enabled by default
  - Requires `messageHandler` parameter for JavaScript bridge
  - Uses `webview_flutter` (^4.13.0) package

- **`WebViewMessageHandler`**: Abstract interface for handling JavaScript messages
  - `handleMessage()`: Process incoming messages
  - `sendCallback()`: Send responses to JavaScript
  - `parseMessage()`: Parse JSON messages

- **`DefaultWebViewMessageHandler`**: Default implementation
  - Handles SAVE_SECURE, GET_SECURE, DELETE_SECURE, LOGOUT actions
  - Uses `AuthRepository` for secure storage operations

#### Utilities
- **`AppColors`** (in `lib/util/app_colors.dart`): Centralized color access from configuration
- **`AppUtil`** (in `lib/util/app_util.dart`): Config parsing and access

### Code Organization
```
lib/
├── config/                      # JSON configuration files
│   └── test_config.json        # Test environment config
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
│   ├── config_model.freezed.dart        # Generated freezed code
│   └── config_model.g.dart              # Generated JSON serialization
├── presentation/                # Presentation layer (UI + BLoC)
│   ├── auth/                    # Auth feature
│   │   ├── cubit/
│   │   │   ├── auth_cubit.dart
│   │   │   ├── auth_state.dart
│   │   │   └── auth_state.freezed.dart (generated)
│   │   └── auth_page.dart
│   ├── home/                    # Home feature
│   │   ├── cubit/
│   │   │   └── home_cubit.dart
│   │   └── home_page.dart
│   └── webview/                 # WebView feature
│       ├── custom_web_view.dart
│       ├── web_view_message_handler.dart
│       └── default_web_view_message_handler.dart
├── services/                    # Services layer
│   └── fcm_service.dart        # Firebase Cloud Messaging service
├── util/                        # Utilities
│   ├── app_util.dart           # Config parsing and access
│   └── app_colors.dart         # Centralized color management
└── main.dart                    # App entry point
```

### Firebase Cloud Messaging (FCM) - Android Only
The app integrates Firebase Cloud Messaging for push notifications on Android with dynamic `google-services.json` setup for CI/CD.

**Key Features:**
- Simple configuration retrieval from AWS Parameter Store or S3
- Background and foreground notification handling
- Local notifications with custom channels (Android 8+)
- Topic subscription/unsubscription support
- Automatic token management and refresh handling

**Architecture:**
- `FCMService` singleton in `lib/services/fcm_service.dart` handles all FCM operations
- Initialized in `main.dart` before app starts
- Background message handler (`firebaseMessagingBackgroundHandler`) runs in isolate
- Uses `flutter_local_notifications` for displaying notifications when app is in foreground

**Configuration:**
- For local dev: Place `google-services.json` in `android/app/`
- For CodeBuild: Store in Parameter Store or S3, copy with a simple command in pre_build phase
- File is ignored by git for security

**Usage:**
```dart
// Get FCM token (for sending to your backend)
String? token = FCMService().fcmToken;

// Subscribe to topic
await FCMService().subscribeToTopic('news');

// Unsubscribe from topic
await FCMService().unsubscribeFromTopic('news');

// Delete token (e.g., on logout)
await FCMService().deleteToken();
```

### Firebase Cloud Messaging (FCM) - Android Only
The app integrates Firebase Cloud Messaging for push notifications on Android with dynamic `google-services.json` setup for CI/CD.

**Key Features:**
- Simple configuration retrieval from AWS Parameter Store or S3
- Background and foreground notification handling
- Local notifications with custom channels (Android 8+)
- Topic subscription/unsubscription support
- Automatic token management and refresh handling

**Architecture:**
- `FCMService` singleton in `lib/services/fcm_service.dart` handles all FCM operations
- Initialized in `main.dart` before app starts
- Background message handler (`firebaseMessagingBackgroundHandler`) runs in isolate
- Uses `flutter_local_notifications` for displaying notifications when app is in foreground

**Configuration:**
- For local dev: Place `google-services.json` in `android/app/`
- For CodeBuild: Store in Parameter Store or S3, copy with a simple command in pre_build phase
- File is ignored by git for security

**Usage:**
```dart
// Get FCM token (for sending to your backend)
String? token = FCMService().fcmToken;

// Subscribe to topic
await FCMService().subscribeToTopic('news');

// Unsubscribe from topic
await FCMService().unsubscribeFromTopic('news');

// Delete token (e.g., on logout)
await FCMService().deleteToken();
```

## Key Dependencies

### Production
- `flutter_bloc: ^9.1.1` - BLoC state management
- `bloc: ^9.0.1` - BLoC core library
- `webview_flutter: ^4.13.0` - WebView integration
- `flutter_secure_storage: ^9.2.2` - Encrypted secure storage
- `get_it: ^8.0.2` - Dependency injection / service locator
- `device_info_plus: ^11.1.1` - Device information
- `freezed_annotation: ^3.1.0` - Code generation annotations
- `json_annotation: ^4.9.0` - JSON serialization annotations
- `collection: ^1.19.1` - Collection utilities
- `cupertino_icons: ^1.0.8` - iOS-style icons
- `firebase_core: ^3.10.1` - Firebase core SDK
- `firebase_messaging: ^15.2.0` - Firebase Cloud Messaging
- `flutter_local_notifications: ^18.0.1` - Local notifications display
- `firebase_core: ^3.10.1` - Firebase core SDK
- `firebase_messaging: ^15.2.0` - Firebase Cloud Messaging
- `flutter_local_notifications: ^18.0.1` - Local notifications display

### Development
- `build_runner: ^2.4.15` - Code generation runner
- `freezed: ^3.2.3` - Code generation for models and states
- `json_serializable: ^6.8.0` - JSON serialization code gen
- `flutter_lints: ^6.0.0` - Linting rules
- `flutter_launcher_icons: ^0.14.4` - App icon generation

## Important Notes & Best Practices

### Configuration
- **Always** use double-encoded JSON in config files (JSON string inside JSON object)
- Config is injected at compile-time, not runtime
- Changes to config require app restart/rebuild
- Config files should never contain sensitive data

### Code Generation
- **Always** run `dart run build_runner build` after modifying models
- Generated files (`*.freezed.dart`, `*.g.dart`) should be committed to version control
- Use `--delete-conflicting-outputs` flag when encountering generation conflicts

### State Management
- WebViews are kept in memory using `IndexedStack` to preserve state when switching tabs
- Tab index is managed through BLoC cubit
- Single source of truth for navigation state

### WebView Behavior
- JavaScript is enabled by default
- Each tab maintains its own WebView instance
- WebViews are not reloaded when switching tabs (state preserved)
- Navigation within WebView is independent of app navigation

### Model Conventions
- Use snake_case in JSON (enforced by `@JsonSerializable(fieldRename: FieldRename.snake)`)
- Use camelCase in Dart code
- All models are immutable (freezed)
- Custom converters for non-standard types (e.g., Color from hex string)

### Testing
- Widget tests are in `test/` directory
- Follow existing test patterns
- Test configuration parsing and model serialization

## Common Tasks

### Adding a New Feature
1. Create feature folder: `lib/presentation/your_feature/`
2. Create cubit: `lib/presentation/your_feature/cubit/your_feature_cubit.dart`
3. Create freezed states: `lib/presentation/your_feature/cubit/your_feature_state.dart`
4. Create UI: `lib/presentation/your_feature/your_feature_page.dart`
5. Run `dart run build_runner build --delete-conflicting-outputs`
6. Wire up in navigation/routing

### Adding a New Configuration Field
1. Update model in `lib/domain/config_model.dart`
2. Run `dart run build_runner build --delete-conflicting-outputs`
3. Update config JSON files in `lib/config/`
4. Access via `AppUtil.config.yourNewField`

### Adding a New Tab
1. Edit config JSON file
2. Add new object to `urls.tabs` array with `title` and `url`
3. Restart app

### Changing Theme Colors
1. Edit config JSON file
2. Update hex values in `styles.color` object
3. Restart app

### Extending WebView Message Handler
1. Create custom handler extending `WebViewMessageHandler`
2. Implement `handleMessage()` method
3. Use `sendCallback()` to respond to JavaScript
4. Inject handler when creating `CustomWebView` in `HomePage`

### Adding Repository Operations
1. Add method to repository interface: `lib/domain/repositories/auth_repository.dart`
2. Implement in repository: `lib/data/repositories/auth_repository_impl.dart`
3. Add data source method if needed: `lib/data/datasources/auth_local_datasource.dart`
4. Repository is automatically available via GetIt singleton
5. Use in Cubit: `getIt<AuthRepository>()`

### Adding New Dependencies to DI Container
1. Edit `lib/core/di/injection.dart`
2. Register data sources with `registerLazySingleton`
3. Register repositories with `registerLazySingleton`
4. Access anywhere with `getIt<YourType>()`

**Note:** Cubits should NOT be registered in GetIt - use BlocProvider for proper lifecycle management

### Setting Up Firebase for Local Development (Android)

1. Download `google-services.json` from Firebase Console (Project Settings → General → Your apps → Android app)
2. Place it in `android/app/google-services.json`
3. Run the app:
   ```bash
   flutter run --dart-define-from-file=lib/config/test_config.json
   ```
   
### Testing Push Notifications

#### Get FCM Token
Add this to your app to print the FCM token:
```dart
// In your UI somewhere (e.g., a debug screen)
Text('FCM Token: ${FCMService().fcmToken ?? "Loading..."}')
```

#### Send Test Notification via Firebase Console
1. Go to Firebase Console → Cloud Messaging
2. Click "Send your first message"
3. Enter notification title and text
4. Click "Send test message"
5. Paste your FCM token
6. Click "Test"

#### Send Test Notification via API
```bash
# Get your Server Key from Firebase Console → Project Settings → Cloud Messaging
curl -X POST https://fcm.googleapis.com/fcm/send \
  -H "Authorization: key=YOUR_SERVER_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "to": "DEVICE_FCM_TOKEN",
    "notification": {
      "title": "Test Notification",
      "body": "This is a test message"
    },
    "data": {
      "custom_key": "custom_value"
    }
  }'
```

## Troubleshooting

### Build Runner Issues
```bash
# Clean Flutter build cache
flutter clean

# Clean build_runner cache and rebuild
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

### Config Not Loading
- Verify JSON is double-encoded (string inside object)
- Check `--dart-define-from-file` flag is correct
- Verify config file path is correct
- Restart/rebuild app (config is compile-time)

### WebView Not Loading
- Check URL in configuration is valid and accessible
- Verify JavaScript is enabled
- Check device/emulator has internet connection

### Firebase/FCM Issues (Android)

#### google-services.json Not Found
```bash
# Verify the file exists
ls -la android/app/google-services.json

# Download from Firebase Console and place in android/app/
```

#### Firebase Initialization Failed
- Ensure `google-services.json` is in `android/app/` directory
- Verify the file has valid JSON content (not corrupted)
- Check that package name in `google-services.json` matches `applicationId` in `android/app/build.gradle.kts`
- Ensure `com.google.gms.google-services` plugin is applied (already configured)
- Try cleaning and rebuilding:
  ```bash
  flutter clean
  flutter pub get
  flutter run --dart-define-from-file=lib/config/test_config.json
  ```

#### Notifications Not Appearing
- **Android 13+:** Check notification permissions are granted (runtime permission required)
- Verify notification channel is created (done automatically in `FCMService`)
- Test with Firebase Console test message first
- Check logs for FCM token: look for `FCM Token:` in console output
- Ensure app is not in battery optimization/power saving mode
- Verify Google Play Services is installed and up to date on device

#### FCM Token is Null
- Wait a few seconds after app launch (token retrieval is async)
- Check internet connection
- Look for "Firebase initialized successfully" in console logs
- Ensure Google Play Services is available on the device
- Try restarting the app

#### Background Messages Not Working
- Verify `firebaseMessagingBackgroundHandler` is registered in `main.dart:38`
- Handler must be a top-level function (already implemented correctly)
- `Firebase.initializeApp()` is called in background handler (already done)
- Test by sending notification when app is fully closed (not just backgrounded)
- Check notification payload includes both `notification` and `data` fields

#### CodeBuild Issues
- Verify environment variable is set in CodeBuild project
- Check IAM role permissions:
  - Parameter Store: `ssm:GetParameter` and `ssm:GetParameters`
  - S3: `s3:GetObject` on the specific bucket/key
- Verify the file is created during build:
  ```yaml
  # Add to buildspec.yml pre_build commands for debugging:
  - ls -la android/app/google-services.json
  - head -n 5 android/app/google-services.json  # Check first few lines
  ```
- Common issues:
  - Parameter name mismatch between Parameter Store and buildspec
  - JSON content has extra quotes or escaping
  - File permissions prevent writing to android/app/ directory

### Firebase/FCM Issues (Android)

#### google-services.json Not Found
```bash
# Verify the file exists
ls -la android/app/google-services.json

# Download from Firebase Console and place in android/app/
```

#### Firebase Initialization Failed
- Ensure `google-services.json` is in `android/app/` directory
- Verify the file has valid JSON content (not corrupted)
- Check that package name in `google-services.json` matches `applicationId` in `android/app/build.gradle.kts`
- Ensure `com.google.gms.google-services` plugin is applied (already configured)
- Try cleaning and rebuilding:
  ```bash
  flutter clean
  flutter pub get
  flutter run --dart-define-from-file=lib/config/test_config.json
  ```

#### Notifications Not Appearing
- **Android 13+:** Check notification permissions are granted (runtime permission required)
- Verify notification channel is created (done automatically in `FCMService`)
- Test with Firebase Console test message first
- Check logs for FCM token: look for `FCM Token:` in console output
- Ensure app is not in battery optimization/power saving mode
- Verify Google Play Services is installed and up to date on device

#### FCM Token is Null
- Wait a few seconds after app launch (token retrieval is async)
- Check internet connection
- Look for "Firebase initialized successfully" in console logs
- Ensure Google Play Services is available on the device
- Try restarting the app

#### Background Messages Not Working
- Verify `firebaseMessagingBackgroundHandler` is registered in `main.dart:38`
- Handler must be a top-level function (already implemented correctly)
- `Firebase.initializeApp()` is called in background handler (already done)
- Test by sending notification when app is fully closed (not just backgrounded)
- Check notification payload includes both `notification` and `data` fields

#### CodeBuild Issues
- Verify environment variable is set in CodeBuild project
- Check IAM role permissions:
  - Parameter Store: `ssm:GetParameter` and `ssm:GetParameters`
  - S3: `s3:GetObject` on the specific bucket/key
- Verify the file is created during build:
  ```yaml
  # Add to buildspec.yml pre_build commands for debugging:
  - ls -la android/app/google-services.json
  - head -n 5 android/app/google-services.json  # Check first few lines
  ```
- Common issues:
  - Parameter name mismatch between Parameter Store and buildspec
  - JSON content has extra quotes or escaping
  - File permissions prevent writing to android/app/ directory
