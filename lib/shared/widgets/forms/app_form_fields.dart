import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';

/// Common field chrome: label, helper, error, required marker.
class AppFieldFrame extends StatelessWidget {
  const AppFieldFrame({
    super.key,
    required this.child,
    this.label,
    this.helperText,
    this.errorText,
    this.required = false,
  });

  final Widget child;
  final String? label;
  final String? helperText;
  final String? errorText;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Row(
            children: [
              Flexible(
                child: Text(
                  label!,
                  style: context.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (required)
                Text(
                  ' *',
                  style: TextStyle(
                    color: context.colors.error,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
        child,
        if (errorText != null) ...[
          const SizedBox(height: AppSpacing.xxs),
          Text(
            errorText!,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colors.error,
            ),
          ),
        ] else if (helperText != null) ...[
          const SizedBox(height: AppSpacing.xxs),
          Text(
            helperText!,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.required = false,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.prefixIcon,
    this.suffix,
    this.autofillHints,
    this.onFieldSubmitted,
    this.inputFormatters,
  });

  final TextEditingController controller;
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final bool required;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int maxLines;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final IconData? prefixIcon;
  final Widget? suffix;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return AppFieldFrame(
      label: label,
      helperText: helperText,
      errorText: errorText,
      required: required,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        enabled: enabled,
        readOnly: readOnly,
        maxLines: maxLines,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        validator: validator,
        onChanged: onChanged,
        autofillHints: autofillHints,
        onFieldSubmitted: onFieldSubmitted,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
          suffixIcon: suffix,
          errorText: errorText,
        ),
      ),
    );
  }
}

class AppPasswordField extends StatefulWidget {
  const AppPasswordField({
    super.key,
    required this.controller,
    this.label = 'Password',
    this.hint,
    this.validator,
    this.onChanged,
    this.required = false,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final bool required;

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: widget.controller,
      label: widget.label,
      hint: widget.hint,
      required: widget.required,
      obscureText: _obscure,
      prefixIcon: Icons.lock_outline,
      validator: widget.validator,
      onChanged: widget.onChanged,
      autofillHints: const [AutofillHints.password],
      suffix: IconButton(
        tooltip: _obscure ? 'Show password' : 'Hide password',
        onPressed: () => setState(() => _obscure = !_obscure),
        icon: Icon(
          _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        ),
      ),
    );
  }
}

class AppSearchField extends StatefulWidget {
  const AppSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    this.hint = 'Search',
    this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hint;
  final VoidCallback? onClear;

  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onText);
  }

  @override
  void didUpdateWidget(covariant AppSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onText);
      widget.controller.addListener(_onText);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onText);
    super.dispose();
  }

  void _onText() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      onChanged: widget.onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: widget.hint,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: widget.controller.text.isEmpty
            ? null
            : IconButton(
                tooltip: 'Clear',
                onPressed: () {
                  widget.controller.clear();
                  widget.onChanged('');
                  widget.onClear?.call();
                },
                icon: const Icon(Icons.close),
              ),
      ),
    );
  }
}

class AppTextArea extends StatelessWidget {
  const AppTextArea({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.minLines = 3,
    this.maxLines = 6,
    this.validator,
    this.required = false,
  });

  final TextEditingController controller;
  final String? label;
  final String? hint;
  final int minLines;
  final int maxLines;
  final String? Function(String?)? validator;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return AppFieldFrame(
      label: label,
      required: required,
      child: TextFormField(
        controller: controller,
        minLines: minLines,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(hintText: hint),
      ),
    );
  }
}

class AppDropdown<T> extends StatelessWidget {
  const AppDropdown({
    super.key,
    required this.items,
    required this.onChanged,
    this.value,
    this.label,
    this.hint,
    this.required = false,
    this.enabled = true,
  });

  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final T? value;
  final String? label;
  final String? hint;
  final bool required;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return AppFieldFrame(
      label: label,
      required: required,
      child: DropdownButtonFormField<T>(
        key: ValueKey(value),
        initialValue: value,
        items: items,
        onChanged: enabled ? onChanged : null,
        decoration: InputDecoration(hintText: hint),
      ),
    );
  }
}

class AppCheckbox extends StatelessWidget {
  const AppCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final String label;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: value,
      onChanged: (v) => onChanged(v ?? false),
      title: Text(label),
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}

class AppRadioGroup<T> extends StatelessWidget {
  const AppRadioGroup({
    super.key,
    required this.values,
    required this.labels,
    required this.groupValue,
    required this.onChanged,
    this.label,
  });

  final List<T> values;
  final List<String> labels;
  final T? groupValue;
  final ValueChanged<T?> onChanged;
  final String? label;

  @override
  Widget build(BuildContext context) {
    assert(values.length == labels.length);
    return AppFieldFrame(
      label: label,
      child: RadioGroup<T>(
        groupValue: groupValue,
        onChanged: onChanged,
        child: Column(
          children: [
            for (var i = 0; i < values.length; i++)
              RadioListTile<T>(
                value: values[i],
                title: Text(labels[i]),
                contentPadding: EdgeInsets.zero,
              ),
          ],
        ),
      ),
    );
  }
}

class AppSwitch extends StatelessWidget {
  const AppSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
    this.subtitle,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final String label;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: Text(label),
      subtitle: subtitle == null ? null : Text(subtitle!),
      contentPadding: EdgeInsets.zero,
    );
  }
}

class AppDatePickerField extends StatelessWidget {
  const AppDatePickerField({
    super.key,
    required this.value,
    required this.onChanged,
    this.label = 'Date',
    this.firstDate,
    this.lastDate,
  });

  final DateTime? value;
  final ValueChanged<DateTime> onChanged;
  final String label;
  final DateTime? firstDate;
  final DateTime? lastDate;

  @override
  Widget build(BuildContext context) {
    return AppFieldFrame(
      label: label,
      child: InkWell(
        borderRadius: AppRadius.borderSm,
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: value ?? DateTime.now(),
            firstDate: firstDate ?? DateTime(2000),
            lastDate: lastDate ?? DateTime(2100),
          );
          if (picked != null) onChanged(picked);
        },
        child: InputDecorator(
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.event_outlined),
          ),
          child: Text(
            value == null ? 'Select date' : DateFormat.yMMMd().format(value!),
            style: context.textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }
}

class AppTimePickerField extends StatelessWidget {
  const AppTimePickerField({
    super.key,
    required this.value,
    required this.onChanged,
    this.label = 'Time',
  });

  final TimeOfDay? value;
  final ValueChanged<TimeOfDay> onChanged;
  final String label;

  @override
  Widget build(BuildContext context) {
    return AppFieldFrame(
      label: label,
      child: InkWell(
        borderRadius: AppRadius.borderSm,
        onTap: () async {
          final picked = await showTimePicker(
            context: context,
            initialTime: value ?? TimeOfDay.now(),
          );
          if (picked != null) onChanged(picked);
        },
        child: InputDecorator(
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.schedule_outlined),
          ),
          child: Text(
            value?.format(context) ?? 'Select time',
            style: context.textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }
}

class AppDateRangePickerField extends StatelessWidget {
  const AppDateRangePickerField({
    super.key,
    required this.value,
    required this.onChanged,
    this.label = 'Date range',
  });

  final DateTimeRange? value;
  final ValueChanged<DateTimeRange> onChanged;
  final String label;

  @override
  Widget build(BuildContext context) {
    return AppFieldFrame(
      label: label,
      child: InkWell(
        borderRadius: AppRadius.borderSm,
        onTap: () async {
          final picked = await showDateRangePicker(
            context: context,
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            initialDateRange: value,
          );
          if (picked != null) onChanged(picked);
        },
        child: InputDecorator(
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.date_range_outlined),
          ),
          child: Text(
            value == null
                ? 'Select range'
                : '${DateFormat.yMMMd().format(value!.start)} – ${DateFormat.yMMMd().format(value!.end)}',
            style: context.textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }
}

/// UI shell for file selection. Parent supplies [onPick] (no package required).
class AppFilePicker extends StatelessWidget {
  const AppFilePicker({
    super.key,
    required this.onPick,
    this.label = 'Attachment',
    this.fileName,
  });

  final VoidCallback onPick;
  final String label;
  final String? fileName;

  @override
  Widget build(BuildContext context) {
    return AppFieldFrame(
      label: label,
      child: OutlinedButton.icon(
        onPressed: onPick,
        icon: const Icon(Icons.attach_file),
        label: Text(fileName ?? 'Choose file'),
      ),
    );
  }
}

/// UI shell for image selection. Parent supplies [onPick].
class AppImagePicker extends StatelessWidget {
  const AppImagePicker({
    super.key,
    required this.onPick,
    this.label = 'Photo',
    this.preview,
  });

  final VoidCallback onPick;
  final String label;
  final Widget? preview;

  @override
  Widget build(BuildContext context) {
    return AppFieldFrame(
      label: label,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (preview != null) ...[
            ClipRRect(
              borderRadius: AppRadius.borderSm,
              child: SizedBox(height: 140, child: preview),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          OutlinedButton.icon(
            onPressed: onPick,
            icon: const Icon(Icons.photo_camera_outlined),
            label: const Text('Choose image'),
          ),
        ],
      ),
    );
  }
}

class AppOtpInput extends StatefulWidget {
  const AppOtpInput({
    super.key,
    required this.length,
    required this.onCompleted,
    this.label = 'OTP',
  });

  final int length;
  final ValueChanged<String> onCompleted;
  final String label;

  @override
  State<AppOtpInput> createState() => _AppOtpInputState();
}

class _AppOtpInputState extends State<AppOtpInput> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _nodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _nodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  void _onChanged(int index, String value) {
    if (value.length == 1 && index < widget.length - 1) {
      _nodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _nodes[index - 1].requestFocus();
    }
    final code = _controllers.map((c) => c.text).join();
    if (code.length == widget.length) {
      widget.onCompleted(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppFieldFrame(
      label: widget.label,
      child: Row(
        children: [
          for (var i = 0; i < widget.length; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: TextField(
                controller: _controllers[i],
                focusNode: _nodes[i],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(counterText: ''),
                onChanged: (v) => _onChanged(i, v),
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class AppMultiSelect<T> extends StatelessWidget {
  const AppMultiSelect({
    super.key,
    required this.options,
    required this.labels,
    required this.selected,
    required this.onChanged,
    this.label,
  });

  final List<T> options;
  final List<String> labels;
  final Set<T> selected;
  final ValueChanged<Set<T>> onChanged;
  final String? label;

  @override
  Widget build(BuildContext context) {
    assert(options.length == labels.length);
    return AppFieldFrame(
      label: label,
      child: Wrap(
        spacing: AppSpacing.xs,
        runSpacing: AppSpacing.xs,
        children: [
          for (var i = 0; i < options.length; i++)
            FilterChip(
              label: Text(labels[i]),
              selected: selected.contains(options[i]),
              onSelected: (sel) {
                final next = {...selected};
                if (sel) {
                  next.add(options[i]);
                } else {
                  next.remove(options[i]);
                }
                onChanged(next);
              },
            ),
        ],
      ),
    );
  }
}
