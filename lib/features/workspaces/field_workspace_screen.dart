import 'package:flutter/material.dart';

import 'field_workspace_view.dart';
import 'workspace_kit.dart';

class FieldWorkspaceScreen extends StatelessWidget {
  const FieldWorkspaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const WorkspaceScope(
      mode: WorkspaceMode.field,
      child: FieldWorkspaceView(),
    );
  }
}
