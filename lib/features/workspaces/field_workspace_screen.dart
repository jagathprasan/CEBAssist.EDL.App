import 'package:flutter/material.dart';

import 'workspace_kit.dart';
import 'workspace_showcase.dart';

class FieldWorkspaceScreen extends StatelessWidget {
  const FieldWorkspaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const WorkspaceScope(
      mode: WorkspaceMode.field,
      child: WorkspaceShowcase(
        title: 'Field Workspace',
        subtitle:
            'Outdoor crew layout: large type, simple taps, gloves-friendly controls. Same component kit as Office — only density changes.',
      ),
    );
  }
}
