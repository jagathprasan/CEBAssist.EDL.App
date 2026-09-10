/// Named routes used by go_router. Keep paths in one place.
class AppRoutes {
  AppRoutes._();

  static const String splash = '/splash';
  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';
  static const String dashboard = '/dashboard';
  static const String officeWorkspace = '/workspaces/office';
  static const String fieldWorkspace = '/workspaces/field';
  static const String notifications = '/notifications';
  static const String profile = '/profile';
  static const String settings = '/settings';

  static const String consumerServices = '/consumer-services';
  static const String meterManagement = '/meter-management';
  static const String billing = '/billing';
  static const String outageManagement = '/outage-management';
  static const String projects = '/projects';
  static const String inventory = '/inventory';
  static const String reports = '/reports';

  static const String widgetShowcase = '/dev/widget-showcase';
  static const String fieldWidgetShowcase = '/dev/widget-showcase/field';
  static const String officeWidgetShowcase = '/dev/widget-showcase/office';

  static const Set<String> publicRoutes = {splash, login, forgotPassword};

  static const Set<String> implementedRoutes = {
    splash,
    login,
    forgotPassword,
    dashboard,
    officeWorkspace,
    fieldWorkspace,
    notifications,
    profile,
    settings,
  };
}
