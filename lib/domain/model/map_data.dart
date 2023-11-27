import 'package:json_annotation/json_annotation.dart';

part 'map_data.g.dart';

@JsonSerializable()
class MapData {
  final int idx;
  @JsonKey(name: 'lat')
  final double latitude;
  @JsonKey(name: 'lng')
  final double longitude;
  final int pci;
  final int pci5;
  @JsonKey(name: 'rp5')
  final double rsrp5;

  MapData({
    required this.idx,
    required this.latitude,
    required this.longitude,
    required this.pci,
    required this.pci5,
    required this.rsrp5,
  });
  
  Map<String, dynamic> toJson() => _$MapDataToJson(this);
  factory MapData.fromJson(Map<String, dynamic> json) => _$MapDataFromJson(json);

}
