import 'package:flutter/material.dart';

import '../../app/theme/app_spacing.dart';
import '../../core/extensions/context_extensions.dart';
import '../../core/widgets/app_status_chip.dart';
import 'workspace_mode.dart';

class WorkspaceTableColumn {
  const WorkspaceTableColumn({
    required this.keyName,
    required this.label,
    this.flex = 1,
    this.numeric = false,
  });

  final String keyName;
  final String label;
  final int flex;
  final bool numeric;
}

class WorkspaceDataTable extends StatelessWidget {
  const WorkspaceDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.onRowTap,
  });

  final List<WorkspaceTableColumn> columns;
  final List<Map<String, String>> rows;
  final ValueChanged<Map<String, String>>? onRowTap;

  @override
  Widget build(BuildContext context) {
    final metrics = WorkspaceScope.metricsOf(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: context.colors.outlineVariant),
        borderRadius: AppRadius.borderMd,
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: metrics.cardPadding,
              vertical: metrics.isField ? 14 : 10,
            ),
            decoration: BoxDecoration(
              color: context.colors.surfaceContainerHigh,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppRadius.md),
              ),
            ),
            child: Row(
              children: [
                for (final column in columns)
                  Expanded(
                    flex: column.flex,
                    child: Text(
                      column.label,
                      textAlign: column.numeric
                          ? TextAlign.end
                          : TextAlign.start,
                      style: TextStyle(
                        fontSize: metrics.labelSize,
                        fontWeight: FontWeight.w800,
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) Divider(height: 1, color: context.colors.outlineVariant),
            Material(
              color: i.isEven
                  ? context.colors.surface
                  : context.colors.surfaceContainerLowest,
              child: InkWell(
                onTap: onRowTap == null ? null : () => onRowTap!(rows[i]),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: metrics.cardPadding,
                    vertical: metrics.isField ? 16 : 12,
                  ),
                  child: Row(
                    children: [
                      for (final column in columns)
                        Expanded(
                          flex: column.flex,
                          child: Text(
                            rows[i][column.keyName] ?? '—',
                            textAlign: column.numeric
                                ? TextAlign.end
                                : TextAlign.start,
                            style: TextStyle(
                              fontSize: metrics.bodySize,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class WorkspaceStatusRow extends StatelessWidget {
  const WorkspaceStatusRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.status,
    this.tone = AppStatusTone.info,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final String status;
  final AppStatusTone tone;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final metrics = WorkspaceScope.metricsOf(context);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      title: Text(
        title,
        style: TextStyle(
          fontSize: metrics.bodySize,
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: metrics.labelSize,
          color: context.colors.onSurfaceVariant,
        ),
      ),
      trailing: AppStatusChip(label: status, tone: tone),
    );
  }
}
