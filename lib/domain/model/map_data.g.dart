// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MapData _$MapDataFromJson(Map<String, dynamic> json) => MapData(
      measureList: (json['measure_list'] as List<dynamic>)
          .map((e) => MeasureData.fromJson(e as Map<String, dynamic>))
          .toList(),
      baseList: (json['base_list'] as List<dynamic>)
          .map((e) => BaseData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MapDataToJson(MapData instance) => <String, dynamic>{
      'measure_list': instance.measureList,
      'base_list': instance.baseList,
    };
