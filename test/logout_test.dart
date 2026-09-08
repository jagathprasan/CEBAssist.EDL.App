import 'package:electricity_board_erp/app/router/app_routes.dart';
import 'package:electricity_board_erp/features/authentication/presentation/providers/auth_provider.dart';
import 'package:electricity_board_erp/shared/models/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('logout clears the session and returns to login', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = await TestApp.pump(
      tester,
      initialLocation: AppRoutes.settings,
      seededUser: UserProfile.sample,
    );

    expect(container.read(authProvider).isAuthenticated, isTrue);

    final logoutButton = find.widgetWithText(FilledButton, 'Logout');
    await tester.ensureVisible(logoutButton);
    await tester.tap(logoutButton);
    await tester.pumpAndSettle();

    expect(find.text('Sign out?'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Logout').last);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(container.read(authProvider).isAuthenticated, isFalse);
    expect(find.text('Welcome'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
  });
}
