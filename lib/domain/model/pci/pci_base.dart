import 'package:json_annotation/json_annotation.dart';

part 'pci_base.g.dart';

@JsonSerializable()
class PciBase {
  final String rnm;
  final String code;
  @JsonKey(name: 'lat')
  final double latitude;
  @JsonKey(name: 'lng')
  final double longitude;
  final double distance;

  PciBase({
    required this.rnm,
    required this.code,
    required this.latitude,
    required this.longitude,
    required this.distance,
  });
  factory PciBase.fromJson(Map<String, dynamic> json) =>
      _$PciBaseFromJson(json);

  Map<String, dynamic> toJson() => _$PciBaseToJson(this);
}
