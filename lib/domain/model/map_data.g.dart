// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MapData _$MapDataFromJson(Map<String, dynamic> json) => MapData(
      idx: (json['idx'] as num).toInt(),
      latitude: (json['lat'] as num).toDouble(),
      longitude: (json['lng'] as num).toDouble(),
      pci: (json['pci'] as num).toInt(),
      pci5: (json['pci5'] as num).toInt(),
      rsrp5: (json['rp5'] as num).toDouble(),
    );

Map<String, dynamic> _$MapDataToJson(MapData instance) => <String, dynamic>{
      'idx': instance.idx,
      'lat': instance.latitude,
      'lng': instance.longitude,
      'pci': instance.pci,
      'pci5': instance.pci5,
      'rp5': instance.rsrp5,
    };
