import 'package:flutter/material.dart';

import '../app/theme/app_breakpoints.dart';
import '../app/theme/app_spacing.dart';
import '../core/extensions/context_extensions.dart';
import '../shared/widgets/widgets.dart';

/// Identical Field/Office catalog. Visual density comes from [AppUiModeScope].
class AppWidgetCatalog extends StatefulWidget {
  const AppWidgetCatalog({super.key});

  @override
  State<AppWidgetCatalog> createState() => _AppWidgetCatalogState();
}

class _AppWidgetCatalogState extends State<AppWidgetCatalog> {
  final _formKey = GlobalKey<FormState>();
  final _text = TextEditingController(text: 'Feeder 11');
  final _number = TextEditingController(text: '24');
  final _password = TextEditingController();
  final _search = TextEditingController();
  final _notes = TextEditingController();
  final _reference = TextEditingController(text: 'EDL-2041');
  final _title = TextEditingController(text: 'Feeder inspection');
  final _location = TextEditingController(text: 'Unit A, pole 24');
  final _assignee = TextEditingController(text: 'Crew 3');
  final _customer = TextEditingController(text: 'Consumer services');
  final _contact = TextEditingController(text: '0771234567');
  final _gps = TextEditingController(text: '6.9271, 79.8612');
  final _remarks = TextEditingController();

  bool _loading = false;
  bool _check = true;
  bool _switch = true;
  bool _submitting = false;
  String _priority = 'Normal';
  String _workStatus = 'Pending';
  String _category = 'Inspection';
  String _radio = 'Site';
  Set<String> _tags = {'Photos'};
  DateTime? _date = DateTime.now().add(const Duration(days: 1));
  TimeOfDay? _time = const TimeOfDay(hour: 13, minute: 0);
  DateTimeRange? _range;
  String? _fileName;
  bool _photoAttached = false;
  AppViewState _viewState = AppViewState.content;

  @override
  void dispose() {
    _text.dispose();
    _number.dispose();
    _password.dispose();
    _search.dispose();
    _notes.dispose();
    _reference.dispose();
    _title.dispose();
    _location.dispose();
    _assignee.dispose();
    _customer.dispose();
    _contact.dispose();
    _gps.dispose();
    _remarks.dispose();
    super.dispose();
  }

  AppDesignTokens get _tokens => AppDesignTokens.ofContext(context);

  bool get _wide {
    return MediaQuery.sizeOf(context).width >= AppBreakpoints.phone &&
        _tokens.formColumns > 1;
  }

  Widget _gap() => SizedBox(height: _tokens.gap);

  Widget _pair(Widget a, Widget b) {
    if (!_wide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [a, _gap(), b],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: a),
        SizedBox(width: _tokens.gap),
        Expanded(child: b),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buttons(),
        SizedBox(height: _tokens.sectionGap),
        _fields(),
        SizedBox(height: _tokens.sectionGap),
        _workForm(),
        SizedBox(height: _tokens.sectionGap),
        _cards(),
        SizedBox(height: _tokens.sectionGap),
        _statusSection(),
        SizedBox(height: _tokens.sectionGap),
        _states(),
        SizedBox(height: _tokens.sectionGap),
        _dialogs(),
      ],
    );
  }

  Widget _buttons() {
    return AppDashboardSection(
      title: 'Buttons',
      subtitle: _tokens.isField
          ? 'Large sunlight-friendly actions'
          : 'Compact desk actions',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppButton(
            label: 'Primary',
            leadingIcon: Icons.check,
            isLoading: _loading,
            onPressed: () => AppFeedback.toast(context, 'Primary'),
          ),
          _gap(),
          AppButton(
            label: 'Secondary',
            variant: AppButtonVariant.secondary,
            onPressed: () {},
          ),
          _gap(),
          AppButton(
            label: 'Outline',
            variant: AppButtonVariant.outline,
            onPressed: () {},
          ),
          _gap(),
          AppButton(
            label: 'Text',
            variant: AppButtonVariant.text,
            expand: false,
            onPressed: () {},
          ),
          _gap(),
          Align(
            alignment: Alignment.centerLeft,
            child: AppIconButton(
              icon: Icons.more_horiz,
              tooltip: 'More',
              onPressed: () => AppFeedback.toast(context, 'Icon button'),
            ),
          ),
          _gap(),
          AppButton(
            label: 'Danger',
            variant: AppButtonVariant.danger,
            onPressed: () {},
          ),
          _gap(),
          AppButton(label: 'Loading', isLoading: true, onPressed: () {}),
          _gap(),
          const AppButton(label: 'Disabled', onPressed: null),
          _gap(),
          AppButton(
            label: 'Full-width',
            leadingIcon: Icons.login,
            onPressed: () => setState(() => _loading = !_loading),
          ),
        ],
      ),
    );
  }

  Widget _fields() {
    return AppDashboardSection(
      title: 'Form fields',
      subtitle: 'Label, hint, required, helper, error, disabled, read-only',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            controller: _text,
            label: 'Text field',
            hint: 'Enter a site name',
            helperText: 'Visible to dispatch',
            required: true,
            prefixIcon: Icons.place_outlined,
          ),
          _gap(),
          AppNumberField(
            controller: _number,
            label: 'Number field',
            hint: 'Poles',
            helperText: 'Whole numbers only',
          ),
          _gap(),
          AppPasswordField(controller: _password, label: 'Password field'),
          _gap(),
          AppSearchField(
            controller: _search,
            hint: 'Search jobs',
            onChanged: (_) {},
          ),
          _gap(),
          AppTextArea(
            controller: _notes,
            label: 'Multiline text area',
            hint: 'Describe the work',
            required: true,
          ),
          _gap(),
          AppDropdown<String>(
            label: 'Dropdown',
            value: _priority,
            items: const [
              DropdownMenuItem(value: 'Low', child: Text('Low')),
              DropdownMenuItem(value: 'Normal', child: Text('Normal')),
              DropdownMenuItem(value: 'High', child: Text('High')),
              DropdownMenuItem(value: 'Critical', child: Text('Critical')),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _priority = value);
            },
          ),
          _gap(),
          AppMultiSelect<String>(
            label: 'Multi-select',
            options: const ['Photos', 'Parts', 'Access'],
            labels: const ['Photos', 'Parts', 'Access'],
            selected: _tags,
            onChanged: (value) => setState(() => _tags = value),
          ),
          AppCheckbox(
            label: 'Checkbox',
            value: _check,
            onChanged: (value) => setState(() => _check = value),
          ),
          AppRadioGroup<String>(
            label: 'Radio buttons',
            values: const ['Site', 'Store', 'Office'],
            labels: const ['Site', 'Store', 'Office'],
            groupValue: _radio,
            onChanged: (value) {
              if (value != null) setState(() => _radio = value);
            },
          ),
          AppSwitch(
            label: 'Switch',
            subtitle: 'Notify office',
            value: _switch,
            onChanged: (value) => setState(() => _switch = value),
          ),
          _gap(),
          _pair(
            AppDatePickerField(
              label: 'Date picker',
              value: _date,
              onChanged: (value) => setState(() => _date = value),
            ),
            AppTimePickerField(
              label: 'Time picker',
              value: _time,
              onChanged: (value) => setState(() => _time = value),
            ),
          ),
          _gap(),
          AppDateRangePickerField(
            label: 'Date-range picker',
            value: _range,
            onChanged: (value) => setState(() => _range = value),
          ),
          _gap(),
          AppFilePicker(
            label: 'File picker',
            fileName: _fileName,
            onPick: () => setState(() => _fileName = 'permit.pdf'),
          ),
          _gap(),
          AppImagePicker(
            label: 'Image picker',
            onPick: () => setState(() => _photoAttached = true),
            preview: _photoAttached
                ? const AppIconLabel(
                    icon: Icons.check_circle_outline,
                    label: 'Photo attached',
                  )
                : null,
          ),
          _gap(),
          AppOtpInput(length: 4, onCompleted: (_) {}),
          _gap(),
          AppTextField(
            controller: _gps,
            label: 'Read-only',
            readOnly: true,
            helperText: 'Filled by GPS',
          ),
          _gap(),
          AppTextField(
            controller: _customer,
            label: 'Disabled',
            enabled: false,
          ),
          _gap(),
          AppTextField(
            controller: _remarks,
            label: 'Validation error',
            required: true,
            errorText: 'This field is required',
            hint: 'Missing value',
          ),
        ],
      ),
    );
  }

  Widget _workForm() {
    return AppDashboardSection(
      title: 'Work form',
      subtitle: 'Same data and validation in both modes',
      child: AppLoadingOverlay(
        loading: _submitting,
        message: 'Submitting…',
        child: AppCard(
          elevated: false,
          padding: EdgeInsets.all(_tokens.cardPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppStepper(
                  steps: const ['Details', 'Assign', 'Confirm'],
                  currentStep: 0,
                ),
                SizedBox(height: _tokens.gap),
                _pair(
                  AppTextField(
                    controller: _reference,
                    label: 'Reference number',
                    required: true,
                    prefixIcon: Icons.tag,
                  ),
                  AppTextField(
                    controller: _title,
                    label: 'Work title',
                    required: true,
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                        ? 'Enter a work title'
                        : null,
                  ),
                ),
                _gap(),
                _pair(
                  AppDropdown<String>(
                    label: 'Work category',
                    value: _category,
                    items: const [
                      DropdownMenuItem(
                        value: 'Inspection',
                        child: Text('Inspection'),
                      ),
                      DropdownMenuItem(value: 'Repair', child: Text('Repair')),
                      DropdownMenuItem(
                        value: 'Replacement',
                        child: Text('Replacement'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) setState(() => _category = value);
                    },
                  ),
                  AppTextField(
                    controller: _location,
                    label: 'Location',
                    required: true,
                    prefixIcon: Icons.place_outlined,
                  ),
                ),
                _gap(),
                _pair(
                  AppTextField(
                    controller: _assignee,
                    label: 'Assigned employee',
                    prefixIcon: Icons.person_outline,
                  ),
                  AppDropdown<String>(
                    label: 'Priority',
                    value: _priority,
                    items: const [
                      DropdownMenuItem(value: 'Low', child: Text('Low')),
                      DropdownMenuItem(value: 'Normal', child: Text('Normal')),
                      DropdownMenuItem(value: 'High', child: Text('High')),
                      DropdownMenuItem(
                        value: 'Critical',
                        child: Text('Critical'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) setState(() => _priority = value);
                    },
                  ),
                ),
                _gap(),
                _pair(
                  AppDropdown<String>(
                    label: 'Status',
                    value: _workStatus,
                    items: const [
                      DropdownMenuItem(value: 'Draft', child: Text('Draft')),
                      DropdownMenuItem(
                        value: 'Pending',
                        child: Text('Pending'),
                      ),
                      DropdownMenuItem(
                        value: 'In Progress',
                        child: Text('In Progress'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) setState(() => _workStatus = value);
                    },
                  ),
                  AppDatePickerField(
                    label: 'Planned date',
                    value: _date,
                    onChanged: (value) => setState(() => _date = value),
                  ),
                ),
                _gap(),
                AppTimePickerField(
                  label: 'Planned time',
                  value: _time,
                  onChanged: (value) => setState(() => _time = value),
                ),
                _gap(),
                AppTextArea(
                  controller: _notes,
                  label: 'Description',
                  hint: 'What needs to be done',
                ),
                _gap(),
                _pair(
                  AppTextField(
                    controller: _customer,
                    label: 'Customer or department',
                  ),
                  AppTextField(
                    controller: _contact,
                    label: 'Contact number',
                    required: true,
                    keyboardType: TextInputType.phone,
                    validator: (value) =>
                        (value == null || value.trim().length < 9)
                        ? 'Enter a valid contact number'
                        : null,
                  ),
                ),
                _gap(),
                AppTextField(
                  controller: _gps,
                  label: 'GPS coordinates',
                  prefixIcon: Icons.my_location_outlined,
                  helperText: 'Locked from the device when in the field',
                ),
                _gap(),
                AppFilePicker(
                  label: 'Attachments',
                  fileName: _fileName,
                  onPick: () => setState(() => _fileName = 'sketch.pdf'),
                ),
                _gap(),
                AppImagePicker(
                  label: 'Photos',
                  onPick: () => setState(() => _photoAttached = true),
                ),
                _gap(),
                AppTextArea(
                  controller: _remarks,
                  label: 'Remarks',
                  hint: 'Internal notes',
                ),
                SizedBox(height: _tokens.sectionGap / 2),
                _pair(
                  AppButton(
                    label: 'Save as Draft',
                    variant: AppButtonVariant.outline,
                    leadingIcon: Icons.save_outlined,
                    onPressed: () => AppFeedback.toast(context, 'Draft saved'),
                  ),
                  AppButton(
                    label: 'Submit',
                    leadingIcon: Icons.cloud_upload_outlined,
                    onPressed: () async {
                      if (!(_formKey.currentState?.validate() ?? false)) {
                        return;
                      }
                      setState(() => _submitting = true);
                      await Future<void>.delayed(
                        const Duration(milliseconds: 700),
                      );
                      if (!mounted) return;
                      setState(() => _submitting = false);
                      AppFeedback.toast(context, 'Work submitted');
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _cards() {
    return AppDashboardSection(
      title: 'Cards and data display',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppInfoCard(
            title: 'Information card',
            message:
                'Unit A feeder is clear for the afternoon switching window.',
            icon: Icons.info_outline,
          ),
          _gap(),
          AppKpiCard(
            label: 'KPI card',
            value: '24',
            icon: Icons.assignment_outlined,
            iconColor: context.colors.primary,
            deltaLabel: '+3 today',
          ),
          _gap(),
          const AppSummaryCard(
            title: 'Summary card',
            subtitle: '75% of today’s plan complete',
          ),
          _gap(),
          AppMobileDataCard(
            title: 'Work-order card',
            entries: const {
              'Location': 'Unit C, consumer service',
              'When': '15:30',
              'Crew': 'Crew 3',
            },
            trailing: const AppStatusBadge(status: AppEntityStatus.pending),
          ),
          _gap(),
          AppCard(
            elevated: false,
            child: AppUserItem(
              name: 'Nimal Perera',
              role: 'Crew lead · Employee card',
            ),
          ),
          _gap(),
          AppNotificationItem(
            title: 'Notification card',
            body: 'Store issued 3 CT meters for the replacement job.',
            timeLabel: '09:05',
            unread: true,
          ),
          _gap(),
          AppAttachmentItem(
            fileName: _fileName ?? 'permit.pdf',
            sizeLabel: 'Attachment card',
            onTap: () => AppFeedback.toast(context, 'Open attachment'),
          ),
          _gap(),
          const AppKeyValueDetails(
            entries: {
              'Reference': 'EDL-2041',
              'Category': 'Inspection',
              'GPS': '6.9271, 79.8612',
            },
          ),
          _gap(),
          const AppExpandableListItem(
            title: 'Expandable details',
            subtitle: 'Tap to show switching notes',
            children: [Text('Isolate feeder 11, then earth at pole 24.')],
          ),
          _gap(),
          const Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              AppStatusBadge(status: AppEntityStatus.inProgress),
              AppPriorityBadge(priority: 'High'),
            ],
          ),
          _gap(),
          const AppProgressBar(value: 0.62, label: 'Progress indicator'),
          _gap(),
          const AppTimeline(
            items: [
              AppTimelineItem(
                title: 'Assigned',
                timeLabel: '08:10',
                subtitle: 'Dispatch',
              ),
              AppTimelineItem(
                title: 'On site',
                timeLabel: '09:40',
                subtitle: 'GPS lock',
              ),
            ],
          ),
          _gap(),
          const AppActivityLogItem(
            title: 'Activity history',
            subtitle: 'Crew 3 started feeder inspection',
            timeLabel: '08:42',
          ),
        ],
      ),
    );
  }

  Widget _statusSection() {
    return AppDashboardSection(
      title: 'Status',
      child: Wrap(
        spacing: AppSpacing.xs,
        runSpacing: AppSpacing.xs,
        children: [
          for (final status in AppEntityStatus.values)
            AppStatusBadge(status: status),
        ],
      ),
    );
  }

  Widget _states() {
    return AppDashboardSection(
      title: 'System states',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: AppSpacing.xs,
            children: [
              for (final state in AppViewState.values)
                AppChip(
                  label: state.name,
                  selected: _viewState == state,
                  onSelected: (_) => setState(() => _viewState = state),
                ),
            ],
          ),
          _gap(),
          SizedBox(
            height: 160,
            child: AppStateView(
              state: _viewState,
              content: const Center(child: Text('Content loaded')),
              onRetry: () => setState(() => _viewState = AppViewState.content),
            ),
          ),
          _gap(),
          const AppSkeletonLoader(lines: 3),
          _gap(),
          AppEmptyStateView(
            title: 'Empty data',
            message: 'No jobs match this filter.',
            onRetry: () {},
          ),
          _gap(),
          AppErrorStateView(
            title: 'Error',
            message: 'Could not reach the aggregator.',
            onRetry: () {},
          ),
          _gap(),
          const AppNoInternetState(),
          _gap(),
          const AppPermissionDeniedState(),
          _gap(),
          AppSuccessState(
            title: 'Success',
            message: 'Report synced to the office.',
            onDone: () {},
          ),
          _gap(),
          const AppLoadingIndicator(message: 'Form submission in progress'),
        ],
      ),
    );
  }

  Widget _dialogs() {
    final field = _tokens.isField;
    return AppDashboardSection(
      title: 'Dialogs and notifications',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppButton(
            label: 'Confirmation dialog',
            variant: AppButtonVariant.secondary,
            onPressed: () => AppFeedback.confirm(
              context,
              title: 'Start job?',
              message: 'This marks you as on site.',
            ),
          ),
          _gap(),
          AppButton(
            label: 'Success dialog',
            variant: AppButtonVariant.secondary,
            onPressed: () => AppFeedback.information(
              context,
              title: 'Saved',
              message: 'Work record stored for sync.',
            ),
          ),
          _gap(),
          AppButton(
            label: 'Warning dialog',
            variant: AppButtonVariant.secondary,
            onPressed: () => AppFeedback.warning(
              context,
              title: 'Low signal',
              message: 'Notes will queue until you are online.',
            ),
          ),
          _gap(),
          AppButton(
            label: 'Error dialog',
            variant: AppButtonVariant.danger,
            onPressed: () => AppFeedback.error(
              context,
              title: 'Submit failed',
              message: 'Check the required fields and try again.',
            ),
          ),
          _gap(),
          AppButton(
            label: 'Snackbar',
            variant: AppButtonVariant.outline,
            onPressed: () => AppFeedback.snackbar(
              context,
              message: 'Queued for sync',
              actionLabel: 'View',
              onAction: () {},
            ),
          ),
          _gap(),
          AppButton(
            label: 'Toast-style notification',
            variant: AppButtonVariant.outline,
            onPressed: () => AppFeedback.toast(context, 'Photo captured'),
          ),
          _gap(),
          AppButton(
            label: 'Action bottom sheet',
            onPressed: () => showAppBottomSheet<void>(
              context: context,
              title: field ? 'Job actions' : 'Quick actions',
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.photo_camera_outlined),
                    title: const Text('Capture photo'),
                    onTap: () => Navigator.pop(context),
                  ),
                  ListTile(
                    leading: const Icon(Icons.sync),
                    title: const Text('Sync now'),
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
