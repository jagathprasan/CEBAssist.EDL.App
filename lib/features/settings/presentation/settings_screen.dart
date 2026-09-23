import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/services/device_notification_settings.dart';
import '../../../shared/providers/settings_provider.dart';
import '../../../shared/providers/theme_mode_provider.dart';

/// Appearance and notification controls that work on iOS, Android, and Huawei.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen>
    with WidgetsBindingObserver {
  bool _notificationsEnabled = true;
  bool _notificationBusy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _notificationsEnabled = ref
        .read(appSettingsProvider)
        .notificationsEnabled;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncNotificationsFromDevice();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _syncNotificationsFromDevice();
    }
  }

  Future<void> _syncNotificationsFromDevice() async {
    try {
      final enabled = await DeviceNotificationSettings.isEnabled();
      if (!mounted) return;
      setState(() => _notificationsEnabled = enabled);
      await ref
          .read(appSettingsProvider.notifier)
          .setNotificationsEnabled(enabled);
    } catch (_) {
      // Desktop tests and targets without the permission plugin keep the
      // stored preference.
    }
  }

  Future<void> _onNotificationsChanged(bool enabled) async {
    if (_notificationBusy) return;
    setState(() {
      _notificationBusy = true;
      _notificationsEnabled = enabled;
    });
    await ref
        .read(appSettingsProvider.notifier)
        .setNotificationsEnabled(enabled);

    try {
      final openedSettings = await DeviceNotificationSettings.apply(enabled);
      if (!mounted) return;
      if (openedSettings) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              enabled
                  ? 'Allow notifications in your phone settings, then return here.'
                  : 'Turn notifications off in your phone settings. iOS, Android, and Huawei do not let the app switch them off by itself.',
            ),
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notification settings are not available on this device.'),
        ),
      );
    } finally {
      if (mounted) setState(() => _notificationBusy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final isSystem = themeMode == ThemeMode.system;
    final platformDark =
        MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    final isDark = themeMode == ThemeMode.dark || (isSystem && platformDark);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        _SectionCard(
          title: 'Appearance',
          child: Column(
            children: [
              _SettingSwitch(
                icon: Icons.brightness_auto_outlined,
                title: 'System theme',
                subtitle: 'Match this phone’s light or dark setting',
                value: isSystem,
                onChanged: (value) {
                  if (value) {
                    ref
                        .read(themeModeProvider.notifier)
                        .setThemeMode(ThemeMode.system);
                    return;
                  }
                  ref
                      .read(themeModeProvider.notifier)
                      .setThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
                },
              ),
              _SettingSwitch(
                icon: Icons.dark_mode_outlined,
                title: 'Dark theme',
                subtitle: isSystem
                    ? 'Turn off system theme to choose light or dark'
                    : 'Use the dark appearance',
                value: isDark,
                enabled: !isSystem,
                onChanged: (value) {
                  ref
                      .read(themeModeProvider.notifier)
                      .setThemeMode(
                        value ? ThemeMode.dark : ThemeMode.light,
                      );
                },
              ),
            ],
          ),
        ),
        _SectionCard(
          title: 'Notifications',
          child: _SettingSwitch(
            icon: Icons.notifications_active_outlined,
            title: 'Notifications',
            subtitle: 'Alerts for this app on your phone',
            value: _notificationsEnabled,
            enabled: !_notificationBusy,
            onChanged: _onNotificationsChanged,
          ),
        ),
        if (kDebugMode)
          _SectionCard(
            title: 'Developer',
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Widget showcase'),
              subtitle: const Text('Design-system catalog (debug only)'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(AppRoutes.widgetShowcase),
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Text(
            '${AppConstants.appName}  v${AppConstants.appVersion}',
            textAlign: TextAlign.center,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: AppSurfaces.card(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: context.colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          const Divider(height: 1),
          child,
        ],
      ),
    );
  }
}

class _SettingSwitch extends StatelessWidget {
  const _SettingSwitch({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
    this.subtitle,
    this.enabled = true,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : 0.45,
      child: SwitchListTile(
        contentPadding: EdgeInsets.zero,
        secondary: Icon(icon),
        title: Text(title),
        subtitle: subtitle == null ? null : Text(subtitle!),
        value: value,
        onChanged: enabled ? onChanged : null,
      ),
    );
  }
}
