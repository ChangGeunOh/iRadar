import 'package:json_annotation/json_annotation.dart';

part 'intf_tt_data.g.dart';

@JsonSerializable()
class IntfTtData {
  final int idx;
  final String area;
  final double? lat;
  final double? lng;

  final String cells5;

  final String? pci5;
  final double? rp5;

  final String cells;

  final String? pci;
  final double? rp;

  final double? cqi5;
  final double? ri5;
  final double? dlmcs5;
  final double? dll5;
  final double? dlrb5;
  final double? dltp5;

  final int? ear;
  final int? ca;
  final double? cqi;
  final double? ri;
  final double? dlmcs;
  final double? dlrb;
  final double? dltp;

  final DateTime? dt;


  IntfTtData({
    required this.idx,
    required this.area,
    required this.lat,
    required this.lng,

    required this.cells5,

    required this.pci5,
    required this.rp5,

    required this.cells,
    required this.pci,
    required this.rp,

    required this.cqi5,
    required this.ri5,
    required this.dlmcs5,
    required this.dll5,
    required this.dlrb5,
    required this.dltp5,

    required this.ear,
    required this.ca,
    required this.cqi,
    required this.ri,
    required this.dlmcs,
    required this.dlrb,
    required this.dltp,
    required this.dt,
  });

  factory IntfTtData.fromJson(Map<String, dynamic> json) => _$IntfTtDataFromJson(json);
  Map<String, dynamic> toJson() => _$IntfTtDataToJson(this);
}