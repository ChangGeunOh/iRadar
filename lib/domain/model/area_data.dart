import 'package:googlemap/domain/model/wireless_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'area_data.g.dart';

@JsonSerializable()
class AreaData {
  final WirelessType type;
  final String area;
  final String date;

  AreaData({
    required this.type,
    required this.area,
    required this.date,
});
  factory AreaData.fromJson(Map<String, dynamic> json) => _$AreaDataFromJson(json);
  Map<String, dynamic> toJson() => _$AreaDataToJson(this);
}