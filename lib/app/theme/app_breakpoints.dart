/// Layout breakpoints for phone / large phone / tablet.
class AppBreakpoints {
  AppBreakpoints._();

  static const double phone = 600;
  static const double largePhone = 840;
  static const double tablet = 1024;

  static bool isPhone(double width) => width < phone;
  static bool isTablet(double width) => width >= tablet;
  static bool isCompact(double width) => width < largePhone;
}
