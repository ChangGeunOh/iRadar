import 'package:json_annotation/json_annotation.dart';

part 'measure_data.g.dart';

@JsonSerializable()
class MeasureData {
  final int idx;
  @JsonKey(name: 'lat')
  final double latitude;
  @JsonKey(name: 'lng')
  final double longitude;
  final int pci;
  final int pci5;
  @JsonKey(name: 'rp5')
  final double rsrp5;

  MeasureData({
    required this.idx,
    required this.latitude,
    required this.longitude,
    required this.pci,
    required this.pci5,
    required this.rsrp5,
  });
  
  Map<String, dynamic> toJson() => _$MeasureDataToJson(this);
  factory MeasureData.fromJson(Map<String, dynamic> json) => _$MeasureDataFromJson(json);

}
