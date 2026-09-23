import 'package:flutter/material.dart';

import '../../app/theme/app_ui_mode.dart';
import 'workspace_showcase.dart';

class OfficeWorkspaceScreen extends StatelessWidget {
  const OfficeWorkspaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppUiModeScope(
      mode: AppUiMode.office,
      child: WorkspaceShowcase(
        title: 'Office Workspace',
        subtitle:
            'Desk-side operations with soft cards, KPI tiles, posts, and calendar.',
      ),
    );
  }
}
