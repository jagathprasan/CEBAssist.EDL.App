import 'package:flutter/material.dart';

import '../../../app/theme/app_durations.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/app_confirmation_dialog.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_error_state.dart';
import '../../../core/widgets/app_loading_skeleton.dart';

enum AppViewState { loading, empty, error, content }

/// Unified content/state host for lists and detail panes.
class AppStateView extends StatelessWidget {
  const AppStateView({
    super.key,
    required this.state,
    required this.content,
    this.loading,
    this.emptyTitle = 'Nothing here yet',
    this.emptyMessage = 'There is no data to display.',
    this.emptyIcon = Icons.inbox_outlined,
    this.errorTitle = 'Something went wrong',
    this.errorMessage = 'Please try again.',
    this.onRetry,
  });

  final AppViewState state;
  final Widget content;
  final Widget? loading;
  final String emptyTitle;
  final String emptyMessage;
  final IconData emptyIcon;
  final String errorTitle;
  final String errorMessage;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: AppDurations.normal,
      child: switch (state) {
        AppViewState.loading =>
          loading ?? const AppLoadingIndicator(key: ValueKey('loading')),
        AppViewState.empty => AppEmptyStateView(
          key: const ValueKey('empty'),
          title: emptyTitle,
          message: emptyMessage,
          icon: emptyIcon,
          onRetry: onRetry,
        ),
        AppViewState.error => AppErrorStateView(
          key: const ValueKey('error'),
          title: errorTitle,
          message: errorMessage,
          onRetry: onRetry,
        ),
        AppViewState.content => KeyedSubtree(
          key: const ValueKey('content'),
          child: content,
        ),
      },
    );
  }
}

class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            if (message != null) ...[
              const SizedBox(height: AppSpacing.md),
              Text(message!, textAlign: TextAlign.center),
            ],
          ],
        ),
      ),
    );
  }
}

class AppSkeletonLoader extends StatelessWidget {
  const AppSkeletonLoader({super.key, this.lines = 4});

  final int lines;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < lines; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.sm),
          AppLoadingSkeleton(width: double.infinity, height: 14 + (i % 3) * 4),
        ],
      ],
    );
  }
}

class AppLoadingOverlay extends StatelessWidget {
  const AppLoadingOverlay({
    super.key,
    required this.loading,
    required this.child,
    this.message,
  });

  final bool loading;
  final Widget child;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (loading)
          Positioned.fill(
            child: ColoredBox(
              color: context.colors.scrim.withValues(alpha: 0.28),
              child: AppLoadingIndicator(message: message),
            ),
          ),
      ],
    );
  }
}

class AppEmptyStateView extends StatelessWidget {
  const AppEmptyStateView({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.onRetry,
    this.retryLabel = 'Refresh',
  });

  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? onRetry;
  final String retryLabel;

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      title: title,
      message: message,
      icon: icon,
      actionLabel: onRetry == null ? null : retryLabel,
      onAction: onRetry,
    );
  }
}

class AppErrorStateView extends StatelessWidget {
  const AppErrorStateView({
    super.key,
    required this.title,
    required this.message,
    this.onRetry,
  });

  final String title;
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return AppErrorState(title: title, message: message, onRetry: onRetry);
  }
}

class AppNoInternetState extends StatelessWidget {
  const AppNoInternetState({super.key, this.onRetry});

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return AppEmptyStateView(
      title: 'No internet connection',
      message: 'Check your connection and try again.',
      icon: Icons.wifi_off_outlined,
      onRetry: onRetry,
      retryLabel: 'Retry',
    );
  }
}

class AppPermissionDeniedState extends StatelessWidget {
  const AppPermissionDeniedState({super.key, this.onRetry});

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return AppEmptyStateView(
      title: 'Permission required',
      message: 'Allow access to continue using this feature.',
      icon: Icons.lock_outline,
      onRetry: onRetry,
      retryLabel: 'Open settings',
    );
  }
}

class AppSuccessState extends StatelessWidget {
  const AppSuccessState({
    super.key,
    required this.title,
    required this.message,
    this.onDone,
    this.doneLabel = 'Done',
  });

  final String title;
  final String message;
  final VoidCallback? onDone;
  final String doneLabel;

  @override
  Widget build(BuildContext context) {
    return AppEmptyStateView(
      title: title,
      message: message,
      icon: Icons.check_circle_outline,
      onRetry: onDone,
      retryLabel: doneLabel,
    );
  }
}

class AppFeedback {
  AppFeedback._();

  static Future<bool> confirm(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    bool isDestructive = false,
  }) {
    return AppConfirmationDialog.show(
      context,
      title: title,
      message: message,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
      isDestructive: isDestructive,
    );
  }

  static Future<void> information(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    return showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  static Future<void> warning(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    return information(context, title: title, message: message);
  }

  static Future<void> error(
    BuildContext context, {
    required String title,
    required String message,
  }) {
    return information(context, title: title, message: message);
  }

  static void snackbar(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: actionLabel == null || onAction == null
            ? null
            : SnackBarAction(label: actionLabel, onPressed: onAction),
      ),
    );
  }

  static void toast(BuildContext context, String message) {
    snackbar(context, message: message);
  }
}
