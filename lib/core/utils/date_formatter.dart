/// Date formatting utilities.
///
/// Provides consistent date formatting throughout the app.
library;

import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  /// Format date as "Jan 5, 2026"
  static String formatDate(DateTime date) {
    return DateFormat.yMMMd().format(date);
  }

  /// Format date as "Jan 5, 2026 at 3:45 PM"
  static String formatDateTime(DateTime date) {
    return DateFormat.yMMMd().add_jm().format(date);
  }

  /// Format time as "3:45 PM"
  static String formatTime(DateTime date) {
    return DateFormat.jm().format(date);
  }

  /// Format relative time (e.g., "2 hours ago", "Yesterday")
  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return DateFormat.EEEE().format(date); // Day name (Monday, Tuesday, etc.)
    } else {
      return formatDate(date);
    }
  }

  /// Format for note card display - shows relative or date based on age
  static String formatForCard(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return formatTime(date);
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return DateFormat.E().format(date); // Short day name (Mon, Tue, etc.)
    } else {
      return DateFormat.MMMd().format(date); // Jan 5
    }
  }
}
