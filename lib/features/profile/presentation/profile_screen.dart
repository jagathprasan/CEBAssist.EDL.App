import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_primary_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/app_user_avatar.dart';
import '../../../shared/models/user_profile.dart';
import '../../../shared/providers/user_provider.dart';
import '../../authentication/presentation/providers/auth_provider.dart';

/// Personal details the signed-in user can change: name, contact number, email.
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  int _section = 0;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);

    return Column(
      children: [
        _ProfileHeader(user: user),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            0,
            AppSpacing.md,
            AppSpacing.sm,
          ),
          child: SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 0, label: Text('Personal')),
              ButtonSegment(value: 1, label: Text('Security')),
            ],
            selected: {_section},
            onSelectionChanged: (value) {
              setState(() => _section = value.first);
            },
          ),
        ),
        Expanded(
          child: _section == 0
              ? _PersonalSection(user: user)
              : const _SecuritySection(),
        ),
      ],
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.user});

  final UserProfile user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      child: Column(
        children: [
          AppUserAvatar(
            name: user.fullName,
            imageUrl: user.avatarUrl,
            radius: 44,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            user.fullName,
            textAlign: TextAlign.center,
            style: context.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            user.email.trim().isEmpty ? 'No email added' : user.email,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _PersonalSection extends ConsumerStatefulWidget {
  const _PersonalSection({required this.user});

  final UserProfile user;

  @override
  ConsumerState<_PersonalSection> createState() => _PersonalSectionState();
}

class _PersonalSectionState extends ConsumerState<_PersonalSection> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _mobile;
  bool _editing = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.user.fullName);
    _email = TextEditingController(text: widget.user.email);
    _mobile = TextEditingController(text: widget.user.mobile);
  }

  @override
  void didUpdateWidget(covariant _PersonalSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_editing) return;
    if (oldWidget.user.fullName != widget.user.fullName) {
      _name.text = widget.user.fullName;
    }
    if (oldWidget.user.email != widget.user.email) {
      _email.text = widget.user.email;
    }
    if (oldWidget.user.mobile != widget.user.mobile) {
      _mobile.text = widget.user.mobile;
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _mobile.dispose();
    super.dispose();
  }

  void _cancelEdit() {
    _name.text = widget.user.fullName;
    _email.text = widget.user.email;
    _mobile.text = widget.user.mobile;
    setState(() => _editing = false);
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
          landline: widget.user.landline,
        );
    if (!mounted) return;
    setState(() => _saving = false);
    if (!ok) {
      final message = ref.read(authProvider).errorMessage;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message ?? 'Unable to update your profile.')),
      );
      return;
    }
    setState(() => _editing = false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Profile updated.')));
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    return RefreshIndicator(
      onRefresh: () => ref.read(authProvider.notifier).refreshProfile(),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.xs,
          AppSpacing.md,
          AppSpacing.lg,
        ),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: AppSurfaces.card(context),
            child: _editing
                ? _EditForm(
                    formKey: _formKey,
                    name: _name,
                    email: _email,
                    mobile: _mobile,
                    username: user.username ?? '',
                    saving: _saving,
                    onCancel: _cancelEdit,
                    onSave: _save,
                  )
                : _DetailsView(
                    user: user,
                    onEdit: () => setState(() => _editing = true),
                  ),
          ),
        ],
      ),
    );
  }
}

class _DetailsView extends StatelessWidget {
  const _DetailsView({required this.user, required this.onEdit});

  final UserProfile user;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Personal details',
                style: context.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            IconButton(
              tooltip: 'Edit',
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined),
            ),
          ],
        ),
        _DetailRow(label: 'Full name', value: user.fullName),
        _DetailRow(label: 'Username', value: user.username ?? ''),
        _DetailRow(label: 'Email', value: user.email),
        _DetailRow(label: 'Contact number', value: user.mobile),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.textTheme.labelMedium?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            UserProfile.displayLabel(value, empty: 'Not added'),
            style: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _EditForm extends StatelessWidget {
  const _EditForm({
    required this.formKey,
    required this.name,
    required this.email,
    required this.mobile,
    required this.username,
    required this.saving,
    required this.onCancel,
    required this.onSave,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController name;
  final TextEditingController email;
  final TextEditingController mobile;
  final String username;
  final bool saving;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Edit profile',
            style: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'You can update your name, contact number, and email.',
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: name,
            label: 'Full name',
            prefixIcon: Icons.person_outline,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            enabled: !saving,
            validator: (value) =>
                Validators.requiredField(value, label: 'Full name'),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Username',
            style: context.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          InputDecorator(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.badge_outlined),
              enabled: false,
            ),
            child: Text(
              username.trim().isEmpty ? 'Not added' : username,
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: email,
            label: 'Email',
            prefixIcon: Icons.mail_outline,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            enabled: !saving,
            validator: Validators.requiredEmail,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: mobile,
            label: 'Contact number',
            prefixIcon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            enabled: !saving,
            validator: Validators.contactNumber,
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: saving ? null : onCancel,
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppPrimaryButton(
                  label: 'Save',
                  isLoading: saving,
                  onPressed: saving ? null : onSave,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SecuritySection extends ConsumerWidget {
  const _SecuritySection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.xs,
        AppSpacing.md,
        AppSpacing.lg,
      ),
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: AppSurfaces.card(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Security',
                style: context.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  Icons.lock_reset_outlined,
                  color: context.colors.primary,
                ),
                title: const Text('Change password'),
                subtitle: const Text(
                  'Use a strong password. You will be signed out after it changes.',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _ChangePasswordSheet.show(context),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ChangePasswordSheet extends ConsumerStatefulWidget {
  const _ChangePasswordSheet();

  static Future<void> show(BuildContext context) {
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
