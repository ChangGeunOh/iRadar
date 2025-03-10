import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../const/network.dart';
import 'dart:html' as html;


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


String hashPassword(String password, String secretKey) {
  var key = utf8.encode(secretKey);
  var bytes = utf8.encode(password);

  var hmacSha256 = Hmac(sha256, key);
  var digest = hmacSha256.convert(bytes);

  return digest.toString();
}

String get baseUrl {
  const isDebug = bool.fromEnvironment("dart.vm.product") == false;
  return isDebug ? kNetworkDebugBaseUrl : kNetworkReleaseBaseUrl;
}

Future<void> downloadFile(String fileName) async {
  ByteData data =
  await rootBundle.load('assets/files/$fileName');
  final buffer = data.buffer;
  final bytes = buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  final blob = html.Blob([bytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  html.AnchorElement(href: url)
    ..setAttribute("download", fileName)
    ..click();
  html.Url.revokeObjectUrl(url);
}