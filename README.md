# SmartQueue

Lightweight Flutter admin app for creating and monitoring simple queue codes (QR generation, share). Built with Flutter and a few packages: google_fonts, qr_flutter, share_plus.

## Features
- Create queue codes (organization + timestamp)
- Generate QR codes for created queues
- Share queue code via system share sheet
- Admin navigation with bottom nav: Setup, Monitor, Scan (placeholder), Profile (placeholder)
- Monitor page with branch/service cards (sample data)

## Project structure (important files)
- lib/pages/
  - admin_setup_page.dart — form to create queue + QR generation + share/print buttons
  - admin_monitor_page.dart — monitor list of branches and services
  - admin_navbar.dart — bottom navigation wrapper that hosts the pages

## Requirements
- Flutter SDK (>= stable channel)
- Windows machine (development instructions below)

## Setup (Windows)
1. Ensure Flutter is installed and in PATH:
   - PowerShell / CMD:
     flutter --version

2. Get dependencies:
   - Open terminal in project root (c:\Users\adewa\vscode\flutter\smartqueue\smartqueue)
   - Run:
     flutter pub get

3. Run the app:
   - Debug on connected device / emulator:
     flutter run
   - Run on Windows desktop:
     flutter run -d windows

## Notes / Known issues
- The bottom navigation expects 4 pages. Keep the `_pages` list length in `admin_navbar.dart` equal to the number of nav items to avoid index errors.
- If navigating to pages that require runtime data (e.g., QueueDetailsPage), do not put them in a `const` list — construct them when available and pass required arguments.
- The print functionality is a placeholder — implement platform-specific printing if required (e.g., using printing package).

## Dependencies of interest
- google_fonts — custom fonts
- qr_flutter — QR code rendering
- share_plus — system share dialog

Add to `pubspec.yaml` if missing:
```yaml
dependencies:
  flutter:
    sdk: flutter
  google_fonts: ^5.0.0
  qr_flutter: ^4.0.0
  share_plus: ^7.0.0
```
Then run:
```
flutter pub get
```

## Contribution
- Report issues or open PRs.
- Keep UI/page counts consistent with navigation.
- Validate `TextFormField` validators and avoid `const` where runtime values are required.

## Quick troubleshooting
- "RangeError (index):" when tapping a nav item — check `_pages` length in `admin_navbar.dart`.
- "Build errors" in `admin_setup_page.dart` or `admin_monitor_page.dart` — ensure widget trees are complete (no trailing commas/braces missing) and validators return non-null strings when required.

License: MIT (add a LICENSE file if needed)