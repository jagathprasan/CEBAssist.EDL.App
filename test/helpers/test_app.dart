import 'package:electricity_board_erp/app/app.dart';
import 'package:electricity_board_erp/app/router/app_router.dart';
import 'package:electricity_board_erp/core/services/local_storage_service.dart';
import 'package:electricity_board_erp/features/authentication/presentation/providers/auth_provider.dart';
import 'package:electricity_board_erp/shared/models/user_profile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fake_auth_repository.dart';

class TestApp {
  TestApp._();

  static Future<ProviderContainer> pump(
    WidgetTester tester, {
    String? initialLocation,
    UserProfile? seededUser,
    bool skipAuthBootstrap = true,
    Map<String, Object> prefs = const {},
  }) async {
    GoogleFonts.config.allowRuntimeFetching = false;
    SharedPreferences.setMockInitialValues(prefs);
    final preferences = await SharedPreferences.getInstance();
    final fakeAuth = FakeAuthRepository();

    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(preferences),
        skipAuthBootstrapProvider.overrideWithValue(skipAuthBootstrap),
        seededUserProvider.overrideWithValue(seededUser),
        simulatedNetworkDelayProvider.overrideWithValue(Duration.zero),
        splashDelayProvider.overrideWithValue(Duration.zero),
        initialLocationProvider.overrideWithValue(initialLocation),
        authRepositoryProvider.overrideWithValue(fakeAuth),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const ElectricityBoardApp(),
      ),
    );
    await tester.pump();
    return container;
  }
}

Future<void> pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 3),
}) async {
  final end = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 50));
    if (finder.evaluate().isNotEmpty) return;
  }
  throw TestFailure('Could not find $finder before timeout.');
}
