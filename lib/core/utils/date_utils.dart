import 'package:intl/intl.dart';

class AppDateUtils {
  static String formatTime(DateTime dateTime, {bool use24Hour = false}) {
    if (use24Hour) {
      return DateFormat('HH:mm').format(dateTime);
    } else {
      return DateFormat('hh:mm a').format(dateTime);
    }
  }

  static String formatDate(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy').format(dateTime);
  }

  static String formatDayMonth(DateTime dateTime) {
    return DateFormat('MMM dd').format(dateTime);
  }

  static String getHourFromTimestamp(int timestamp) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('HH:00').format(dateTime);
  }

  static String getTimeFromTimestamp(int timestamp, {bool use24Hour = false}) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return formatTime(dateTime, use24Hour: use24Hour);
  }
}
