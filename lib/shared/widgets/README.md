# Shared widget library

Reusable CEBAssist UI components. Prefer these over one-off Material styling in feature screens.

Import:

```dart
import 'package:electricity_board_erp/shared/widgets/widgets.dart';
```

(Adjust the package name to match `pubspec.yaml` `name`.)

## Design tokens

Use values from `lib/app/theme/`:

| Token | Purpose |
| --- | --- |
| `AppColors` / `AppBrandColors` / `ColorScheme` | Brand and semantic colours |
| `AppTypography` | Text scale helpers |
| `AppSpacing` / `AppRadius` | Spacing and corners |
| `AppShadows` | Elevation |
| `AppSizes` | Icons, buttons, touch targets |
| `AppDurations` | Animation timing |
| `AppBreakpoints` | Responsive layout |
| `AppTheme.light()` / `AppTheme.dark()` | ThemeData |

Do **not** hard-code colours, spacing, radii, or durations in pages.

## Widget inventory

### Buttons (`buttons/`)

- `AppPrimaryButton`, `AppSecondaryButton`, `AppOutlineButton`, `AppTextButton`
- `AppIconButton`, `AppDangerButton`, `AppFloatingButton`
- Common props: `label`, `onPressed`, icons, `isLoading`, `expand`, `size`, `semanticLabel`

### Forms (`forms/`)

- `AppTextField`, `AppPasswordField`, `AppSearchField`, `AppTextArea`
- `AppDropdown`, `AppMultiSelect`, `AppCheckbox`, `AppRadioGroup`, `AppSwitch`
- `AppDatePickerField`, `AppTimePickerField`, `AppDateRangePickerField`
- `AppFilePicker`, `AppImagePicker` (callback shells — no picker package required)
- `AppOtpInput`

### Cards (`cards/`)

- `AppCard`, `AppInfoCard`, `AppStatCard`, `AppSummaryCard`, `AppActionCard`
- `AppListTile`, `AppSectionHeader`, `AppDivider`, `AppBadge`, `AppChip`, `AppAvatar`
- `AppStatusBadge` (`AppEntityStatus`), `AppProgressBar`, `AppCircularProgress`, `AppKeyValueRow`

### Navigation & layout (`navigation/`, `layout/`)

- `AppScaffold`, `AppAppBar`, `AppDrawer`, `AppBottomNavigation`, `AppNavigationRail`
- `AppTabBar`, `AppBackButton`, `AppPageHeader`, `AppSection`, `AppResponsiveLayout`
- `showAppBottomSheet`
- `AppLogo`, `AppNetworkImage`, `AppLocalImage`, `AppIconLabel`, `AppTooltip`
- `AppRefreshIndicator`, `AppAnimatedSwitcher`, `AppKeyboardDismiss`
- `AppResponsivePadding`, `AppScrollableColumn`

### Feedback (`feedback/`)

- `AppStateView`, loaders, empty/error/success/no-internet/permission states
- `AppFeedback.confirm` / `information` / `warning` / `error` / `snackbar` / `toast`

### Data display (`data_display/`)

- Paginated / searchable lists, expandable items
- `AppAdaptiveDataTable` (cards on compact screens)
- Timeline, activity, notification, user, attachment items
- Sort/filter bottom sheet helper

### Dashboard (`dashboard/`)

- KPI/metric cards, quick-action grid, activity/notification/progress summaries
- Status distribution, chart container, dashboard section + skeleton

## Usage example

```dart
AppPrimaryButton(
  label: 'Save',
  leadingIcon: Icons.save_outlined,
  isLoading: saving,
  onPressed: saving ? null : onSave,
);

AppTextField(
  controller: controller,
  label: 'Account',
  required: true,
  validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
);
```

## Rules for new widgets

1. Check this library first; extend an existing widget when possible.
2. Accept configuration via constructor parameters; no business logic.
3. Prefer `const` constructors; use theme tokens; support light/dark.
4. Document with a short Dart doc comment.
5. Keep the API small: sensible defaults + optional overrides.

## Widget showcase (debug only)

Route: `/dev/widget-showcase`

- Registered only when `kDebugMode` is true.
- Open from **Settings → Developer → Widget showcase** in debug builds.
- Not shown in production navigation.
