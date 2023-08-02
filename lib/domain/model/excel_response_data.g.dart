// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'excel_response_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExcelResponseData _$ExcelResponseDataFromJson(Map<String, dynamic> json) =>
    ExcelResponseData(
      division: json['division'] as String,
      sido: json['sido'] as String,
      sigungu: json['sigungu'] as String,
      area: json['area'] as String,
      team: json['team'] as String,
      jo: json['jo'] as String,
      year: json['year'] as String,
      id: json['id'] as String,
      rnm: json['rnm'] as String,
      memo: json['memo'] as String,
      atten: json['atten'] as String,
      cellLock: json['cell_lock'] as String,
      ruLock: json['ru_lock'] as String,
      relayLock: json['relay_lock'] as String,
      pci: json['pci'] as String,
      scenario: json['scenario'] as String,
      regDate: json['reg_date'] as String,
      hasColor: Convert.dynamicToBool(json['has_color']),
    );

Map<String, dynamic> _$ExcelResponseDataToJson(ExcelResponseData instance) =>
    <String, dynamic>{
      'division': instance.division,
      'sido': instance.sido,
      'sigungu': instance.sigungu,
      'area': instance.area,
      'team': instance.team,
      'jo': instance.jo,
      'year': instance.year,
      'id': instance.id,
      'rnm': instance.rnm,
      'memo': instance.memo,
      'atten': instance.atten,
      'cell_lock': instance.cellLock,
      'ru_lock': instance.ruLock,
      'relay_lock': instance.relayLock,
      'pci': instance.pci,
      'scenario': instance.scenario,
      'reg_date': instance.regDate,
      'has_color': Convert.boolToDynamic(instance.hasColor),
    };
