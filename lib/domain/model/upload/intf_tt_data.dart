import 'dart:math';

import 'package:json_annotation/json_annotation.dart';

import '../../../common/utils/convert.dart';
import 'intf_data.dart';

part 'intf_tt_data.g.dart';

@JsonSerializable()
class IntfTtData {
  @JsonKey(
    name: 'idx',
    defaultValue: 0,
  )
  final int idx;
  @JsonKey(
    name: 'area',
    defaultValue: '',
  )
  final String area;
  final double? lat;
  final double? lng;

  final String cells5;

  @JsonKey(
    name: 'pci5',
    fromJson: Convert.dynamicToString,
  )
  final String? pci5;
  final double? rp5;

  final String cells;

  @JsonKey(
    name: 'pci',
    fromJson: Convert.dynamicToString,
  )
  final String? pci;
  final double? rp;

  final double? cqi5;
  @JsonKey(
    name: 'ri5',
    fromJson: Convert.dynamicToDouble,
  )
  final double? ri5;
  final double? dlmcs5;
  final double? dll5;
  final double? dlrb5;
  final double? dltp5;

  final int? ear;
  final int? ca;
  final double? cqi;
  @JsonKey(
    name: 'ri',
    fromJson: Convert.dynamicToInt,
  )
  final int? ri;
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

  factory IntfTtData.fromJson(Map<String, dynamic> json) =>
      _$IntfTtDataFromJson(json);

  Map<String, dynamic> toJson() => _$IntfTtDataToJson(this);

  List<IntfData> getIntfData({is5G = true}) {
    final data = is5G ? cells5 : cells;
    final intfDataList = <IntfData>[];
    final regex5g = is5G
        ? RegExp(r'(\d+)(?:\(([^)]+)\))?(?:\(([^)]+)\))?')
        : RegExp(r'(\d+)[\[\(]([^)\]]+)[\)\]][\[\(]([^)\]]+)[\)\]]');
    for (var match in regex5g.allMatches(data)) {
      try {
        final rp = double.parse(match.group(2)!);
        final spci = is5G ? pci5 : pci;
        final srp = is5G ? rp5 : rp;

        final intf5GData = IntfData(
          idx: 0,
          area: 'area',
          pci: match.group(1)!,
          dt: dt ?? DateTime.now(),
          lat: lat ?? 0,
          lng: lng ?? 0,
          rp: rp,
          rpmw: pow(10, rp / 10.0).toDouble(),
          spci: spci.toString(),
          srp: srp ?? 0,
        );
        intfDataList.add(intf5GData);
      } catch (e) {
        print('Error: $e');
      }
    }
    return intfDataList;
  }
}
