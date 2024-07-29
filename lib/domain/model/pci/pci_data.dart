import 'package:json_annotation/json_annotation.dart';

part 'pci_data.g.dart';

@JsonSerializable()
class PciData {
  final String pci;
  @JsonKey(name: 'rp')
  final double rsrp;
  @JsonKey(name: 'lat')
  final double latitude;
  @JsonKey(name: 'lng')
  final double longitude;

  PciData({
    required this.pci,
    required this.rsrp,
    required this.latitude,
    required this.longitude,
  });

  factory PciData.fromJson(Map<String, dynamic> json) => _$PciDataFromJson(json);
  Map<String, dynamic> toJson() => _$PciDataToJson(this);
}