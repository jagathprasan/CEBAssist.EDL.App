# CEBAssist — Electricity Board ERP

First-stage Flutter mobile client for electricity-board operations. The app currently ships a complete UI foundation, mock services, light/dark theming, and authentication flow that can later be connected to REST APIs.

## Requirements

- Flutter **3.41** or later (stable)
- Dart **3.11** or later
- Android Studio / Xcode toolchains for device or emulator builds

Check your toolchain:

```bash
flutter --version
```

## Setup

```bash
flutter pub get
```

## Run

```bash
flutter run
```

### Android

```bash
flutter run -d android
```

### iOS

```bash
flutter run -d ios
```

The debug banner is already disabled in application code.

## Sign in

This EDL app authenticates against the same CEBAssist staff directory as the web portal. Use your **Username** and **Password** — there are no demo accounts in the app.

Local emulator (Android) talks to the aggregator through the external gateway at `http://10.0.2.2:8092`:

```text
POST /EDL/Login
GET  /EDL/Me
POST /EDL/Logout
```

Override the host for a device or production build:

```bash
flutter run --dart-define=API_BASE_URL=https://edl.cebassist.lk
```

Access tokens are stored in encrypted secure storage only when **Remember me** is checked. Passwords are never persisted.

Sister company portals on the aggregator: `/NTNSP`, `/NSO`, `/EGL`.

## Useful commands

```bash
dart format .
flutter analyze
flutter test
```

## Folder structure

```text
lib/
├── app/                 # App widget, router, Material 3 themes
├── core/                # Constants, extensions, services, reusable widgets
├── features/
│   ├── splash/
│   ├── authentication/
│   ├── dashboard/
│   ├── notifications/
│   ├── profile/
│   ├── settings/
│   ├── modules/         # Coming-soon ERP placeholders
│   └── shell/           # Shared app bar and drawer
├── shared/              # Cross-feature models and providers
└── main.dart
```

## Theme customisation

Edit brand colours in:

```text
lib/app/theme/app_colors.dart
```

`AppTheme` in `lib/app/theme/app_theme.dart` builds complete light and dark `ColorScheme` values from those tokens. Do not hardcode colours in widgets; use `context.colors` and `context.semantic`.

The selected theme (Light / Dark / System) is stored with `shared_preferences` and restored on launch.

## Replacing the logo

The app uses two CEBAssist artworks:

| Asset | Use |
| --- | --- |
| `assets/images/ca-logo-new.png` | Full mark (hex icon + wordmark) on splash, login, and the drawer |
| `assets/images/logo.png` | Wordmark-only artwork |

Update the paths in `lib/core/constants/app_constants.dart` if the filenames change. `AppLogo` never crashes if an asset is missing; it falls back to a CEBAssist wordmark and bolt icon.

The product name is also defined in `AppConstants.appName`.

## Connecting remaining mock services

Authentication already uses the CEBAssist API aggregator (`ApiAuthRepository`). Dashboard and notifications are still mocked:

| Concern | Interface | Implementation |
| --- | --- | --- |
| Auth | `lib/features/authentication/domain/auth_repository.dart` | `data/api_auth_repository.dart` |
| Dashboard | `lib/features/dashboard/domain/dashboard_models.dart` | `data/mock_dashboard_repository.dart` |
| Notifications | `lib/features/notifications/domain/notification_models.dart` | `data/mock_notification_repository.dart` |

## First-stage screens

- Splash
- Login and forgot password
- Dashboard with sample operational data
- Notifications, profile, and settings
- Placeholder modules: Consumer Services, Meter Management, Billing, Outage Management, Projects, Inventory, Reports
