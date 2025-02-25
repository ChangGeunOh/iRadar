import 'package:json_annotation/json_annotation.dart';

import '../../common/utils/convert.dart';

part 'table_data.g.dart';

@JsonSerializable()
class TableData {
  final String pci;
  final String nPci;
  final String pciMw;
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
  final String dlTp;
  final String nDst;
  final String nRnm;
  final String nId;
  @JsonKey(
    fromJson: Convert.stringToBool,
    toJson: Convert.boolToString,
  )
  late bool checked;
  @JsonKey(
    fromJson: Convert.stringToBool,
    toJson: Convert.boolToString,
  )
  final bool hasColor;

  TableData({
    required this.pci,
    String? nPci,
    String? pciMw,
    required this.nTime,
    required this.nRsrp,
    required this.index,
    required this.sTime,
    String? rp,
    required this.cqi,
    required this.ri,
    required this.dlMcs,
    required this.dlLayer,
    required this.dlRb,
    required this.dlTp,
    required this.nDst,
    required this.nRnm,
    required this.nId,
    required this.checked,
    required this.hasColor,
  })  : nPci = nPci ?? "",
        pciMw = pciMw ?? "",
        rp = rp ?? "";

  TableData copyWith({
    bool? checked,
  }) {
    return TableData(
      pci: pci,
      nPci: nPci,
      pciMw: pciMw,
      nTime: nTime,
      nRsrp: nRsrp,
      index: index,
      sTime: sTime,
      rp: rp,
      cqi: cqi,
      ri: ri,
      dlMcs: dlMcs,
      dlLayer: dlLayer,
      dlRb: dlRb,
      dlTp: dlTp,
      nDst: nDst,
      nRnm: nRnm,
      nId: nId,
      checked: checked ?? this.checked,
      hasColor: hasColor,
    );
  }

  void toggle() {
    checked = !checked;
  }

  void isCheck(bool isCheck) {
    checked = isCheck;
  }

  String nearby() => "($nDst $nId) $nRnm";

  Map<String, dynamic> toJson() => _$TableDataToJson(this);

  factory TableData.fromJson(Map<String, dynamic> json) =>
      _$TableDataFromJson(json);
}
