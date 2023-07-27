// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart_table_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChartTableData _$ChartTableDataFromJson(Map<String, dynamic> json) =>
    ChartTableData(
      chartList: (json['chart_data'] as List<dynamic>)
          .map((e) => ChartData.fromJson(e as Map<String, dynamic>))
          .toList(),
      tableList: (json['table_data'] as List<dynamic>)
          .map((e) => TableData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ChartTableDataToJson(ChartTableData instance) =>
    <String, dynamic>{
      'chart_data': instance.chartList,
      'table_data': instance.tableList,
    };
