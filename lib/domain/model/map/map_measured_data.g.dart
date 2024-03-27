// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_measured_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MapMeasuredData _$MapMeasuredDataFromJson(Map<String, dynamic> json) =>
    MapMeasuredData(
      idx: json['idx'] as int,
      latitude: (json['lat'] as num).toDouble(),
      longitude: (json['lng'] as num).toDouble(),
      pci: Convert.dynamicToInt(json['pci']),
      pci5: Convert.dynamicToInt(json['pci5']),
      rsrp5: Convert.dynamicToDouble(json['rp5']),
    );

Map<String, dynamic> _$MapMeasuredDataToJson(MapMeasuredData instance) =>
    <String, dynamic>{
      'idx': instance.idx,
      'lat': instance.latitude,
      'lng': instance.longitude,
      'pci': instance.pci,
      'pci5': instance.pci5,
      'rp5': instance.rsrp5,
    };
