import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../features/shell/presentation/app_drawer.dart';
import '../../../shared/providers/settings_provider.dart';
import '../../../shared/providers/theme_mode_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final settings = ref.watch(appSettingsProvider);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        _SectionCard(
          title: 'Appearance',
          child: Column(
            children: [
              RadioGroup<ThemeMode>(
                groupValue: themeMode,
                onChanged: (value) {
                  if (value != null) {
                    ref.read(themeModeProvider.notifier).setThemeMode(value);
                  }
                },
                child: Column(
                  children: [
                    RadioListTile<ThemeMode>(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Light'),
                      value: ThemeMode.light,
                    ),
                    RadioListTile<ThemeMode>(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Dark'),
                      value: ThemeMode.dark,
                    ),
                    RadioListTile<ThemeMode>(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('System'),
                      value: ThemeMode.system,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        _SectionCard(
          title: 'Preferences',
          child: Column(
            children: [
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Notifications'),
                subtitle: const Text('Operational alerts and assignments'),
                value: settings.notificationsEnabled,
                onChanged: (value) {
                  ref
                      .read(appSettingsProvider.notifier)
                      .setNotificationsEnabled(value);
                },
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Biometric login'),
                subtitle: const Text('Coming soon — placeholder only'),
                value: settings.biometricEnabled,
                onChanged: (value) {
                  ref
                      .read(appSettingsProvider.notifier)
                      .setBiometricEnabled(value);
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Language'),
                subtitle: const Text('English'),
                trailing: const Icon(Icons.check_circle_outline),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Additional languages will be added later.',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        _SectionCard(
          title: 'Legal',
          child: Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Privacy Policy'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _openLegal(
                  context,
                  'Privacy Policy',
                  'CEBAssist processes operational data solely for electricity board staff. '
                      'This placeholder policy will be replaced with the official privacy notice.',
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Terms and Conditions'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _openLegal(
                  context,
                  'Terms and Conditions',
                  'Use of CEBAssist is limited to authorised employees. '
                      'Official terms will replace this placeholder before production release.',
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('About Application'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => showAboutDialog(
                  context: context,
                  applicationName: AppConstants.appName,
                  applicationVersion: AppConstants.appVersion,
                  applicationIcon: const Icon(Icons.bolt_rounded),
                  children: [
                    Text(
                      '${AppConstants.appFullName} mobile client for operational teams.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Text(
            'Version ${AppConstants.appVersion}',
            textAlign: TextAlign.center,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ),
        FilledButton.tonalIcon(
          onPressed: () => confirmAndLogout(context, ref),
          icon: const Icon(Icons.logout_rounded),
          label: const Text('Logout'),
        ),
      ],
    );
  }

  Future<void> _openLegal(BuildContext context, String title, String body) {
    return showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(body),
            ],
          ),
        );
      },
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
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLowest,
        borderRadius: AppRadius.borderMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          child,
        ],
      ),
    );
  }
}
