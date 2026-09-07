import 'package:intl/intl.dart';

/// Date helpers used by dashboard greetings and activity timestamps.
extension DateTimeX on DateTime {
  String get greeting {
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  String get longDate => DateFormat.yMMMMEEEEd().format(this);

  String get shortDate => DateFormat.yMMMd().format(this);

  String get timeOfDay => DateFormat.jm().format(this);

  String get relativeLabel {
    final now = DateTime.now();
    final difference = now.difference(this);
    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes} min ago';
    if (difference.inHours < 24) return '${difference.inHours} hr ago';
    if (difference.inDays == 1) return 'Yesterday';
    if (difference.inDays < 7) return '${difference.inDays} days ago';
    return shortDate;
  }
}
