// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_base_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MapBaseData _$MapBaseDataFromJson(Map<String, dynamic> json) => MapBaseData(
      measureList: (json['map_list'] as List<dynamic>)
          .map((e) => MapData.fromJson(e as Map<String, dynamic>))
          .toList(),
      baseList: (json['base_list'] as List<dynamic>)
          .map((e) => BaseData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MapBaseDataToJson(MapBaseData instance) =>
    <String, dynamic>{
      'map_list': instance.measureList,
      'base_list': instance.baseList,
      'isSelected': instance.isSelected,
    };
