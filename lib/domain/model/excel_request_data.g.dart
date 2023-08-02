// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'excel_request_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExcelRequestData _$ExcelRequestDataFromJson(Map<String, dynamic> json) =>
    ExcelRequestData(
      placeData: PlaceData.fromJson(json['placeData'] as Map<String, dynamic>),
      tableList: (json['tableList'] as List<dynamic>)
          .map((e) => TableData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ExcelRequestDataToJson(ExcelRequestData instance) =>
    <String, dynamic>{
      'placeData': instance.placeData,
      'tableList': instance.tableList,
    };
