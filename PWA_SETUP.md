# Progressive Web App (PWA) Setup

This document explains how to build and deploy the App Builder Mobile as a Progressive Web App.

## Overview

The app now supports both native mobile platforms (Android/iOS) and web as a PWA. The web version uses IFrames to display content instead of native WebViews.

**Key Features:**
- **Automatic Icon Generation**: Web icons are automatically generated from `assets/icons/app_icon.png` using `flutter_launcher_icons`

## Architecture Changes

### Platform Detection
- Uses Flutter's `kIsWeb` constant to detect web platform
- Conditionally renders different widgets based on platform

### WebView Implementation
- **Mobile**: Uses `webview_flutter` package with native WebViews
- **Web**: Uses `WebIFrameWidget` with HTML IFrames (dart:html)

### Files Added
```
web/
├── index.html              # Main HTML file with PWA configuration
├── manifest.json           # PWA manifest for installability
├── flutter_service_worker.js  # Service worker for offline support
├── favicon.png             # App favicon
└── icons/
    ├── Icon-192.png        # 192x192 app icon
    └── Icon-512.png        # 512x512 app icon
```

## Building for Web

### Prerequisites

1. Install dependencies:
   ```bash
   flutter pub get
   ```

2. Generate web icons (first time or when icon changes):
   ```bash
   flutter pub run flutter_launcher_icons
   ```

### Build Commands

#### Development Build (Debug)
```bash
# Run build_runner to generate code
dart run build_runner build --delete-conflicting-outputs

# Build web app
flutter build web --dart-define-from-file=lib/config/test_config.json

# Or run directly in Chrome for development/testing
flutter run -d chrome --dart-define-from-file=lib/config/test_config.json
```

#### Production Build (Release)
```bash
# Run build_runner to generate code
dart run build_runner build --delete-conflicting-outputs

# Build optimized production bundle
flutter build web --release --dart-define-from-file=lib/config/test_config.json

# With custom base href (if deploying to subdirectory)
flutter build web --release --dart-define-from-file=lib/config/test_config.json --base-href "/your-app/"
```

### Build Output
The build creates a `build/web/` directory containing:
- `index.html` - Entry point
- `main.dart.js` - Compiled Dart code
- `flutter_service_worker.js` - Generated service worker
- `assets/` - App assets and resources
- `icons/` - App icons

## PWA Features

### Installability
The app can be installed on desktop and mobile browsers:
- Chrome: "Install App" button in address bar
- Safari (iOS): "Add to Home Screen" option
- Edge: "Install App" option in menu

### Manifest Configuration

Edit `web/manifest.json` to customize your PWA metadata:

```json
{
    "name": "Your App Name",
    "short_name": "App",
    "theme_color": "#0c8fbb",
    "background_color": "#FFFFFF",
    "description": "Your app description",
    "display": "standalone",
    "icons": [...]
}
```

**Important fields:**
- `name`: Full app name (shown during install)
- `short_name`: Short name (shown on home screen, max 12 chars)
- `theme_color`: Browser theme color (toolbar/status bar)
- `background_color`: Splash screen background
- `description`: App description for search engines and app stores

### Service Worker
Flutter automatically generates a service worker for:
- Asset caching
- Offline support
- Fast loading

## Web Icons (Automatic Generation)

Web icons are **automatically generated** from your app icon using `flutter_launcher_icons`.

### Setup

1. Place your app icon at: `assets/icons/app_icon.png` (recommended size: 1024x1024 or larger)

2. Run the icon generator:
   ```bash
   flutter pub run flutter_launcher_icons
   ```

### Generated Icons

The following icons are automatically created in `web/icons/`:
- `Icon-192.png` - 192x192 (for PWA install prompt)
- `Icon-512.png` - 512x512 (for high-res displays)
- `favicon.png` - 48x48 (browser tab icon)

### Configuration

Icon generation is configured in `pubspec.yaml`:
```yaml
flutter_launcher_icons:
  web:
    generate: true
    image_path: "assets/icons/app_icon.png"
    background_color: "#ffffff"
    theme_color: "#0c8fbb"
```

**Note:** Run `flutter pub run flutter_launcher_icons` whenever you update your app icon.

## Deployment

### Static Hosting Services

#### Firebase Hosting
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login and initialize
firebase login
firebase init hosting

# Deploy
firebase deploy --only hosting
```

#### Netlify
```bash
# Install Netlify CLI
npm install -g netlify-cli

# Deploy
netlify deploy --dir=build/web --prod
```

#### Vercel
```bash
# Install Vercel CLI
npm install -g vercel

# Deploy
vercel --prod build/web
```

#### GitHub Pages
```bash
# Build with correct base href
flutter build web --release --base-href "/repository-name/"

# Push build/web contents to gh-pages branch
git subtree push --prefix build/web origin gh-pages
```

### Custom Server (Nginx)
```nginx
server {
    listen 80;
    server_name your-domain.com;
    root /var/www/app-builder;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    # Enable compression
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml;
}
```

## Configuration for Web

### Config File Format
The web build uses the same JSON configuration as mobile:

```json
{
  "config": "{\"app_name\":\"Blog\",\"styles\":{...},\"urls\":{...}}"
}
```

### Dynamic Configuration
For different environments, create separate config files:
- `lib/config/dev_config.json` - Development
- `lib/config/staging_config.json` - Staging
- `lib/config/prod_config.json` - Production

Build with specific config:
```bash
flutter build web --dart-define-from-file=lib/config/prod_config.json
```

## Known Limitations

### IFrame Restrictions
The web version uses IFrames, which have some limitations:
1. **Cross-origin issues**: Content must allow iframe embedding
2. **JavaScript channels**: Message passing uses `postMessage` instead of native channels
3. **Storage**: Uses browser's localStorage/sessionStorage instead of native secure storage

### Features Not Available on Web
- Native WebView JavaScript channels (uses postMessage instead)
- Flutter Secure Storage (falls back to sessionStorage)
- Some device-specific APIs

### Security Considerations
Add these headers to allow iframe embedding of your web content:
```
Content-Security-Policy: frame-ancestors 'self' your-pwa-domain.com;
X-Frame-Options: ALLOW-FROM your-pwa-domain.com
```

## Testing

### Local Testing
```bash
# Run with Chrome DevTools
flutter run -d chrome --dart-define-from-file=lib/config/test_config.json

# Test PWA features
# 1. Open Chrome DevTools (F12)
# 2. Go to Application tab
# 3. Check Manifest, Service Workers, Storage
```

### Lighthouse Audit
Test PWA quality:
1. Open Chrome DevTools
2. Go to Lighthouse tab
3. Select "Progressive Web App" category
4. Run audit

### PWA Checklist
- ✅ Served over HTTPS
- ✅ Has a web app manifest
- ✅ Registers a service worker
- ✅ Has app icons (192px and 512px)
- ✅ Responsive design
- ✅ Fast loading (< 3s)
- ✅ Works offline (cached assets)

## Troubleshooting

### Build Errors
```bash
# Clean and rebuild
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter build web --dart-define-from-file=lib/config/test_config.json
```

### Service Worker Not Updating
```bash
# Hard refresh in browser: Ctrl+Shift+R (or Cmd+Shift+R)
# Or clear browser cache in DevTools > Application > Storage > Clear site data
```

### IFrame Not Loading
Check browser console for errors:
- CORS errors: Content must allow iframe embedding
- CSP errors: Check Content-Security-Policy headers
- Mixed content: Ensure all URLs use HTTPS

### Icons Not Showing
1. Verify icon files exist in `web/icons/`
2. Check file sizes match manifest.json
3. Clear browser cache and reload

## Performance Optimization

### Build Optimization
```bash
# Use CanvasKit for better rendering (larger bundle)
flutter build web --web-renderer canvaskit --dart-define-from-file=lib/config/prod_config.json

# Use HTML renderer for smaller bundle
flutter build web --web-renderer html --dart-define-from-file=lib/config/prod_config.json

# Auto-detect best renderer (default)
flutter build web --web-renderer auto --dart-define-from-file=lib/config/prod_config.json
```

### Lazy Loading
Consider implementing code splitting for large apps:
```bash
flutter build web --split-debug-info=build/debug-info --dart-define-from-file=lib/config/prod_config.json
```

## Support and Resources

- [Flutter Web Documentation](https://flutter.dev/web)
- [PWA Documentation](https://web.dev/progressive-web-apps/)
- [Flutter Build Modes](https://flutter.dev/docs/testing/build-modes)
- [Web Deployment](https://flutter.dev/docs/deployment/web)
