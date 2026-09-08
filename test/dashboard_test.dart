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
            value: '—',
            label: 'Active Consumers',
            trendLabel: 'Live data coming soon',
            color: Color(0xFF0B5ED7),
          ),
        ),
      ),
    );

    expect(find.text('—'), findsOneWidget);
    expect(find.text('Active Consumers'), findsOneWidget);
    expect(find.text('Live data coming soon'), findsOneWidget);
  });

  testWidgets('dashboard shows a couple of placeholder cards', (tester) async {
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
    expect(find.text('Active Outages'), findsOneWidget);
    expect(find.text('—'), findsNWidgets(2));
    expect(find.text('Live data coming soon'), findsNWidgets(2));
    expect(find.text('Project Monitoring Dashboard'), findsNothing);
    expect(find.text('1.28M'), findsNothing);
    expect(find.text('84,562'), findsNothing);
  });
}
