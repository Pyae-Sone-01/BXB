import 'package:intl/intl.dart';

extension DateFormatString on String {
  /// to 'Thursday, 16th Oct 2025, 10:10 PM'
  String toReadableDateTime() {
    /// Converts ISO8601 string (e.g. 2025-10-16T15:10:00.000000Z)
    /// to '01-08-2025, 01:12 PM' format

    try {
      final date = DateTime.parse(this).toLocal();
      final day = DateFormat('EEEE').format(date);
      final dayNum = DateFormat('d').format(date);
      final daySuffix = _getDayOfMonthSuffix(date.day);
      final month = DateFormat('MMM').format(date);
      final year = DateFormat('y').format(date);
      final time = DateFormat('h:mm a').format(date);
      return '$day, $dayNum$daySuffix $month , $time';
    } catch (_) {
      return this;
    }
  }

  String toShortDateTime() {
    try {
      final date = DateTime.parse(this).toLocal();
      return DateFormat('dd-MM-yyyy, hh:mm a').format(date);
    } catch (_) {
      return this;
    }
  }

  String _getDayOfMonthSuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}
