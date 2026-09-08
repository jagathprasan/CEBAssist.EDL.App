import 'package:flutter/material.dart';

import 'workspace_kit.dart';
import 'workspace_showcase.dart';

class OfficeWorkspaceScreen extends StatelessWidget {
  const OfficeWorkspaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const WorkspaceScope(
      mode: WorkspaceMode.office,
      child: WorkspaceShowcase(
        title: 'Office Workspace',
        subtitle:
            'Desk-side operations: denser layout, KPI cards, posts, and calendar. Built from the Metronic-aligned widget kit.',
      ),
    );
  }
}
