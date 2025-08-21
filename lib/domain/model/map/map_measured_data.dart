import 'package:json_annotation/json_annotation.dart';

import '../../../common/utils/convert.dart';

part 'map_measured_data.g.dart';

@JsonSerializable()
class MapMeasuredData {
  final int idx;
  @JsonKey(name: 'lat')
  final double latitude;
  @JsonKey(name: 'lng')
  final double longitude;
  @JsonKey(
    fromJson: Convert.dynamicToInt,
  )
  final int pci;
  @JsonKey(
    name: 'rp',
    fromJson: Convert.dynamicToDouble,
  )
  final double rsrp;

  @JsonKey(
    name: 'dltp',
    fromJson: Convert.dynamicToDouble,
  )
  final double dltp;

  final String cells;

  MapMeasuredData({
    required this.idx,
    required this.latitude,
    required this.longitude,
    required this.pci,
    required this.rsrp,
    required this.dltp,
    this.cells = '',
  });

  factory MapMeasuredData.fromJson(Map<String, dynamic> json) {
    return _$MapMeasuredDataFromJson(json);
  }

  Map<String, dynamic> toJson() => _$MapMeasuredDataToJson(this);

  String getCells() {
    if (cells.isEmpty) return '';
    final regex = RegExp(r'\((-?\d+\.\d+)\)');
    return cells.replaceAllMapped(regex, (match) {
      final numStr = match.group(1); // 괄호 안 숫자 문자열
      if (numStr == null) return match.group(0)!;
      final numValue = double.parse(numStr);
      final rounded = (numValue * 10).round() / 10;
      return '(${rounded.toStringAsFixed(1)})';
    });
  }
}
