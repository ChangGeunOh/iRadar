// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'excel_request_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExcelRequestData _$ExcelRequestDataFromJson(Map<String, dynamic> json) =>
    ExcelRequestData(
      areaData: AreaData.fromJson(json['areaData'] as Map<String, dynamic>),
      measureDataList: (json['measureDataList'] as List<dynamic>)
          .map((e) => MeasureData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ExcelRequestDataToJson(ExcelRequestData instance) =>
    <String, dynamic>{
      'areaData': instance.areaData,
      'measureDataList': instance.measureDataList,
    };
