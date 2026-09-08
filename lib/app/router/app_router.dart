import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/authentication/presentation/forgot_password_screen.dart';
import '../../features/authentication/presentation/login_screen.dart';
import '../../features/authentication/presentation/providers/auth_provider.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/modules/placeholder_module_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/shell/presentation/app_shell.dart';
import '../../features/splash/presentation/splash_screen.dart';
import '../../features/workspaces/field_workspace_screen.dart';
import '../../features/workspaces/office_workspace_screen.dart';
import '../../shared/widgets/widget_showcase_page.dart';
import 'app_routes.dart';

/// Optional start path used by widget tests.
final initialLocationProvider = Provider<String?>((ref) => null);

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<int>(0);
  ref.listen<AuthState>(authProvider, (_, _) {
    refresh.value++;
  });
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: ref.read(initialLocationProvider) ?? AppRoutes.splash,
    refreshListenable: refresh,
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final auth = ref.read(authProvider);
      final location = state.matchedLocation;
      final isPublic = AppRoutes.publicRoutes.contains(location);

      if (!auth.isInitialized) {
        return location == AppRoutes.splash ? null : AppRoutes.splash;
      }
      if (!auth.isAuthenticated && !isPublic) {
        return AppRoutes.login;
      }
      if (auth.isAuthenticated &&
          (location == AppRoutes.login ||
              location == AppRoutes.forgotPassword ||
              location == AppRoutes.splash)) {
        return AppRoutes.dashboard;
      }
      return null;
    },
    routes: [
      GoRoute(path: '/', redirect: (context, state) => AppRoutes.splash),
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: AppRoutes.officeWorkspace,
            builder: (context, state) => const OfficeWorkspaceScreen(),
          ),
          GoRoute(
            path: AppRoutes.fieldWorkspace,
            builder: (context, state) => const FieldWorkspaceScreen(),
          ),
          GoRoute(
            path: AppRoutes.notifications,
            builder: (context, state) => const NotificationsScreen(),
          ),
          GoRoute(
            path: AppRoutes.profile,
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: AppRoutes.settings,
            builder: (context, state) => const SettingsScreen(),
          ),
          if (kDebugMode)
            GoRoute(
              path: AppRoutes.widgetShowcase,
              builder: (context, state) => const WidgetShowcasePage(),
            ),
          ..._placeholderRoutes,
        ],
      ),
    ],
  );
});

final _placeholderRoutes =
    [
      AppRoutes.consumerServices,
      AppRoutes.meterManagement,
      AppRoutes.billing,
      AppRoutes.outageManagement,
      AppRoutes.projects,
      AppRoutes.inventory,
      AppRoutes.reports,
    ].map((route) {
      return GoRoute(
        path: route,
        builder: (context, state) => PlaceholderModuleScreen.forRoute(route),
      );
    });
