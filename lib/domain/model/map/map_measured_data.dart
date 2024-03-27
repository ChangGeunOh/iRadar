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
    name: 'pci',
    fromJson: Convert.dynamicToInt,
  )
  final int pci;
  @JsonKey(
    name: 'pci5',
    fromJson: Convert.dynamicToInt,
  )
  final int pci5;
  @JsonKey(
    name: 'rp5',
    fromJson: Convert.dynamicToDouble,
  )
  final double rsrp5;

  MapMeasuredData({
    required this.idx,
    required this.latitude,
    required this.longitude,
    required this.pci,
    required this.pci5,
    required this.rsrp5,
  });

  factory MapMeasuredData.fromJson(Map<String, dynamic> json) =>
      _$MapMeasuredDataFromJson(json);

  Map<String, dynamic> toJson() => _$MapMeasuredDataToJson(this);
}
