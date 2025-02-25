// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MapData _$MapDataFromJson(Map<String, dynamic> json) => MapData(
      measuredData: (json['measured_data'] as List<dynamic>)
          .map((e) => MapMeasuredData.fromJson(e as Map<String, dynamic>))
          .toList(),
      baseData: (json['base_data'] as List<dynamic>)
          .map((e) => MapBaseData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MapDataToJson(MapData instance) => <String, dynamic>{
      'measured_data': instance.measuredData,
      'base_data': instance.baseData,
    };
