import 'package:json_annotation/json_annotation.dart';

import 'pci_base.dart';
import 'pci_data.dart';

part 'pci_base_data.g.dart';

@JsonSerializable()
class PciBaseData {

  @JsonKey(name: 'spci')
  final List<PciData> sPciDataList;
  @JsonKey(name: 'npci')
  final List<PciData> nPciDataList;
  @JsonKey(name: 'base')
  final List<PciBase> pciBaseList;
  final Position position;

  PciBaseData({
    required this.sPciDataList,
    required this.nPciDataList,
    required this.pciBaseList,
    required this.position,
  });

  factory PciBaseData.fromJson(Map<String, dynamic> json) => _$PciBaseDataFromJson(json);
  Map<String, dynamic> toJson() => _$PciBaseDataToJson(this);
}

@JsonSerializable()
class Position {
  @JsonKey(name: 'lat')
  final double latitude;
  @JsonKey(name: 'lng')
  final double longitude;

  Position({
    required this.latitude,
    required this.longitude,
  });

  factory Position.fromJson(Map<String, dynamic> json) => _$PositionFromJson(json);
  Map<String, dynamic> toJson() => _$PositionToJson(this);
}