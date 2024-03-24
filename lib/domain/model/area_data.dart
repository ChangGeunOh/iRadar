import 'package:googlemap/domain/model/enum/location_type.dart';
import 'package:googlemap/domain/model/enum/wireless_type.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../common/utils/convert.dart';

part 'area_data.g.dart';

@JsonSerializable()
class AreaData {
  final int idx;
  final String name;
  final WirelessType type;
  final LocationType division;
  @JsonKey(
    name: 'created_at',
    fromJson: Convert.dynamicToDateTime,
  )
  final DateTime date;

  AreaData({
    required this.idx,
    required this.name,
    required this.date,
    required this.division,
    required this.type,
  });

  factory AreaData.fromJson(Map<String, dynamic> json) =>
      _$AreaDataFromJson(json);

  Map<String, dynamic> toJson() => _$AreaDataToJson(this);
}