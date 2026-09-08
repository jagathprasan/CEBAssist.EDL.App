import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../core/config/app_config.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_primary_button.dart';
import '../../../core/widgets/app_status_chip.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/app_user_avatar.dart';
import '../../../shared/models/user_profile.dart';
import '../../../shared/providers/user_provider.dart';
import '../../authentication/presentation/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final auth = ref.watch(authProvider);

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(authProvider.notifier).refreshProfile();
      },
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          _IdentityCard(user: user),
          const SizedBox(height: AppSpacing.md),
          _Section(
            title: 'Contact',
            children: [
              _ProfileField(label: 'Mobile', value: user.mobile),
              _ProfileField(label: 'Landline', value: user.landline),
              _ProfileField(label: 'Email', value: user.email),
            ],
          ),
          _Section(
            title: 'Organization',
            children: [
              _ProfileField(
                label: 'Company',
                value: user.companyId ?? AppConfig.companyName,
              ),
              _ProfileField(label: 'Username / PF', value: user.username ?? ''),
              _ProfileField(label: 'Employee ID', value: user.employeeId),
              _ProfileField(label: 'Division', value: user.divisionId),
              _ProfileField(label: 'Branch', value: user.branchId),
              _ProfileField(label: 'Unit', value: user.unitId),
              _ProfileField(label: 'Sub-unit', value: user.subUnitId),
              _ProfileField(label: 'Office', value: user.office),
            ],
          ),
          if (user.roles.isNotEmpty)
            _Section(
              title: 'Roles',
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final role in user.roles)
                      AppStatusChip(label: role, tone: AppStatusTone.info),
                  ],
                ),
              ],
            ),
          _Section(
            title: 'Activity',
            children: [
              _ProfileField(label: 'Last activity', value: user.lastActivity),
              _ProfileField(label: 'Status', value: user.status),
            ],
          ),
          if (auth.errorMessage != null) ...[
            Text(
              auth.errorMessage!,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          AppPrimaryButton(
            label: 'Edit contact details',
            icon: Icons.edit_outlined,
            onPressed: () => _EditContactSheet.show(context, ref, user),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppPrimaryButton(
            label: 'Change password',
            icon: Icons.lock_reset_outlined,
            onPressed: () => _ChangePasswordSheet.show(context, ref),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Profile photo is loaded from your CEBAssist directory. Change it from My Account on the web if a new picture is required.',
            textAlign: TextAlign.center,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _IdentityCard extends StatelessWidget {
  const _IdentityCard({required this.user});

  final UserProfile user;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLowest,
        borderRadius: AppRadius.borderMd,
      ),
      child: Column(
        children: [
          AppUserAvatar(
            name: user.fullName,
            imageUrl: user.avatarUrl,
            radius: 44,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            user.fullName,
            textAlign: TextAlign.center,
            style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user.titleLine,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
          if (user.username != null && user.username!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              user.username!,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          AppStatusChip(
            label: user.status,
            tone: user.status.toLowerCase() == 'active'
                ? AppStatusTone.success
                : AppStatusTone.neutral,
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          ...children,
        ],
      ),
    );
  }
}

class _ProfileField extends StatelessWidget {
  const _ProfileField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final display = value.trim().isEmpty ? '—' : value;
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
            display,
            style: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _EditContactSheet extends ConsumerStatefulWidget {
  const _EditContactSheet({required this.user});

  final UserProfile user;

  static Future<void> show(
    BuildContext context,
    WidgetRef ref,
    UserProfile user,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => _EditContactSheet(user: user),
    );
  }

  @override
  ConsumerState<_EditContactSheet> createState() => _EditContactSheetState();
}

class _EditContactSheetState extends ConsumerState<_EditContactSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _mobile;
  late final TextEditingController _landline;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.user.fullName);
    _email = TextEditingController(text: widget.user.email);
    _mobile = TextEditingController(text: widget.user.mobile);
    _landline = TextEditingController(text: widget.user.landline);
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _mobile.dispose();
    _landline.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    final ok = await ref
        .read(authProvider.notifier)
        .updateContact(
          fullName: _name.text,
          email: _email.text,
          mobile: _mobile.text,
          landline: _landline.text,
        );
    if (!mounted) return;
    setState(() => _saving = false);
    if (!ok) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Contact details updated.')));
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
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Edit contact details',
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _name,
                label: 'Full name',
                prefixIcon: Icons.badge_outlined,
                validator: (value) =>
                    Validators.requiredField(value, label: 'Full name'),
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _email,
                label: 'Email',
                prefixIcon: Icons.mail_outline,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.email,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _mobile,
                label: 'Mobile',
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _landline,
                label: 'Landline',
                prefixIcon: Icons.phone_in_talk_outlined,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: AppSpacing.lg),
              AppPrimaryButton(
                label: 'Save changes',
                isLoading: _saving,
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChangePasswordSheet extends ConsumerStatefulWidget {
  const _ChangePasswordSheet();

  static Future<void> show(BuildContext context, WidgetRef ref) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => const _ChangePasswordSheet(),
    );
  }

  @override
  ConsumerState<_ChangePasswordSheet> createState() =>
      _ChangePasswordSheetState();
}

class _ChangePasswordSheetState extends ConsumerState<_ChangePasswordSheet> {
  final _formKey = GlobalKey<FormState>();
  final _current = TextEditingController();
  final _next = TextEditingController();
  final _confirm = TextEditingController();
  bool _saving = false;
  bool _obscure = true;

  @override
  void dispose() {
    _current.dispose();
    _next.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    final ok = await ref
        .read(authProvider.notifier)
        .changePassword(
          currentPassword: _current.text,
          newPassword: _next.text,
          confirmPassword: _confirm.text,
        );
    if (!mounted) return;
    if (!ok) {
      setState(() => _saving = false);
      final message = ref.read(authProvider).errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message ?? 'Unable to change password.')),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password changed. Please sign in again.')),
    );
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
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Change password',
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Use at least 10 characters with upper case, lower case, a number, and a symbol. You will be signed out after a successful change.',
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _current,
                label: 'Current password',
                obscureText: _obscure,
                prefixIcon: Icons.lock_outline,
                validator: Validators.password,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _next,
                label: 'New password',
                obscureText: _obscure,
                prefixIcon: Icons.lock_reset_outlined,
                validator: Validators.newPassword,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _confirm,
                label: 'Confirm new password',
                obscureText: _obscure,
                prefixIcon: Icons.lock_reset_outlined,
                validator: (value) {
                  if (value != _next.text) {
                    return 'New password and confirmation do not match.';
                  }
                  return Validators.newPassword(value);
                },
                suffix: IconButton(
                  onPressed: () => setState(() => _obscure = !_obscure),
                  icon: Icon(
                    _obscure
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppPrimaryButton(
                label: 'Update password',
                isLoading: _saving,
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
