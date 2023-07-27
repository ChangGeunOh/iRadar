import 'package:json_annotation/json_annotation.dart';

part 'base_data.g.dart';

@JsonSerializable()
class BaseData {
  final int idx;
  final String id;
  final String rnm;
  final int pci;
  @JsonKey(name: 'lat')
  final double latitude;
  @JsonKey(name: 'lng')
  final double longitude;

  BaseData({
    required this.idx,
    required this.id,
    required this.rnm,
    required this.pci,
    required this.latitude,
    required this.longitude,
  });

  factory BaseData.fromJson(Map<String, dynamic> json) => _$BaseDataFromJson(json);
  Map<String, dynamic> toJson() => _$BaseDataToJson(this);


}