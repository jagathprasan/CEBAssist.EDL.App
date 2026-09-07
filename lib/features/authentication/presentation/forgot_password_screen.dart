import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_primary_button.dart';
import '../../../core/widgets/app_text_field.dart';
import 'providers/auth_provider.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  bool _isSubmitting = false;
  bool _submitted = false;
  String? _error;

  @override
  void dispose() {
    _identifierController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _isSubmitting = true;
      _error = null;
    });
    try {
      await ref
          .read(authProvider.notifier)
          .requestPasswordReset(_identifierController.text);
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _submitted = true;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _error = error.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset password'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.login),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height - 160,
                child: _submitted
                    ? _successState(context)
                    : _formState(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _formState(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Forgot your password?',
            style: context.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Enter your employee ID or work email. If an account exists, we will send reset instructions.',
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (_error != null) ...[
            Text(
              _error!,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colors.error,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          AppTextField(
            controller: _identifierController,
            label: 'Employee ID or email',
            hint: 'name@electricity.lk',
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.badge_outlined,
            validator: Validators.identifier,
            onFieldSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppPrimaryButton(
            label: 'Send reset link',
            isLoading: _isSubmitting,
            onPressed: _submit,
          ),
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: () => context.go(AppRoutes.login),
            child: const Text('Back to login'),
          ),
        ],
      ),
    );
  }

  Widget _successState(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppSpacing.xl),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: context.semantic.successContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.mark_email_read_outlined,
            size: 36,
            color: context.semantic.success,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Check your inbox',
          style: context.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'If ${_identifierController.text.trim()} is registered, password reset instructions are on the way. This is a simulated request until the API is connected.',
          textAlign: TextAlign.center,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
        const Spacer(),
        AppPrimaryButton(
          label: 'Back to login',
          onPressed: () => context.go(AppRoutes.login),
        ),
      ],
    );
  }
}
