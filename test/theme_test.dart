import 'package:electricity_board_erp/app/router/app_routes.dart';
import 'package:electricity_board_erp/shared/models/user_profile.dart';
import 'package:electricity_board_erp/shared/providers/theme_mode_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('theme mode switches immediately from settings', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = await TestApp.pump(
      tester,
      initialLocation: AppRoutes.settings,
      seededUser: UserProfile.sample,
    );

    expect(container.read(themeModeProvider), ThemeMode.system);

    await tester.tap(find.text('Dark'));
    await tester.pump();

    expect(container.read(themeModeProvider), ThemeMode.dark);

    await tester.tap(find.text('Light'));
    await tester.pump();

    expect(container.read(themeModeProvider), ThemeMode.light);
  });
}
