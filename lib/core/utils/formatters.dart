import 'package:intl/intl.dart';

/// Shared number and currency formatting for operational metrics.
class AppFormatters {
  AppFormatters._();

  static String compactNumber(num value) {
    return NumberFormat.compact(locale: 'en').format(value);
  }

  /// Formats a billion-scale LKR amount such as `LKR 12.5 B`.
  static String lkrBillions(double billions) {
    return 'LKR ${billions.toStringAsFixed(1)} B';
  }

  static String percent(double value, {int digits = 1}) {
    return '${value.toStringAsFixed(digits)}%';
  }

  static String gwh(double value) {
    return '${value.toStringAsFixed(0)} GWh';
  }
}
