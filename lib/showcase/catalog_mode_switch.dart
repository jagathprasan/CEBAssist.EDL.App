import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../app/router/app_routes.dart';
import '../app/theme/app_spacing.dart';
import '../shared/widgets/widgets.dart';

/// Toggle between Field and Office catalogs on the same data.
class CatalogModeSwitch extends StatelessWidget {
  const CatalogModeSwitch({super.key, required this.current});

  final AppUiMode current;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      elevated: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Compare the same section in ${current.label} mode',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppToggleGroup(
            options: const ['Field', 'Office'],
            selected: current.label,
            onChanged: (value) {
              context.go(
                value == 'Field'
                    ? AppRoutes.fieldWidgetShowcase
                    : AppRoutes.officeWidgetShowcase,
              );
            },
          ),
        ],
      ),
    );
  }
}
