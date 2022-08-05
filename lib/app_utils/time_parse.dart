import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class TimeParse {
  static DateTime parseTime(dynamic date) {
    DateTime dateTime = DateTime.now();
    if (date is DateTime) {
      dateTime = date;
    }
    if (date is Timestamp) {
      dateTime = date.toDate();
    }
    return dateTime;
  }

  static String formatTimeToString(dynamic date) {
    if (date == null) {
      String timeFormattedDate = DateFormat('yMMMd').format(DateTime.now());
      String timeFormattedHrsMins = DateFormat().add_jm().format(DateTime.now());
      String timeFormatted = timeFormattedDate;
      //  String timeFormatted = timeFormattedDate + ' - ' + timeFormattedHrsMins;
      return timeFormatted;
    } else {
      DateTime dateTime = parseTime(date);
      String timeFormattedDate = DateFormat('yMMMd').format(dateTime);
      String timeFormattedHrsMins = DateFormat().add_jm().format(dateTime);
      // String timeFormatted = timeFormattedDate + ' - ' + timeFormattedHrsMins;
      String timeFormatted = timeFormattedDate;
      return timeFormatted;
    }
  }
}
