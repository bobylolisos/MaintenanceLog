import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  String toDateAndTime() {
    return toString().substring(0, 16);
  }

  String toDate() {
    return toString().substring(0, 10);
  }

  String toDateText() {
    return DateFormat.yMMMMd('sv').format(this);
  }

  String toTime() {
    return toString().substring(11, 16);
  }
}
