import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../app/theme/app_spacing.dart';
import '../../core/extensions/context_extensions.dart';
import 'workspace_mode.dart';

class WorkspaceTextField extends StatelessWidget {
  const WorkspaceTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.prefixIcon,
    this.maxLines = 1,
    this.keyboardType,
    this.validator,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final IconData? prefixIcon;
  final int maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    final metrics = WorkspaceScope.metricsOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: metrics.labelSize,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: metrics.gap / 3),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          style: TextStyle(fontSize: metrics.bodySize),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon == null
                ? null
                : Icon(prefixIcon, size: metrics.iconSize),
            contentPadding: EdgeInsets.symmetric(
              horizontal: metrics.cardPadding,
              vertical: metrics.isField ? 18 : 14,
            ),
          ),
        ),
      ],
    );
  }
}

class WorkspaceDropdown<T> extends StatelessWidget {
  const WorkspaceDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    final metrics = WorkspaceScope.metricsOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: metrics.labelSize,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: metrics.gap / 3),
        DropdownButtonFormField<T>(
          initialValue: value,
          items: items,
          onChanged: onChanged,
          style: TextStyle(
            fontSize: metrics.bodySize,
            color: context.colors.onSurface,
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              horizontal: metrics.cardPadding,
              vertical: metrics.isField ? 16 : 12,
            ),
          ),
        ),
      ],
    );
  }
}

class WorkspaceDateField extends StatelessWidget {
  const WorkspaceDateField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    final metrics = WorkspaceScope.metricsOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: metrics.labelSize,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: metrics.gap / 3),
        InkWell(
          borderRadius: AppRadius.borderMd,
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: value ?? DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2035),
            );
            if (picked != null) onChanged(picked);
          },
          child: InputDecorator(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.event_outlined, size: metrics.iconSize),
              contentPadding: EdgeInsets.symmetric(
                horizontal: metrics.cardPadding,
                vertical: metrics.isField ? 18 : 14,
              ),
            ),
            child: Text(
              value == null ? 'Select date' : DateFormat.yMMMd().format(value!),
              style: TextStyle(
                fontSize: metrics.bodySize,
                fontWeight: FontWeight.w600,
                color: value == null
                    ? context.colors.onSurfaceVariant
                    : context.colors.onSurface,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class WorkspaceCheckboxTile extends StatelessWidget {
  const WorkspaceCheckboxTile({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final metrics = WorkspaceScope.metricsOf(context);
    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      value: value,
      onChanged: (next) => onChanged(next ?? false),
      controlAffinity: ListTileControlAffinity.leading,
      title: Text(
        label,
        style: TextStyle(
          fontSize: metrics.bodySize,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class WorkspaceSwitchTile extends StatelessWidget {
  const WorkspaceSwitchTile({
    super.key,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final metrics = WorkspaceScope.metricsOf(context);
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      value: value,
      onChanged: onChanged,
      title: Text(
        label,
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
    );
  }
}

class WorkspaceSearchField extends StatelessWidget {
  const WorkspaceSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.hint = 'Search',
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hint;

  @override
  Widget build(BuildContext context) {
    final metrics = WorkspaceScope.metricsOf(context);
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: TextStyle(fontSize: metrics.bodySize),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(Icons.search, size: metrics.iconSize),
        contentPadding: EdgeInsets.symmetric(
          horizontal: metrics.cardPadding,
          vertical: metrics.isField ? 18 : 14,
        ),
      ),
    );
  }
}

class WorkspaceFilterChips extends StatelessWidget {
  const WorkspaceFilterChips({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final metrics = WorkspaceScope.metricsOf(context);
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final option in options)
          ChoiceChip(
            label: Text(
              option,
              style: TextStyle(
                fontSize: metrics.labelSize,
                fontWeight: FontWeight.w700,
              ),
            ),
            selected: selected == option,
            onSelected: (_) => onSelected(option),
            padding: EdgeInsets.symmetric(
              horizontal: metrics.isField ? 12 : 8,
              vertical: metrics.isField ? 8 : 4,
            ),
          ),
      ],
    );
  }
}
