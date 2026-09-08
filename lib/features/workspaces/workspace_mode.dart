import 'package:flutter/material.dart';

/// Visual density for indoor office vs outdoor field work.
enum WorkspaceMode { office, field }

class WorkspaceMetrics {
  const WorkspaceMetrics(this.mode);

  final WorkspaceMode mode;

  bool get isField => mode == WorkspaceMode.field;

  double get titleSize => isField ? 28 : 20;
  double get subtitleSize => isField ? 18 : 14;
  double get bodySize => isField ? 20 : 14;
  double get labelSize => isField ? 16 : 12;
  double get iconSize => isField ? 32 : 22;
  double get buttonHeight => isField ? 64 : 48;
  double get cardPadding => isField ? 20 : 16;
  double get gap => isField ? 16 : 12;
  FontWeight get titleWeight => FontWeight.w800;
}

class WorkspaceScope extends InheritedWidget {
  const WorkspaceScope({super.key, required this.mode, required super.child});

  final WorkspaceMode mode;

  static WorkspaceMode of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<WorkspaceScope>()?.mode ??
        WorkspaceMode.office;
  }

  static WorkspaceMetrics metricsOf(BuildContext context) {
    return WorkspaceMetrics(of(context));
  }

  @override
  bool updateShouldNotify(WorkspaceScope oldWidget) => mode != oldWidget.mode;
}
