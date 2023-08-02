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
