// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_base_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MapBaseData _$MapBaseDataFromJson(Map<String, dynamic> json) => MapBaseData(
      idx: json['idx'] as int,
      code: json['code'] as String,
      name: json['rnm'] as String,
      pci: json['pci'] as int,
      latitude: (json['lat'] as num).toDouble(),
      longitude: (json['lng'] as num).toDouble(),
      type: Convert.dynamicToWirelessType(json['type']),
    );

Map<String, dynamic> _$MapBaseDataToJson(MapBaseData instance) =>
    <String, dynamic>{
      'idx': instance.idx,
      'code': instance.code,
      'rnm': instance.name,
      'lat': instance.latitude,
      'lng': instance.longitude,
      'pci': instance.pci,
      'type': _$WirelessTypeEnumMap[instance.type]!,
    };

const _$WirelessTypeEnumMap = {
  WirelessType.wLte: 'LTE',
  WirelessType.w5G: '5G',
  WirelessType.all: 'ALL',
  WirelessType.undefined: 'undefined',
};
