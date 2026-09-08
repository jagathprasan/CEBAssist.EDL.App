import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../app/theme/app_spacing.dart';
import '../app/theme/app_ui_mode.dart';
import '../features/workspaces/workspace_showcase.dart';
import 'catalog_mode_switch.dart';

class OfficeWidgetShowcasePage extends StatelessWidget {
  const OfficeWidgetShowcasePage({super.key});

  @override
  Widget build(BuildContext context) {
    assert(kDebugMode, 'OfficeWidgetShowcasePage is debug-only');
    return const AppUiModeScope(
      mode: AppUiMode.office,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              0,
            ),
            child: CatalogModeSwitch(current: AppUiMode.office),
          ),
          Expanded(
            child: WorkspaceShowcase(
              title: 'Office UI',
              subtitle:
                  'Desk-side operations: denser layout, KPI cards, posts, and calendar.',
            ),
          ),
        ],
      ),
    );
  }
}
