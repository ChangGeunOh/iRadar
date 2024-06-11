import 'package:googlemap/domain/model/chart/base_data.dart';
import 'package:googlemap/domain/model/enum/wireless_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'measure_data.g.dart';

@JsonSerializable()
class MeasureData {
  final String pci;
  final String nPci;
  final int nTime;
  final double nRsrp;
  final int? sTime;
  final double? rp;
  final int? freq;
  final int? ca;
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
    required this.nPci,
    required this.nTime,
    required this.nRsrp,
    required this.sTime,
    required this.rp,
    this.freq,
    this.ca,
    required this.cqi,
    required this.ri,
    required this.dlMcs,
    this.dlLayer,
    required this.dlRb,
    required this.dlTp,
    required this.inIndex,
    required this.baseList,
  });

  factory MeasureData.fromJson(Map<String, dynamic> json) =>
      _$MeasureDataFromJson(json);

  Map<String, dynamic> toJson() => _$MeasureDataToJson(this);

  List<String> getValues(WirelessType type) {
    List<String> commonValues = [
      nTime.toString(),
      nRsrp.toString(),
      inIndex.toString(),
      sTime?.toString() ?? '-',
      rp?.toString() ?? '-',
      cqi?.toString() ?? '-',
      ri?.toString() ?? '-',
      dlMcs?.toString() ?? '-',
      dlRb?.toString() ?? '-',
      dlTp?.toString() ?? '-',
    ];

    if (type == WirelessType.wLte) {
      commonValues.insert(4, freq?.toString() ?? '-');
      commonValues.insert(5, ca?.toString() ?? '-');
    } else {
      commonValues.insert(8, dlLayer?.toString() ?? '-');
    }

    return commonValues;
  }

  MeasureData copyWith({
    String? pci,
    String? nPci,
    int? nTime,
    double? nRsrp,
    int? sTime,
    double? rp,
    int? freq,
    int? ca,
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
    );}
}

