import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

extension DateFormatString on String {
  /// to 'Thursday, 16th Oct 2025, 10:10 PM'
  String toReadableDateTime() {
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

  String toReadableNotificationDate() {
    try {
      final date = DateTime.parse(this).toLocal();

      final dayNum = DateFormat('d').format(date);

      final month = DateFormat('MMM').format(date);
      final time = DateFormat('h:mm a').format(date);
      return '$dayNum $month , $time';
    } catch (_) {
      return this;
    }
  }

  Future<void> openLink() async {
    final url = Uri.parse(this);
    if (await launchUrl(url)) {
      throw Exception("Could not launch $url");
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

  bool isExpired() {
    if (isEmpty) return false;

    DateTime? matchDt;

    try {
      matchDt = DateTime.parse(toString()).toUtc();
    } catch (_) {
      return false;
    }

    return matchDt.isBefore(DateTime.now().toUtc());
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

  String toFormattedPrice() {
    try {
      final number = double.parse(this);
      if (number >= 1000) {
        return '${NumberFormat('#,##0').format(number)} Ks';
      }
      return NumberFormat('#,##0').format(number);
    } catch (_) {
      return this;
    }
  }
}
