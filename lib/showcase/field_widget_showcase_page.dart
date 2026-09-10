import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../app/theme/app_spacing.dart';
import '../app/theme/app_ui_mode.dart';
import '../features/workspaces/field_workspace_view.dart';
import 'catalog_mode_switch.dart';

class FieldWidgetShowcasePage extends StatelessWidget {
  const FieldWidgetShowcasePage({super.key});

  @override
  Widget build(BuildContext context) {
    assert(kDebugMode, 'FieldWidgetShowcasePage is debug-only');
    return const AppUiModeScope(
      mode: AppUiMode.field,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              0,
            ),
            child: CatalogModeSwitch(current: AppUiMode.field),
          ),
          Expanded(child: FieldWorkspaceView()),
        ],
      ),
    );
  }
}
