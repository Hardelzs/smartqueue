# SmartQueue

A Flutter admin app for managing queues, generating QR codes, and monitoring queue activity. Supports organization registration, admin login, and role-based access.

## Features

### Authentication
- User signup (individual accounts with email verification)
- User login with email/password
- Admin organization registration (`/api/v1/org/register`)
- Admin login (`/api/v1/org/login`)
- Forgot password flow (request code → verify code → reset password)
- Email verification via 6-digit code

### Admin Dashboard
- Create queue codes (organization + timestamp)
- Generate QR codes for queues
- Share queue code via system share sheet
- Monitor branches and services
- Bottom navigation: Setup, Monitor, Scan (placeholder), Profile (placeholder)

## Project Structure

```
lib/
├── main.dart
├── pages/
│   ├── auth/                          # Authentication pages
│   │   ├── login_page.dart            # User login
│   │   ├── signup_page.dart           # User registration
│   │   ├── emailverify_page.dart      # Email verification (6-digit code)
│   │   ├── forgot_password_request_page.dart   # Forgot password (request code)
│   │   ├── reset_password_verify_page.dart     # Verify reset code
│   │   └── reset_password_change_page.dart     # Change password
│   ├── admin/                         # Admin pages
│   │   ├── admin_login_page.dart      # Admin login
│   │   ├── admin_signup_page.dart     # Admin (org) registration
│   │   ├── admin_home.dart            # Admin dashboard wrapper
│   │   ├── admin_navbar.dart          # Bottom navigation for admin
│   │   ├── admin_setup_page.dart      # Queue creation + QR generation
│   │   └── admin_monitor_page.dart    # Queue monitoring
│   ├── user/                          # User pages (future)
│   │   ├── user_home.dart
│   │   ├── user_queue_infopage.dart
│   │   └── user_scan_page.dart
│   ├── role_selection_page.dart       # Route to admin/user flow
│   ├── welcome_page.dart              # Welcome/splash
│   └── queue_details_page.dart        # Queue details view
├── services/
│   └── api_service.dart               # Centralized API calls
└── components/                        # Reusable widgets
```

## Requirements
- Flutter SDK (stable channel)
- Windows machine (or macOS/Linux with adjustments)
- Backend API running at `https://queueless-7el4.onrender.com`

## Setup (Windows)

### 1. Install Flutter
Ensure Flutter is installed and in PATH:
```powershell
flutter --version
```

### 2. Clone and get dependencies
```powershell
cd c:\Users\adewa\vscode\flutter\smartqueue\smartqueue
flutter pub get
```

### 3. Run the app
```powershell
# Debug mode
flutter run

# Windows desktop
flutter run -d windows

# Release build
flutter build windows
```

## API Endpoints Used

### User Authentication
- `POST /api/v1/signup` — User registration
- `POST /api/v1/login` — User login
- `POST /api/v1/verify-user` — Email verification
- `POST /api/v1/forgot-password` — Request reset code
- `POST /api/v1/reset-password` — Reset password

### Organization (Admin)
- `POST /api/v1/org/register` — Organization registration
- `POST /api/v1/org/login` — Organization login

## Key Dependencies

Add to `pubspec.yaml` if missing:
```yaml
dependencies:
  flutter:
    sdk: flutter
  google_fonts: ^6.0.0
  qr_flutter: ^4.1.0
  share_plus: ^7.0.0
  http: ^1.1.0
```

Then run:
```powershell
flutter pub get
```

## Navigation Flow

```
Welcome
  ├─ Role Selection
  │   ├─ User Path
  │   │   ├─ Login
  │   │   ├─ Signup → Email Verify
  │   │   └─ Forgot Password → Verify Code → Reset Password
  │   └─ Admin Path
  │       ├─ Admin Login
  │       ├─ Admin Signup (Org Registration)
  │       └─ Admin Dashboard (Setup, Monitor, Scan, Profile)
```

## Known Issues & Solutions

| Issue | Solution |
|-------|----------|
| "RangeError (index):" in admin navbar | Ensure `_pages` list length matches nav item count in `admin_navbar.dart` |
| "Build errors" in admin pages | Check widget tree completeness; validate all decorations/children |
| "Target of URI doesn't exist" | Verify all imports use `package:smartqueue/pages/...` paths |
| Email not received in auth flow | Check backend server logs; ensure email service is configured |
| QR code not displaying | Verify `qr_flutter` is added to pubspec.yaml and `flutter pub get` was run |

## Configuration

### Backend URL
Edit `API_BASE` constant in:
- `lib/pages/auth/login_page.dart`
- `lib/pages/admin/admin_login_page.dart`
- etc.

Or centralize in `lib/services/api_service.dart`:
```dart
const String API_BASE = 'https://queueless-7el4.onrender.com';
```

## Development Tips

- Run `flutter analyze` to check for unused imports/dead code
- Use `flutter test` for unit testing (see `test/widget_test.dart`)
- Keep page/widget imports as `package:smartqueue/pages/...` for maintainability
- Error messages from backend are extracted and displayed to users

## Contribution

- Follow the folder structure (auth, admin, user, services)
- Use package imports, not relative paths
- Run `flutter analyze` and `flutter format` before committing
- Update this README if you add new endpoints or major features

## License

MIT