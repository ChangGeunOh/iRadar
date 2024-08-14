// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_measured_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MapMeasuredData _$MapMeasuredDataFromJson(Map<String, dynamic> json) =>
    MapMeasuredData(
      idx: (json['idx'] as num).toInt(),
      latitude: (json['lat'] as num).toDouble(),
      longitude: (json['lng'] as num).toDouble(),
      pci: Convert.dynamicToInt(json['pci']),
      rsrp: Convert.dynamicToDouble(json['rp']),
    );

Map<String, dynamic> _$MapMeasuredDataToJson(MapMeasuredData instance) =>
    <String, dynamic>{
      'idx': instance.idx,
      'lat': instance.latitude,
      'lng': instance.longitude,
      'pci': instance.pci,
      'rp': instance.rsrp,
    };
