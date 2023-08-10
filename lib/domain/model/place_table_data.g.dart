// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_table_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaceTableData _$PlaceTableDataFromJson(Map<String, dynamic> json) =>
    PlaceTableData(
      placeData: PlaceData.fromJson(json['placeData'] as Map<String, dynamic>),
      tableData: TableData.fromJson(json['tableData'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PlaceTableDataToJson(PlaceTableData instance) =>
    <String, dynamic>{
      'placeData': instance.placeData,
      'tableData': instance.tableData,
    };
