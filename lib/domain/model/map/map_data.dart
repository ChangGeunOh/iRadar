import 'package:json_annotation/json_annotation.dart';

import 'map_base_data.dart';
import 'map_measured_data.dart';

part 'map_data.g.dart';

@JsonSerializable()
class MapData {
  @JsonKey(name: 'measured_data')
  final List<MapMeasuredData> measuredData;
  @JsonKey(name: 'base_data')
  final List<MapBaseData> baseData;

  MapData({
    required this.measuredData,
    required this.baseData,
  });

  factory MapData.fromJson(Map<String, dynamic> json) => _$MapDataFromJson(json);
  Map<String, dynamic> toJson() => _$MapDataToJson(this);

}
