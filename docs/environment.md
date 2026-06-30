# Environment Setup

---

## Backend Environment Variables

Copy the example file and edit with your values:

```bash
cp apps/backend/.env.example apps/backend/.env
```

### `.env` Reference

| Variable                    | Required | Default                | Description                                     |
|-----------------------------|----------|------------------------|-------------------------------------------------|
| `NODE_ENV`                  | No       | `development`          | Environment mode (`development`, `production`)  |
| `PORT`                      | No       | `5000`                 | API server port                                 |
| `MONGODB_URI`               | **Yes**  | —                      | MongoDB connection string                       |
| `JWT_SECRET`                | **Yes**  | —                      | Secret key for signing access tokens            |
| `JWT_EXPIRES_IN`            | No       | `15m`                  | Access token expiry (e.g. `15m`, `1h`, `7d`)    |
| `JWT_REFRESH_SECRET`        | **Yes**  | —                      | Secret key for signing refresh tokens           |
| `JWT_REFRESH_EXPIRES_IN`    | No       | `7d`                   | Refresh token expiry                            |
| `CLOUDINARY_CLOUD_NAME`     | No*      | —                      | Cloudinary cloud name (required for avatars)    |
| `CLOUDINARY_API_KEY`        | No*      | —                      | Cloudinary API key                              |
| `CLOUDINARY_API_SECRET`     | No*      | —                      | Cloudinary API secret                           |
| `SMTP_HOST`                 | No       | `smtp.gmail.com`       | SMTP server host                                |
| `SMTP_PORT`                 | No       | `587`                  | SMTP server port                                |
| `SMTP_USER`                 | No*      | —                      | SMTP username/email                             |
| `SMTP_PASS`                 | No*      | —                      | SMTP password or app password                   |
| `FRONTEND_URL`              | No       | `http://localhost:3000` | Frontend URL (CORS origin + password reset link)|

> `No*` — Required only if the corresponding feature is used (Cloudinary for avatar uploads, SMTP for password reset emails).

### Generating JWT Secrets

Generate strong random secrets:

```bash
# Linux / macOS
node -e "console.log(require('crypto').randomBytes(64).toString('hex'))"

# Or use openssl
openssl rand -hex 64
```

---

## MongoDB Atlas Setup

1. **Create an account** at [mongodb.com/atlas](https://www.mongodb.com/atlas)
2. **Create a cluster** (free tier M0 is sufficient for development)
3. **Set up database access:**
   - Create a database user with read/write permissions
   - Use a strong password (at least 16 characters, mixed case + numbers)
4. **Configure network access:**
   - Add your IP address or `0.0.0.0/0` (allow from anywhere — use with caution)
5. **Get your connection string:**
   - Click "Connect" → "Connect your application"
   - Select Node.js driver
   - Copy the connection string
6. **Replace `<user>`, `<pass>`, and cluster details** in `MONGODB_URI`:

```
MONGODB_URI=mongodb+srv://myuser:mypassword@cluster0.xxxxx.mongodb.net/insightwallet?retryWrites=true&w=majority
```

### Local MongoDB Alternative

If using a local MongoDB instance:

```
MONGODB_URI=mongodb://localhost:27017/insightwallet
```

---

## Cloudinary Setup

Required for avatar/receipt image uploads.

1. **Create an account** at [cloudinary.com](https://cloudinary.com)
2. **Copy your credentials** from the Dashboard:
   - Cloud name
   - API Key
   - API Secret
3. **Add to `.env`:**

```
CLOUDINARY_CLOUD_NAME=your-cloud-name
CLOUDINARY_API_KEY=your-api-key
CLOUDINARY_API_SECRET=your-api-secret
```

---

## JWT Configuration

### Access Token

- **Algorithm:** HS256
- **Expiry:** 15 minutes (`JWT_EXPIRES_IN`)
- **Storage:** Client memory (Flutter secure storage)
- **Transmission:** `Authorization: Bearer <token>` header

### Refresh Token

- **Algorithm:** HS256
- **Expiry:** 7 days (`JWT_REFRESH_EXPIRES_IN`)
- **Storage:** Server (MongoDB `RefreshToken` collection) + client secure storage
- **Rotation:** Old refresh token is invalidated when a new one is issued

### Token Rotation Flow

```
1. User logs in → receives accessToken + refreshToken
2. Access token expires (401)
3. Client POST /auth/refresh with refreshToken
4. Server verifies, deletes old token, issues new pair
5. If refresh token is invalid → client redirects to login
```

---

## Flutter API Endpoint Configuration

The Flutter app reads the API base URL from a Dart environment variable at compile time:

```dart
static const String baseUrl = String.fromEnvironment(
  'API_BASE_URL',
  defaultValue: 'http://localhost:3000',
);
```

### Development

```bash
# Default (localhost)
flutter run

# Custom API URL (e.g. physical device connecting to your machine)
flutter run --dart-define=API_BASE_URL=http://192.168.1.100:5000

# Android emulator → host machine
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:5000

# iOS simulator → host machine
flutter run --dart-define=API_BASE_URL=http://localhost:5000
```

### Production Build

```bash
flutter build apk --release --dart-define=API_BASE_URL=https://api.insightwallet.com
flutter build ios --release --dart-define=API_BASE_URL=https://api.insightwallet.com
```

---

## Firebase (Future Setup Notes)

The project has dependencies ready for future Firebase integration:

- `flutter_secure_storage` — Can be replaced with Firebase Auth for token management
- `local_auth` — Biometric authentication already implemented

To add Firebase:

1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Add Android/iOS apps in Firebase Console
3. Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
4. Place them in the appropriate directories
5. Add Firebase dependencies:
   ```yaml
   # pubspec.yaml
   firebase_core: ^2.25.0
   firebase_auth: ^4.17.0
   firebase_messaging: ^14.7.0   # Push notifications
   cloud_firestore: ^4.15.0      # Optional: replace MongoDB
   ```
6. Run `flutter pub get`

---

## Verifying the Setup

### Backend

```bash
cd apps/backend
npm install
npm run dev
```

Expected output:
```
========================================
  InsightWallet API
  Environment: development
  Port: 5000
  Docs: http://localhost:5000/api/v1/docs
  Health: http://localhost:5000/api/v1/health
========================================
MongoDB connected: cluster0.xxxxx.mongodb.net
```

### Frontend

```bash
cd apps/mobile
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

The app should launch on your device/emulator and display the splash screen, then redirect to login.
