import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../authentication/presentation/providers/auth_provider.dart';
import '../../data/mock_dashboard_repository.dart';
import '../../domain/dashboard_models.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return MockDashboardRepository(
    delay: ref.watch(simulatedNetworkDelayProvider),
  );
});

final dashboardProvider = FutureProvider<DashboardSnapshot>((ref) {
  return ref.watch(dashboardRepositoryProvider).fetchDashboard();
});
