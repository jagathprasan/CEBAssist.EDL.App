import 'package:electricity_board_erp/app/router/app_routes.dart';
import 'package:electricity_board_erp/core/utils/validators.dart';
import 'package:electricity_board_erp/features/authentication/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/test_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Login validation', () {
    test('rejects empty username and password', () {
      expect(Validators.username(''), isNotNull);
      expect(Validators.username('   '), isNotNull);
      expect(Validators.password(''), isNotNull);
    });

    test('accepts CEBAssist usernames and rejects weak passwords', () {
      expect(Validators.username('edl.user'), isNull);
      expect(Validators.username('name@edl.la'), isNull);
      expect(Validators.username('ab'), isNull);
      expect(Validators.username('a'), isNotNull);
      expect(Validators.password('1234'), isNotNull);
      expect(Validators.password('SecurePass1'), isNull);
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

      expect(find.text('Please enter your username.'), findsOneWidget);
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

      await tester.enterText(find.byType(TextFormField).at(0), 'edl.user');
      await tester.enterText(find.byType(TextFormField).at(1), 'SecurePass1');
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

      await tester.enterText(find.byType(TextFormField).at(0), 'wrong.user');
      await tester.enterText(find.byType(TextFormField).at(1), 'bad-password');
      await tester.tap(find.text('Sign In'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(container.read(authProvider).isAuthenticated, isFalse);
      expect(find.textContaining('We could not sign you in'), findsOneWidget);
    });
  });
}
