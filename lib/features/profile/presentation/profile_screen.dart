import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_primary_button.dart';
import '../../../core/widgets/app_status_chip.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/app_user_avatar.dart';
import '../../../shared/models/user_profile.dart';
import '../../../shared/providers/user_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Center(
          child: Column(
            children: [
              AppUserAvatar(name: user.fullName, radius: 40),
              const SizedBox(height: AppSpacing.md),
              Text(
                user.fullName,
                style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user.designation,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              AppStatusChip(label: user.status, tone: AppStatusTone.success),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        _ProfileField(label: 'Employee ID', value: user.employeeId),
        _ProfileField(label: 'Office / Branch', value: user.office),
        _ProfileField(label: 'Email', value: user.email),
        _ProfileField(label: 'Mobile number', value: user.mobile),
        const SizedBox(height: AppSpacing.md),
        AppPrimaryButton(
          label: 'Edit Profile',
          icon: Icons.edit_outlined,
          onPressed: () => _openEditor(context, user),
        ),
      ],
    );
  }

  Future<void> _openEditor(BuildContext context, UserProfile user) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => _EditProfileSheet(user: user),
    );
  }
}

class _ProfileField extends StatelessWidget {
  const _ProfileField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLowest,
        borderRadius: AppRadius.borderMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.textTheme.labelMedium?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _EditProfileSheet extends StatefulWidget {
  const _EditProfileSheet({required this.user});

  final UserProfile user;

  @override
  State<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<_EditProfileSheet> {
  late final TextEditingController _mobile;
  late final TextEditingController _email;

  @override
  void initState() {
    super.initState();
    _mobile = TextEditingController(text: widget.user.mobile);
    _email = TextEditingController(text: widget.user.email);
  }

  @override
  void dispose() {
    _mobile.dispose();
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.lg + bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Edit profile',
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Contact details can be updated here. Directory fields remain managed by HR.',
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _email,
            label: 'Email',
            prefixIcon: Icons.mail_outline,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _mobile,
            label: 'Mobile number',
            prefixIcon: Icons.phone_outlined,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppPrimaryButton(
            label: 'Save changes',
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Profile updates will sync when the directory API is connected.',
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
