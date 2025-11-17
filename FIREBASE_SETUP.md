# Firebase Cloud Messaging Setup (Android Only)

Quick reference for setting up FCM in this project.

## Local Development

1. Download `google-services.json` from [Firebase Console](https://console.firebase.google.com/)
   - Go to Project Settings → General → Your apps → Android app
   - Click "Download google-services.json"

2. Place the file in `android/app/google-services.json`

3. Run the app:
   ```bash
   flutter pub get
   flutter run --dart-define-from-file=lib/config/test_config.json
   ```

**That's it!** FCM is now configured.

---

## AWS CodeBuild Setup

### Option 1: AWS Systems Manager Parameter Store (Recommended)

#### Step 1: Store the file
```bash
aws ssm put-parameter \
  --name "/myapp/firebase/google-services-json" \
  --value "$(cat google-services.json)" \
  --type "SecureString"
```

#### Step 2: Update buildspec.yml
```yaml
version: 0.2

env:
  parameter-store:
    GOOGLE_SERVICES_JSON: /myapp/firebase/google-services-json

phases:
  pre_build:
    commands:
      - echo "$GOOGLE_SERVICES_JSON" > android/app/google-services.json
      - ls -la android/app/google-services.json  # Verify

  build:
    commands:
      - flutter build apk --release --dart-define-from-file=lib/config/test_config.json
```

#### Step 3: Grant IAM permissions
Add to your CodeBuild service role:
```json
{
  "Effect": "Allow",
  "Action": ["ssm:GetParameter", "ssm:GetParameters"],
  "Resource": "arn:aws:ssm:REGION:ACCOUNT_ID:parameter/myapp/firebase/*"
}
```

---

### Option 2: AWS S3

#### Step 1: Upload to S3
```bash
aws s3 cp google-services.json s3://my-bucket/firebase/google-services.json
```

#### Step 2: Update buildspec.yml
```yaml
version: 0.2

env:
  variables:
    FIREBASE_S3_BUCKET: my-bucket
    FIREBASE_S3_KEY: firebase/google-services.json

phases:
  pre_build:
    commands:
      - aws s3 cp s3://$FIREBASE_S3_BUCKET/$FIREBASE_S3_KEY android/app/google-services.json
      - ls -la android/app/google-services.json  # Verify

  build:
    commands:
      - flutter build apk --release --dart-define-from-file=lib/config/test_config.json
```

#### Step 3: Grant IAM permissions
Add to your CodeBuild service role:
```json
{
  "Effect": "Allow",
  "Action": ["s3:GetObject"],
  "Resource": "arn:aws:s3:::my-bucket/firebase/*"
}
```

---

## Testing Notifications

### Get Your FCM Token
The token is printed in the console when the app starts. Look for:
```
FCM Token: fX9z...
```

You can also add this to your UI to display it:
```dart
Text('Token: ${FCMService().fcmToken ?? "Loading..."}')
```

### Send Test Notification

#### Via Firebase Console (Easiest)
1. Go to Firebase Console → Cloud Messaging
2. Click "Send your first message"
3. Enter title and body
4. Click "Send test message"
5. Paste your FCM token
6. Click "Test"

#### Via cURL (For Backend Testing)
```bash
# Get Server Key from: Firebase Console → Project Settings → Cloud Messaging
curl -X POST https://fcm.googleapis.com/fcm/send \
  -H "Authorization: key=YOUR_SERVER_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "to": "DEVICE_FCM_TOKEN",
    "notification": {
      "title": "Test Title",
      "body": "Test Message"
    },
    "data": {
      "key": "value"
    }
  }'
```

---

## Troubleshooting

### No FCM Token?
- Wait 5-10 seconds after app launch
- Check internet connection
- Look for "Firebase initialized successfully" in logs
- Ensure Google Play Services is installed on device

### Notifications Not Showing?
- **Android 13+:** Grant notification permission in app settings
- Try Firebase Console test message first
- Check device is not in Do Not Disturb mode
- Disable battery optimization for the app

### Build Fails?
- Verify `google-services.json` exists: `ls android/app/google-services.json`
- Check package name matches between `google-services.json` and `android/app/build.gradle.kts`
- Run `flutter clean && flutter pub get`

### CodeBuild Issues?
- Verify IAM permissions for Parameter Store or S3
- Check parameter name matches exactly
- Add debug output: `cat android/app/google-services.json | head -n 5`
- Ensure JSON content doesn't have extra quotes

---

## Complete Example

See `buildspec.example.yml` for a complete, working CodeBuild configuration.

## Documentation

Full details in `CLAUDE.md` under "Firebase Cloud Messaging" section.
