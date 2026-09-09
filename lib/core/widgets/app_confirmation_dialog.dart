import 'package:flutter/material.dart';

import '../../shared/widgets/feedback/app_dialog.dart';

class AppConfirmationDialog extends StatelessWidget {
  const AppConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel = 'Confirm',
    this.cancelLabel = 'Cancel',
    this.isDestructive = false,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final bool isDestructive;

  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    bool isDestructive = false,
  }) async {
    final result = await AppDialog.show<bool>(
      context,
      child: AppDialog(
        title: title,
        message: message,
        tone: isDestructive ? AppDialogTone.error : AppDialogTone.info,
        icon: isDestructive
            ? Icons.delete_outline_rounded
            : Icons.help_outline_rounded,
        primaryLabel: confirmLabel,
        secondaryLabel: cancelLabel,
        isDestructive: isDestructive,
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: title,
      message: message,
      tone: isDestructive ? AppDialogTone.error : AppDialogTone.info,
      icon: isDestructive
          ? Icons.delete_outline_rounded
          : Icons.help_outline_rounded,
      primaryLabel: confirmLabel,
      secondaryLabel: cancelLabel,
      isDestructive: isDestructive,
    );
  }
}
