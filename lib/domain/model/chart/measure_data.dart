import 'package:flutter/animation.dart';
import 'package:googlemap/domain/model/chart/base_data.dart';
import 'package:googlemap/domain/model/enum/wireless_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'measure_data.g.dart';

@JsonSerializable()
class MeasureData {
  final String pci;
  final String nPci;
  final double? mw;
  final int nTime;
  final double nRsrp;
  final int? sTime;
  final double? rp;
  final int? freq;
  final double? ca;
  final double? cqi;
  final double? ri;
  final double? dlMcs;
  final double? dlLayer;
  final double? dlRb;
  final double? dlTp;
  final double inIndex;
  final List<BaseData> baseList;

  MeasureData({
    required this.pci,
    this.nPci = '',
    this.mw,
    required this.nTime,
    required this.nRsrp,
    this.sTime,
    this.rp,
    this.freq,
    this.ca,
    this.cqi,
    this.ri,
    this.dlMcs,
    this.dlLayer,
    this.dlRb,
    this.dlTp,
    required this.inIndex,
    List<BaseData>? baseList,
  }) : baseList = baseList ?? [];

  factory MeasureData.fromJson(Map<String, dynamic> json) =>
      _$MeasureDataFromJson(json);

  Map<String, dynamic> toJson() => _$MeasureDataToJson(this);

  List<String> getValues(WirelessType type) {
    List<String> commonValues = [
      nTime.toString(),
      nRsrp.toStringAsFixed(1),
      inIndex.toStringAsFixed(0),
      sTime?.toString() ?? '-',
      rp?.toStringAsFixed(1) ?? '-',
      cqi?.toStringAsFixed(1) ?? '-',
      ri?.toStringAsFixed(1) ?? '-',
      dlMcs?.toStringAsFixed(1) ?? '-',
      dlRb?.toStringAsFixed(1) ?? '-',
      dlTp?.toStringAsFixed(1) ?? '-',
    ];

    if (type == WirelessType.wLte) {
      commonValues.insert(4, freq?.toString() ?? '-');
      commonValues.insert(5, ca?.toStringAsFixed(1) ?? '-');
    } else {
      commonValues.insert(8, dlLayer?.toStringAsFixed(1) ?? '-');
    }
    return commonValues;
  }

  List<String> getRowValues(WirelessType type) {
    var values = getValues(type)..insertAll(0, [pci, nPci]);
    var distances = baseList.map((e) => e.distance.toStringAsFixed(2)).toList();
    var names = baseList.map((e) => e.name).toList();
    var codes = baseList.map((e) => e.code).toList();
    return [...values, distances.join('\n'), names.join('\n'), codes.join('\n')];
  }

  MeasureData copyWith({
    String? pci,
    String? nPci,
    double? mw,
    int? nTime,
    double? nRsrp,
    int? sTime,
    double? rp,
    int? freq,
    double? ca,
    double? cqi,
    double? ri,
    double? dlMcs,
    double? dlLayer,
    double? dlRb,
    double? dlTp,
    double? inIndex,
    List<BaseData>? baseList,
  }) {
    return MeasureData(
      pci: pci ?? this.pci,
      nPci: nPci ?? this.nPci,
      mw: mw ?? this.mw,
      nTime: nTime ?? this.nTime,
      nRsrp: nRsrp ?? this.nRsrp,
      sTime: sTime ?? this.sTime,
      rp: rp ?? this.rp,
      freq: freq ?? this.freq,
      ca: ca ?? this.ca,
      cqi: cqi ?? this.cqi,
      ri: ri ?? this.ri,
      dlMcs: dlMcs ?? this.dlMcs,
      dlLayer: dlLayer ?? this.dlLayer,
      dlRb: dlRb ?? this.dlRb,
      dlTp: dlTp ?? this.dlTp,
      inIndex: inIndex ?? this.inIndex,
      baseList: baseList ?? this.baseList,
    );
  }

  bool get hasColor => sTime != null || nPci.isNotEmpty;
}
