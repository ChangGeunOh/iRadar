// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_base_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MapBaseData _$MapBaseDataFromJson(Map<String, dynamic> json) => MapBaseData(
      code: json['code'] as String,
      name: json['rnm'] as String,
      pci: (json['pci'] as num).toInt(),
      latitude: (json['lat'] as num).toDouble(),
      longitude: (json['lng'] as num).toDouble(),
    );

Map<String, dynamic> _$MapBaseDataToJson(MapBaseData instance) =>
    <String, dynamic>{
      'code': instance.code,
      'rnm': instance.name,
      'lat': instance.latitude,
      'lng': instance.longitude,
      'pci': instance.pci,
    };
