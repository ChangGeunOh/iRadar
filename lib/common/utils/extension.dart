import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' as math;

extension Date on int {
  String toDate({String? format}) {
    final dateFormat = format ?? 'yyyy/MM/dd';
    final dateTime = DateTime.fromMillisecondsSinceEpoch(this);
    return DateFormat(dateFormat).format(dateTime);
  }
}

extension DynamicToDouble on dynamic {
  double? toDouble() {
    return runtimeType == double ? this : toString().isEmpty ? null : double.parse(toString());
  }
}

extension StringToDouble on String {
  double? toDouble() {
    return isNotEmpty ? double.parse(this) : null;
  }
}

extension ExcelDateToDateTime on double {
  DateTime toDateTime() {
    // Excel의 기본 시작 날짜는 1900년 1월 1일입니다.
    final baseDate = DateTime(1899, 12, 30);

    // 주어진 excelDate에서 정수 부분은 날짜를, 소수점 부분은 시간을 나타냅니다.
    final days = floor();
    final dayFraction = this - days;

    // 기본 날짜에 일 수를 더하고, 소수점 부분을 사용하여 시간, 분, 초를 계산합니다.
    return baseDate.add(Duration(
        days: days,
        microseconds: (dayFraction * Duration.microsecondsPerDay).round()));
  }
}

extension LatLngDistance on LatLng {
  double distanceTo(LatLng latLng) {
    const double earthRadius = 6371.0; // 지구의
    double centerLat = latitude * (math.pi / 180.0);
    double centerLng = longitude * (math.pi / 180.0);

    double pointLat = latLng.latitude * (math.pi / 180.0);
    double pointLng = latLng.longitude * (math.pi / 180.0);

    double deltaLat = pointLat - centerLat;
    double deltaLng = pointLng - centerLng;
    double a = math.sin(deltaLat / 2) * math.sin(deltaLat / 2) +
        math.cos(centerLat) *
            math.cos(pointLat) *
            math.sin(deltaLng / 2) *
            math.sin(deltaLng / 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }
}
