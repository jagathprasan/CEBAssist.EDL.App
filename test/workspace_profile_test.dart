import 'package:electricity_board_erp/app/router/app_routes.dart';
import 'package:electricity_board_erp/shared/models/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('office workspace uses shared components', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await TestApp.pump(
      tester,
      initialLocation: AppRoutes.officeWorkspace,
      seededUser: UserProfile.sample,
    );
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Office Workspace'), findsWidgets);
    expect(find.text('Review assignments'), findsOneWidget);
    expect(find.text('Open tickets'), findsOneWidget);
  });

  testWidgets('field workspace uses large simple actions', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await TestApp.pump(
      tester,
      initialLocation: AppRoutes.fieldWorkspace,
      seededUser: UserProfile.sample,
    );
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Field Workspace'), findsWidgets);
    expect(find.text('Start job'), findsOneWidget);
    expect(find.text('Report issue'), findsOneWidget);
  });

  testWidgets('profile shows directory fields', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await TestApp.pump(
      tester,
      initialLocation: AppRoutes.profile,
      seededUser: UserProfile.sample,
    );
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Thihara Kumarasinghe'), findsWidgets);
    expect(find.text('Edit contact details'), findsOneWidget);
    expect(find.text('Change password'), findsOneWidget);
    expect(find.text('Username / PF'), findsOneWidget);
    expect(find.text('Company'), findsOneWidget);
  });
}
