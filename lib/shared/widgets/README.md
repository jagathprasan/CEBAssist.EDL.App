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
- `AppCalendar` / `AppFeedPost` (agenda posts with time chips)
- Sort/filter bottom sheet helper

### Dashboard (`dashboard/`)

- KPI/metric cards with Metronic icon boxes
- Quick-action grid, activity/notification/progress summaries
- Status distribution (per-slice colours), chart container, dashboard section + skeleton

### Metronic parity (`metronic/`)

Mapped from `CEBAssist.CoreBilling.Web.Frontend/src/components/ui`:

| Web | Flutter |
| --- | --- |
| `alert` | `AppAlert` |
| `badge` | `AppStatusBadge` / `AppChip` |
| `breadcrumb` | `AppBreadcrumb` |
| `button` | `AppPrimaryButton` and variants |
| `calendar` | `AppCalendar` |
| `card` | `AppCard` |
| `accordion` | `AppAccordion` |
| `stepper` | `AppStepper` |
| `tabs` | `AppTabBar` |
| `dialog` / `alert-dialog` | `AppFeedback` / `showAppConfirmDelete` |
| `sheet` / `drawer` | `showAppBottomSheet` / `AppDrawer` |
| `input` / `textarea` / `select` | `AppTextField` / `AppTextArea` / `AppDropdown` |
| `checkbox` / `switch` / `radio-group` | `AppCheckbox` / `AppSwitch` / `AppRadioGroup` |
| `progress` / `slider` | `AppProgressBar` / `AppSlider` |
| `skeleton` | `AppSkeletonLoader` |
| `sonner` / toast | `AppFeedback.toast` |
| `pagination` | `AppPaginationControls` |
| `table` / `data-grid` | `AppAdaptiveDataTable` |
| `kanban` | `AppKanbanColumn` |
| `avatar` / `avatar-group` | `AppAvatar` / `AppAvatarGroup` |
| `tooltip` / `hover-card` | `AppTooltip` / `AppHoverCard` |
| `toggle` / `toggle-group` | `AppToggle` / `AppToggleGroup` |
| `kbd` / `code` | `AppKbd` / `AppCode` |
| `separator` | `AppSeparator` |
| `carousel` | `AppCarousel` |
| `tree` | `AppTree` |
| `command` | `AppCommandSheet` |
| `counting-number` | `AppCountingNumber` |
| `file-upload` | `AppFilePicker` / `AppImagePicker` |
| `input-otp` | `AppOtpInput` |
| `date-picker` | `AppDatePickerField` |

Decorative web-only effects (marquee, particle background, GitHub button, typing animations) are omitted on mobile.

## Usage example

```dart
AppButton(
  mode: AppUiMode.field, // or inherit AppUiModeScope
  label: 'Save',
  leadingIcon: Icons.save_outlined,
  isLoading: saving,
  onPressed: saving ? null : onSave,
);

FieldButton(label: 'Submit', onPressed: onSubmit);
OfficeButton(label: 'Submit', onPressed: onSubmit);

AppTextField(
  mode: AppUiMode.office,
  controller: controller,
  label: 'Account',
  required: true,
  validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
);
```

`AppUiMode` / `FieldDesignTokens` / `OfficeDesignTokens` live in `lib/app/theme/`. Wrap a subtree with `AppUiModeScope` so buttons and fields pick the right size automatically.

## Rules for new widgets

1. Check this library first; extend an existing widget when possible.
2. Accept configuration via constructor parameters; no business logic.
3. Prefer `const` constructors; use theme tokens; support light/dark.
4. Document with a short Dart doc comment.
5. Keep the API small: sensible defaults + optional overrides.

## Widget showcase (debug only)

Route: `/dev/widget-showcase`

- Hub with **View Field UI** and **View Office UI**.
- Each catalog has a Field/Office switch.
- The same catalog is also embedded in **Field Workspace** and **Office Workspace**.
- Registered only when `kDebugMode` is true.
- Open from **Settings → Developer → Widget showcase**.
- Not shown in production navigation.
