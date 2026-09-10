import 'package:flutter/material.dart';

import '../../app/theme/app_ui_mode.dart';
import 'field_workspace_view.dart';

class FieldWorkspaceScreen extends StatelessWidget {
  const FieldWorkspaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppUiModeScope(
      mode: AppUiMode.field,
      child: FieldWorkspaceView(),
    );
  }
}
