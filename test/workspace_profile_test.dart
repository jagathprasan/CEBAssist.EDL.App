import 'package:electricity_board_erp/app/router/app_routes.dart';
import 'package:electricity_board_erp/shared/models/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> scrollTo(WidgetTester tester, Finder finder) async {
    await tester.scrollUntilVisible(
      finder,
      400,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump();
  }

  testWidgets('office workspace shows shared kit sections', (tester) async {
    tester.view.physicalSize = const Size(1080, 3200);
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
    expect(find.text('Jobs'), findsOneWidget);

    await scrollTo(tester, find.text('Posts'));
    expect(find.text('Posts'), findsOneWidget);

    await scrollTo(tester, find.text('Schedule'));
    expect(find.text('Schedule'), findsOneWidget);

    await scrollTo(tester, find.text('Work form'));
    expect(find.text('Work form'), findsOneWidget);
  });

  testWidgets('field workspace shows large shared kit sections', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 3200);
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

    await scrollTo(tester, find.text('Navigate'));
    expect(find.text('Navigate'), findsOneWidget);

    await scrollTo(tester, find.text('Up next'));
    expect(find.text('Up next'), findsOneWidget);

    await scrollTo(tester, find.text('Submit report'));
    expect(find.text('Submit report'), findsOneWidget);
  });
}
