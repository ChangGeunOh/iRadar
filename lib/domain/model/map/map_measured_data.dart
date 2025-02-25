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

  MapMeasuredData({
    required this.idx,
    required this.latitude,
    required this.longitude,
    required this.pci,
    required this.rsrp,
  });

  factory MapMeasuredData.fromJson(Map<String, dynamic> json) {
    return _$MapMeasuredDataFromJson(json);
  }

  Map<String, dynamic> toJson() => _$MapMeasuredDataToJson(this);
}
