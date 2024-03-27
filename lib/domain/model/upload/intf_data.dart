import 'package:json_annotation/json_annotation.dart';

part 'intf_data.g.dart';

@JsonSerializable()
class IntfData {
  final int idx;
  final String area;
  final String pci;
  final DateTime dt;
  final double lat;
  final double lng;
  final double rp;
  final double rpmw;
  final String spci;
  final double srp;

  IntfData({
    required this.idx,
    required this.area,
    required this.pci,
    required this.dt,
    required this.lat,
    required this.lng,
    required this.rp,
    required this.rpmw,
    required this.spci,
    required this.srp,
  });
  
  Map<String, dynamic> toJson() => _$IntfDataToJson(this);
  factory IntfData.fromJson(Map<String, dynamic> json) => _$IntfDataFromJson(json);
}