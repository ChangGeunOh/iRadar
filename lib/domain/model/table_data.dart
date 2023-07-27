import 'package:json_annotation/json_annotation.dart';

part 'table_data.g.dart';

@JsonSerializable()
class TableData {
  final String pci;
  final String nPci;
  final String nTime;
  final String nRsrp;
  final String index;
  final String sTime;
  final String rp;
  final String cqi;
  final String ri;
  final String dlMcs;
  final String dlLayer;
  final String dlRb;
  final String dlTb;
  final String nDst;
  final String nRnm;
  final String nId;
  final String checked;
  final String hasColor;

  TableData({
    required this.pci,
    required this.nPci,
    required this.nTime,
    required this.nRsrp,
    required this.index,
    required this.sTime,
    required this.rp,
    required this.cqi,
    required this.ri,
    required this.dlMcs,
    required this.dlLayer,
    required this.dlRb,
    required this.dlTb,
    required this.nDst,
    required this.nRnm,
    required this.nId,
    required this.checked,
    required this.hasColor,
  });

  Map<String, dynamic> toJson() => _$TableDataToJson(this);

  factory TableData.fromJson(Map<String, dynamic> json) =>
      _$TableDataFromJson(json);
}
