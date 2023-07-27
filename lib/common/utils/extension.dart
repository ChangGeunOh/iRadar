import 'package:intl/intl.dart';

extension Date on int {
  String toDate({String? format}) {
    final dateFormat = format ?? 'yyyy/MM/dd';
    final dateTime = DateTime.fromMillisecondsSinceEpoch(this);
    return DateFormat(dateFormat).format(dateTime);
  }
}