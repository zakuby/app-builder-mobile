# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter mobile application called "App Builder Mobile" that provides a configurable WebView-based app with customizable tabs, colors, and URLs. The app is driven by JSON configuration files that control its appearance and behavior.

**Key Characteristics:**
- JSON-driven configuration for complete app customization
- Multi-tab WebView navigation with state preservation
- BLoC pattern for state management
- Freezed models with JSON serialization
- Compile-time configuration injection

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
- Main cubit: `MyHomeCubit` in `lib/presentation/my_home_cubit.dart`
  - Manages bottom navigation tab index
  - State is an integer (0-based) representing the currently selected tab
  - Methods: `setIndex(int index)` to switch tabs

**Usage pattern:**
```dart
// Read state
context.watch<MyHomeCubit>().state

// Update state
context.read<MyHomeCubit>().setIndex(newIndex)
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
All UI code is in `lib/presentation/`:

- **`MyHomePage`**: Main scaffold with `IndexedStack` for tab navigation
  - Uses `IndexedStack` to keep all WebViews in memory (preserves state)
  - Bottom navigation bar for tab switching
  - Dynamically builds tabs from config

- **`CustomWebView`**: WebView wrapper widget
  - JavaScript enabled by default
  - Takes URL as parameter
  - Uses `webview_flutter` (^4.13.0) package

- **Color Management**: `AppColors` utility (in `lib/util/app_colors.dart`)
  - Centralized color access from configuration
  - Provides type-safe color getters

### Code Organization
```
lib/
├── config/                      # JSON configuration files
│   └── test_config.json        # Test environment config
├── domain/                      # Data models (freezed)
│   ├── config_model.dart       # Model definitions
│   ├── config_model.freezed.dart  # Generated freezed code
│   └── config_model.g.dart     # Generated JSON serialization
├── presentation/                # UI layer
│   ├── my_home_page.dart       # Main app scaffold
│   ├── my_home_cubit.dart      # Tab navigation state management
│   └── webview/                # WebView components
│       └── custom_web_view.dart
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

## Key Dependencies

### Production
- `flutter_bloc: ^9.1.1` - BLoC state management
- `bloc: ^9.0.1` - BLoC core library
- `webview_flutter: ^4.13.0` - WebView integration
- `freezed_annotation: ^3.1.0` - Code generation annotations
- `json_annotation: ^4.9.0` - JSON serialization annotations
- `collection: ^1.19.1` - Collection utilities
- `cupertino_icons: ^1.0.8` - iOS-style icons
- `firebase_core: ^3.10.1` - Firebase core SDK
- `firebase_messaging: ^15.2.0` - Firebase Cloud Messaging
- `flutter_local_notifications: ^18.0.1` - Local notifications display

### Development
- `build_runner: ^2.4.15` - Code generation runner
- `freezed: ^3.2.3` - Code generation for models
- `json_serializable: ^6.8.0` - JSON serialization code gen
- `flutter_lints: ^6.0.0` - Linting rules

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

### Adding a New Screen (Non-WebView)
1. Create new widget in `lib/presentation/`
2. Create corresponding cubit if needed
3. Update navigation logic in `MyHomePage`

### Setting Up Firebase for Local Development (Android)

1. Download `google-services.json` from Firebase Console (Project Settings → General → Your apps → Android app)
2. Place it in `android/app/google-services.json`
3. Run the app:
   ```bash
   flutter run --dart-define-from-file=lib/config/test_config.json
   ```

**Note:** The `google-services.json` file is in `.gitignore` and should never be committed to version control.

### Setting Up Firebase for AWS CodeBuild (Android)

**Simple approach:** Store `google-services.json` securely and copy it during build.

#### Method 1: AWS Systems Manager Parameter Store (Recommended)
1. Store the file content in Parameter Store:
   ```bash
   aws ssm put-parameter \
     --name "/myapp/firebase/google-services-json" \
     --value "$(cat google-services.json)" \
     --type "SecureString"
   ```

2. In `buildspec.yml`:
   ```yaml
   env:
     parameter-store:
       GOOGLE_SERVICES_JSON: /myapp/firebase/google-services-json

   phases:
     pre_build:
       commands:
         - echo "$GOOGLE_SERVICES_JSON" > android/app/google-services.json
   ```

3. Ensure CodeBuild IAM role has `ssm:GetParameter` permission

#### Method 2: AWS S3
1. Upload to S3:
   ```bash
   aws s3 cp google-services.json s3://my-bucket/firebase/google-services.json
   ```

2. In `buildspec.yml`:
   ```yaml
   env:
     variables:
       FIREBASE_S3_BUCKET: my-bucket
       FIREBASE_S3_KEY: firebase/google-services.json

   phases:
     pre_build:
       commands:
         - aws s3 cp s3://$FIREBASE_S3_BUCKET/$FIREBASE_S3_KEY android/app/google-services.json
   ```

3. Ensure CodeBuild IAM role has `s3:GetObject` permission

**Complete example:** See `buildspec.example.yml` in project root

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
