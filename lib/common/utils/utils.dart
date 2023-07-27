import 'package:intl/intl.dart';

// 문자열 중에서 숫자만 추출
String getNumbersFromString(String inputString) {
  RegExp regex = RegExp(r'\d+(\.\d+)?');
  Iterable<Match> matches = regex.allMatches(inputString);
  String extractedNumbers = '';

  for (Match match in matches) {
    extractedNumbers += match.group(0)!;
  }

  return extractedNumbers;
}

// 문자열 알짜와 오늘 날짜 차이
int calculateDaysDifference(String dateString) {
  DateTime selectedDate = DateFormat('yyyy.MM.dd').parse(dateString);
  DateTime currentDate = DateTime.now();
  Duration difference = selectedDate.difference(currentDate);
  int daysDifference = difference.inDays;

  return daysDifference;
}