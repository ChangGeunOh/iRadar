import 'package:googlemap/domain/model/enum/location_type.dart';
import 'package:googlemap/domain/model/enum/wireless_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'merge_data.g.dart';

@JsonSerializable()
class MergeData {

  final String name;

  @JsonKey(
    name: 'wireless_type',
  )
  final WirelessType wirelessType;
  @JsonKey(
    name: 'location_type',
  )
  final LocationType locationType;
  @JsonKey(
    name: 'lat',
  )
  final double latitude;
  @JsonKey(
    name: 'lng',
  )
  final double longitude;
  @JsonKey(
    name: 'dt',
  )
  final DateTime measuredAt;
  final List<int> data;

  MergeData({
    required this.name,
    required this.wirelessType,
    required this.locationType,
    required this.latitude,
    required this.longitude,
    required this.measuredAt,
    required this.data,
  });

  factory MergeData.fromJson(Map<String, dynamic> json) => _$MergeDataFromJson(json);

  Map<String, dynamic> toJson() => _$MergeDataToJson(this);

}