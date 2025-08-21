// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'worst_chart_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorstChartData _$WorstChartDataFromJson(Map<String, dynamic> json) =>
    WorstChartData(
      idx: (json['idx'] as num).toInt(),
      name: json['name'] as String,
      measuredAt: Convert.dynamicToDateTime(json['measured_at']),
      worstList: (json['worst_list'] as List<dynamic>?)
              ?.map((e) => MeasureData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$WorstChartDataToJson(WorstChartData instance) =>
    <String, dynamic>{
      'idx': instance.idx,
      'name': instance.name,
      'measured_at': instance.measuredAt.toIso8601String(),
      'worst_list': instance.worstList,
    };
