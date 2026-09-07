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

## Test credentials

| Field | Value |
| --- | --- |
| Username / email | `admin@electricity.lk` |
| Password | `Admin@123` |

Employee ID `04207` is also accepted as the username.

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

## Replacing mock services with REST APIs

Keep the repository interfaces and swap the implementations:

| Concern | Interface | Current mock |
| --- | --- | --- |
| Auth | `lib/features/authentication/domain/auth_repository.dart` | `data/mock_auth_repository.dart` |
| Dashboard | `lib/features/dashboard/domain/dashboard_models.dart` (`DashboardRepository`) | `data/mock_dashboard_repository.dart` |
| Notifications | `lib/features/notifications/domain/notification_models.dart` (`NotificationRepository`) | `data/mock_notification_repository.dart` |

Register the real implementations in the corresponding `*RepositoryProvider` files. UI and routing do not need to change.

## First-stage screens

- Splash
- Login and forgot password
- Dashboard with sample operational data
- Notifications, profile, and settings
- Placeholder modules: Consumer Services, Meter Management, Billing, Outage Management, Projects, Inventory, Reports
