import 'package:googlemap/common/utils/convert.dart';
import 'package:json_annotation/json_annotation.dart';

part 'excel_response_data.g.dart';

@JsonSerializable()
class ExcelResponseData {
  final String division;
  final String sido;
  final String sigungu;
  final String area;
  final String team;
  final String jo;
  final String year;
  final String id;
  final String rnm;
  final String memo;
  final String atten;
  @JsonKey(name: 'cell_lock')
  final String cellLock;
  @JsonKey(name: 'ru_lock')
  final String ruLock;
  @JsonKey(name: 'relay_lock')
  final String relayLock;
  final String pci;
  final String scenario;
  @JsonKey(name: 'reg_date')
  final String regDate;
  @JsonKey(name: "has_color",
    toJson: Convert.boolToDynamic,
    fromJson: Convert.dynamicToBool,
  )
  final bool hasColor;

  ExcelResponseData({
    required this.division,
    required this.sido,
    required this.sigungu,
    required this.area,
    required this.team,
    required this.jo,
    required this.year,
    required this.id,
    required this.rnm,
    required this.memo,
    required this.atten,
    required this.cellLock,
    required this.ruLock,
    required this.relayLock,
    required this.pci,
    required this.scenario,
    required this.regDate,
    required this.hasColor,
});
  factory ExcelResponseData.fromJson(Map<String, dynamic> json) => _$ExcelResponseDataFromJson(json);
  Map<String, dynamic> toJson() => _$ExcelResponseDataToJson(this);
}