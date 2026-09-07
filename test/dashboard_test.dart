import 'package:electricity_board_erp/app/router/app_routes.dart';
import 'package:electricity_board_erp/app/theme/app_theme.dart';
import 'package:electricity_board_erp/core/widgets/app_summary_card.dart';
import 'package:electricity_board_erp/shared/models/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('summary card renders value, label, and trend', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: const Scaffold(
          body: AppSummaryCard(
            icon: Icons.groups_outlined,
            value: '1.28M',
            label: 'Active Consumers',
            trendLabel: '+1.4% this month',
            color: Color(0xFF0B5ED7),
          ),
        ),
      ),
    );

    expect(find.text('1.28M'), findsOneWidget);
    expect(find.text('Active Consumers'), findsOneWidget);
    expect(find.text('+1.4% this month'), findsOneWidget);
  });

  testWidgets('dashboard shows operational summary cards', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await TestApp.pump(
      tester,
      initialLocation: AppRoutes.dashboard,
      seededUser: UserProfile.sample,
    );
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Active Consumers'), findsOneWidget);
    expect(find.text('1.28M'), findsOneWidget);
    expect(find.text('Smart Meters Online'), findsOneWidget);
    expect(find.text('84,562'), findsOneWidget);
    expect(find.text('Open Complaints'), findsOneWidget);
    expect(find.text('326'), findsOneWidget);
    expect(find.text('Active Outages'), findsOneWidget);
    expect(find.text('18'), findsOneWidget);
    expect(find.text('Project Monitoring Dashboard'), findsOneWidget);
    expect(find.text('Active Projects'), findsOneWidget);
    expect(find.text('58'), findsOneWidget);
    expect(find.text('Needs Attention'), findsOneWidget);
    expect(find.text('Overdue'), findsWidgets);
  });
}
