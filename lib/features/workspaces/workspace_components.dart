import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';
import '../../core/extensions/context_extensions.dart';
import 'workspace_mode.dart';

class WorkspaceActionButton extends StatelessWidget {
  const WorkspaceActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.tone = WorkspaceButtonTone.primary,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final WorkspaceButtonTone tone;

  @override
  Widget build(BuildContext context) {
    final metrics = WorkspaceScope.metricsOf(context);
    final child = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: metrics.iconSize),
          SizedBox(width: metrics.gap / 2),
        ],
        Flexible(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: metrics.bodySize,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );

    final style = ButtonStyle(
      minimumSize: WidgetStatePropertyAll(
        Size(double.infinity, metrics.buttonHeight),
      ),
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(
          horizontal: metrics.cardPadding,
          vertical: metrics.isField ? 16 : 10,
        ),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: AppRadius.borderMd),
      ),
    );

    return switch (tone) {
      WorkspaceButtonTone.primary => FilledButton(
        onPressed: onPressed,
        style: style,
        child: child,
      ),
      WorkspaceButtonTone.secondary => FilledButton.tonal(
        onPressed: onPressed,
        style: style,
        child: child,
      ),
      WorkspaceButtonTone.outline => OutlinedButton(
        onPressed: onPressed,
        style: style,
        child: child,
      ),
    };
  }
}

enum WorkspaceButtonTone { primary, secondary, outline }

class WorkspaceCard extends StatelessWidget {
  const WorkspaceCard({super.key, required this.child, this.title, this.icon});

  final Widget child;
  final String? title;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final metrics = WorkspaceScope.metricsOf(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(metrics.cardPadding),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLowest,
        borderRadius: AppRadius.borderMd,
        boxShadow: [
          BoxShadow(
            color: context.colors.shadow.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Row(
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: metrics.iconSize,
                    color: context.colors.primary,
                  ),
                  SizedBox(width: metrics.gap / 2),
                ],
                Expanded(
                  child: Text(
                    title!,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontSize: metrics.titleSize - 2,
                      fontWeight: metrics.titleWeight,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: metrics.gap),
          ],
          child,
        ],
      ),
    );
  }
}

class WorkspaceMetricTile extends StatelessWidget {
  const WorkspaceMetricTile({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final metrics = WorkspaceScope.metricsOf(context);
    return WorkspaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: context.colors.primary, size: metrics.iconSize),
          SizedBox(height: metrics.gap / 2),
          Text(
            value,
            style: TextStyle(
              fontSize: metrics.isField ? 32 : 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: metrics.labelSize,
              color: context.colors.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class WorkspaceEmptyHint extends StatelessWidget {
  const WorkspaceEmptyHint({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final metrics = WorkspaceScope.metricsOf(context);
    return Text(
      message,
      style: TextStyle(
        fontSize: metrics.bodySize,
        color: context.colors.onSurfaceVariant,
        height: 1.4,
      ),
    );
  }
}
