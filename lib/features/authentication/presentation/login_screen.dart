import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/utils/validators.dart';
import '../../../core/widgets/app_logo.dart';
import '../../../core/widgets/app_primary_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../shared/widgets/layout/app_page_background.dart';
import 'providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final success = await ref
        .read(authProvider.notifier)
        .login(
          identifier: _usernameController.text,
          password: _passwordController.text,
          rememberMe: _rememberMe,
        );
    _passwordController.clear();
    if (!mounted) return;
    if (success) {
      TextInput.finishAutofillContext();
      context.go(AppRoutes.dashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    return AppPageBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.lg,
                  AppSpacing.md,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return SingleChildScrollView(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: constraints.maxHeight,
                              ),
                              child: Center(
                                child: Form(
                                  key: _formKey,
                                  child: AutofillGroup(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        const Center(
                                          child: AppLogo(
                                            height: 42,
                                            maxWidth: 200,
                                            style: AppLogoStyle.full,
                                          ),
                                        ),
                                        const SizedBox(height: AppSpacing.sm),
                                        Text(
                                          AppConstants.companyLegalName,
                                          textAlign: TextAlign.center,
                                          style: context.textTheme.bodyMedium
                                              ?.copyWith(
                                                color: context
                                                    .colors
                                                    .onSurfaceVariant,
                                              ),
                                        ),
                                        const SizedBox(height: AppSpacing.xl),
                                        Text(
                                          'Welcome',
                                          style: context.textTheme.headlineSmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.w800,
                                              ),
                                        ),
                                        const SizedBox(height: AppSpacing.xs),
                                        Text(
                                          'Sign in to your CEBAssist workspace',
                                          style: context.textTheme.bodyMedium
                                              ?.copyWith(
                                                color: context
                                                    .colors
                                                    .onSurfaceVariant,
                                              ),
                                        ),
                                        const SizedBox(height: AppSpacing.lg),
                                        if (auth.errorMessage != null) ...[
                                          _AuthErrorBanner(
                                            message: auth.errorMessage!,
                                          ),
                                          const SizedBox(height: AppSpacing.md),
                                        ],
                                        AppTextField(
                                          controller: _usernameController,
                                          label: 'Username',
                                          hint: 'Enter your username',
                                          keyboardType: TextInputType.text,
                                          textInputAction: TextInputAction.next,
                                          prefixIcon: Icons.person_outline,
                                          autofillHints: const [
                                            AutofillHints.username,
                                          ],
                                          autocorrect: false,
                                          enableSuggestions: false,
                                          validator: Validators.username,
                                          onChanged: (_) => ref
                                              .read(authProvider.notifier)
                                              .clearError(),
                                        ),
                                        const SizedBox(height: AppSpacing.md),
                                        AppTextField(
                                          controller: _passwordController,
                                          label: 'Password',
                                          hint: 'Enter your password',
                                          obscureText: _obscurePassword,
                                          textInputAction: TextInputAction.done,
                                          prefixIcon: Icons.lock_outline,
                                          autofillHints: const [
                                            AutofillHints.password,
                                          ],
                                          autocorrect: false,
                                          enableSuggestions: false,
                                          validator: Validators.password,
                                          onFieldSubmitted: (_) => _submit(),
                                          onChanged: (_) => ref
                                              .read(authProvider.notifier)
                                              .clearError(),
                                          suffix: IconButton(
                                            tooltip: _obscurePassword
                                                ? 'Show password'
                                                : 'Hide password',
                                            onPressed: () {
                                              setState(
                                                () => _obscurePassword =
                                                    !_obscurePassword,
                                              );
                                            },
                                            icon: Icon(
                                              _obscurePassword
                                                  ? Icons.visibility_outlined
                                                  : Icons
                                                        .visibility_off_outlined,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: AppSpacing.sm),
                                        Row(
                                          children: [
                                            Checkbox(
                                              value: _rememberMe,
                                              onChanged: (value) {
                                                setState(
                                                  () => _rememberMe =
                                                      value ?? false,
                                                );
                                              },
                                            ),
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(
                                                    () => _rememberMe =
                                                        !_rememberMe,
                                                  );
                                                },
                                                child: const Text(
                                                  'Remember me',
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () => context.push(
                                                AppRoutes.forgotPassword,
                                              ),
                                              child: const Text(
                                                'Forgot password?',
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: AppSpacing.md),
                                        AppPrimaryButton(
                                          label: 'Sign In',
                                          icon: Icons.login,
                                          isLoading: auth.isLoading,
                                          onPressed: _submit,
                                        ),
                                        const SizedBox(height: AppSpacing.lg),
                                        Text(
                                          'Need access? Contact your administrator',
                                          textAlign: TextAlign.center,
                                          style: context.textTheme.bodySmall
                                              ?.copyWith(
                                                color: context
                                                    .colors
                                                    .onSurfaceVariant,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Text(
                      'Version ${AppConstants.appVersion}',
                      textAlign: TextAlign.center,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthErrorBanner extends StatelessWidget {
  const _AuthErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.colors.errorContainer,
        borderRadius: AppRadius.borderMd,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: context.colors.error),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colors.onErrorContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
