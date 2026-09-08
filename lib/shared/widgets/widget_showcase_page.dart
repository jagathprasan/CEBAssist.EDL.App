import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';
import '../../shared/widgets/widgets.dart';

/// Development-only catalog of shared design-system widgets.
/// Not linked from production navigation.
class WidgetShowcasePage extends StatefulWidget {
  const WidgetShowcasePage({super.key});

  @override
  State<WidgetShowcasePage> createState() => _WidgetShowcasePageState();
}

class _WidgetShowcasePageState extends State<WidgetShowcasePage> {
  final _text = TextEditingController(text: 'Sample');
  final _password = TextEditingController();
  final _search = TextEditingController();
  bool _loading = false;
  bool _switch = true;
  bool _check = false;
  String _priority = 'Normal';
  Set<String> _tags = {'A'};
  DateTime? _date = DateTime.now();
  TimeOfDay? _time = TimeOfDay.now();
  AppViewState _state = AppViewState.content;

  @override
  void dispose() {
    _text.dispose();
    _password.dispose();
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(kDebugMode, 'WidgetShowcasePage is debug-only');
    return AppScaffold(
      appBar: const AppAppBar(title: 'Widget showcase'),
      scrollable: true,
      padding: AppSpacing.pagePadding,
      floatingActionButton: AppFloatingButton(
        onPressed: () => AppFeedback.toast(context, 'FAB tapped'),
        label: 'Action',
      ),
      body: AppKeyboardDismiss(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppPageHeader(
              title: 'Shared UI library',
              subtitle:
                  'Visual QA for buttons, forms, cards, feedback, and dashboard widgets.',
            ),
            AppSectionHeader(
              title: 'Buttons',
              action: TextButton(
                onPressed: () => setState(() => _loading = !_loading),
                child: Text(_loading ? 'Stop loading' : 'Toggle loading'),
              ),
            ),
            AppPrimaryButton(
              label: 'Primary',
              leadingIcon: Icons.check,
              isLoading: _loading,
              onPressed: () {},
            ),
            const SizedBox(height: AppSpacing.xs),
            AppSecondaryButton(label: 'Secondary', onPressed: () {}),
            const SizedBox(height: AppSpacing.xs),
            AppOutlineButton(label: 'Outline', onPressed: () {}),
            const SizedBox(height: AppSpacing.xs),
            AppTextButton(label: 'Text', onPressed: () {}),
            AppDangerButton(label: 'Danger', onPressed: () {}, expand: false),
            const SizedBox(height: AppSpacing.xs),
            AppPrimaryButton(label: 'Disabled', onPressed: null),
            const AppDivider(),
            const AppSectionHeader(title: 'Forms'),
            AppTextField(controller: _text, label: 'Text', required: true),
            const SizedBox(height: AppSpacing.sm),
            AppPasswordField(controller: _password),
            const SizedBox(height: AppSpacing.sm),
            AppSearchField(controller: _search, onChanged: (_) {}),
            const SizedBox(height: AppSpacing.sm),
            AppDropdown<String>(
              label: 'Priority',
              value: _priority,
              items: const [
                DropdownMenuItem(value: 'Low', child: Text('Low')),
                DropdownMenuItem(value: 'Normal', child: Text('Normal')),
                DropdownMenuItem(value: 'High', child: Text('High')),
              ],
              onChanged: (v) => setState(() => _priority = v ?? 'Normal'),
            ),
            AppMultiSelect<String>(
              label: 'Tags',
              options: const ['A', 'B', 'C'],
              labels: const ['A', 'B', 'C'],
              selected: _tags,
              onChanged: (v) => setState(() => _tags = v),
            ),
            AppCheckbox(
              value: _check,
              onChanged: (v) => setState(() => _check = v),
              label: 'Accept terms',
            ),
            AppSwitch(
              value: _switch,
              onChanged: (v) => setState(() => _switch = v),
              label: 'Notifications',
            ),
            AppDatePickerField(
              value: _date,
              onChanged: (v) => setState(() => _date = v),
            ),
            const SizedBox(height: AppSpacing.sm),
            AppTimePickerField(
              value: _time,
              onChanged: (v) => setState(() => _time = v),
            ),
            const SizedBox(height: AppSpacing.sm),
            AppOtpInput(length: 4, onCompleted: (_) {}),
            const AppDivider(),
            const AppSectionHeader(title: 'Cards & status'),
            const AppStatCard(label: 'Open', value: '24', trendLabel: '+2'),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                for (final status in AppEntityStatus.values)
                  AppStatusBadge(status: status),
              ],
            ),
            const AppDivider(),
            const AppSectionHeader(title: 'Feedback states'),
            Wrap(
              spacing: AppSpacing.xs,
              children: [
                for (final state in AppViewState.values)
                  AppChip(
                    label: state.name,
                    selected: _state == state,
                    onSelected: (_) => setState(() => _state = state),
                  ),
              ],
            ),
            SizedBox(
              height: 180,
              child: AppStateView(
                state: _state,
                content: const Center(child: Text('Content loaded')),
                onRetry: () => setState(() => _state = AppViewState.content),
              ),
            ),
            AppPrimaryButton(
              label: 'Show confirmation',
              onPressed: () => AppFeedback.confirm(
                context,
                title: 'Confirm',
                message: 'Proceed with this action?',
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const AppSectionHeader(title: 'Dashboard'),
            AppQuickActionGrid(
              actions: [
                AppQuickAction(
                  label: 'Jobs',
                  icon: Icons.work_outline,
                  onTap: () {},
                ),
                AppQuickAction(
                  label: 'Reports',
                  icon: Icons.bar_chart,
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            const AppProgressSummary(title: 'Completion', progress: 0.7),
            const AppDivider(),
            const AppSectionHeader(title: 'Calendar & posts'),
            AppCalendar(
              events: [
                AppCalendarEvent(
                  date: DateTime.now(),
                  title: 'Team briefing',
                  timeLabel: '08:30',
                  location: 'Area office',
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            const AppFeedPost(
              title: 'Crew started feeder inspection',
              timeLabel: '08:42',
              subtitle: 'EDL-1042 · Unit A',
              author: 'Field',
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}
