import 'package:electricity_board_erp/app/router/app_routes.dart';
import 'package:electricity_board_erp/core/constants/app_constants.dart';
import 'package:electricity_board_erp/core/utils/validators.dart';
import 'package:electricity_board_erp/features/authentication/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Login validation', () {
    test('rejects empty identifier and password', () {
      expect(Validators.identifier(''), isNotNull);
      expect(Validators.identifier('   '), isNotNull);
      expect(Validators.password(''), isNotNull);
    });

    test('rejects malformed email and accepts valid credentials format', () {
      expect(Validators.identifier('not-an-email'), isNotNull);
      expect(Validators.identifier(AppConstants.demoUsername), isNull);
      expect(Validators.identifier('04207'), isNull);
      expect(Validators.password('123'), isNotNull);
      expect(Validators.password(AppConstants.demoPassword), isNull);
    });

    testWidgets('shows validation messages when submitting an empty form', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await TestApp.pump(tester, initialLocation: AppRoutes.login);
      await tester.tap(find.text('Sign In'));
      await tester.pump();

      expect(
        find.text('Please enter your employee ID or email.'),
        findsOneWidget,
      );
      expect(find.text('Please enter your password.'), findsOneWidget);
    });
  });

  group('Login authentication', () {
    testWidgets('signs in with valid credentials and authenticates the user', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final container = await TestApp.pump(
        tester,
        initialLocation: AppRoutes.login,
      );

      await tester.enterText(
        find.byType(TextFormField).at(0),
        AppConstants.demoUsername,
      );
      await tester.enterText(
        find.byType(TextFormField).at(1),
        AppConstants.demoPassword,
      );
      await tester.tap(find.text('Sign In'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(container.read(authProvider).isAuthenticated, isTrue);
      expect(
        container.read(authProvider).user?.fullName,
        'Thihara Kumarasinghe',
      );
      expect(find.textContaining('Good'), findsOneWidget);
    });

    testWidgets('shows a professional error for invalid credentials', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final container = await TestApp.pump(
        tester,
        initialLocation: AppRoutes.login,
      );

      await tester.enterText(
        find.byType(TextFormField).at(0),
        'wrong@electricity.lk',
      );
      await tester.enterText(find.byType(TextFormField).at(1), 'bad-password');
      await tester.tap(find.text('Sign In'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(container.read(authProvider).isAuthenticated, isFalse);
      expect(find.textContaining('We could not sign you in'), findsOneWidget);
    });
  });
}
