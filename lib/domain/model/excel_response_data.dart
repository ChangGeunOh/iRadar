import 'package:googlemap/common/utils/convert.dart';
import 'package:json_annotation/json_annotation.dart';

part 'excel_response_data.g.dart';

@JsonSerializable()
class ExcelResponseData {
  final String division;
  final String sido;
  final String sigungu;
  final String area;
  final String type;
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
  @JsonKey(
    fromJson: Convert.dynamicToString,
  )
  final String pci;
  final String scenario;
  @JsonKey(name: 'reg_date')
  final String regDate;
  @JsonKey(
    name: "has_color",
    toJson: Convert.boolToDynamic,
    fromJson: Convert.dynamicToBool,
  )
  final bool hasColor;

  ExcelResponseData({
    this.division = '',
    this.sido = '',
    this.sigungu = '',
    this.area = '',
    this.team = '',
    this.jo = '',
    this.year = '',
    this.type = '',
    this.id = '',
    this.rnm = '',
    this.memo = '',
    String? atten, // this.atten = '200',       // relay인 경우 ''로 초기화
    this.cellLock = '',
    this.ruLock = '',
    String? relayLock, // this.relayLock = '',    // relay인 경우 'O'로 초기화
    this.pci = '',
    this.scenario = 'iRadar',
    this.regDate = '',
    this.hasColor = false,
  })  : atten = atten ?? (type == '5G' ? '200' :  ['RS', 'RB', 'RE'].any((e) => id.startsWith(e)) ? '' : '200'),
        relayLock = ['RS', 'RB', 'RE'].any((e) => id.startsWith(e)) ? 'O' : '';

  factory ExcelResponseData.fromJson(Map<String, dynamic> json) =>
      _$ExcelResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$ExcelResponseDataToJson(this);
}


