// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'area_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AreaData _$AreaDataFromJson(Map<String, dynamic> json) => AreaData(
      idx: json['idx'] as int,
      name: json['name'] as String,
      date: Convert.dynamicToDateTime(json['created_at']),
      division: $enumDecode(_$LocationTypeEnumMap, json['division']),
      type: Convert.dynamicToWirelessType(json['type']),
      latitude: (json['lat'] as num).toDouble(),
      longitude: (json['lng'] as num).toDouble(),
    );

Map<String, dynamic> _$AreaDataToJson(AreaData instance) => <String, dynamic>{
      'idx': instance.idx,
      'name': instance.name,
      'type': _$WirelessTypeEnumMap[instance.type]!,
      'division': _$LocationTypeEnumMap[instance.division]!,
      'lat': instance.latitude,
      'lng': instance.longitude,
      'created_at': instance.date.toIso8601String(),
    };

const _$LocationTypeEnumMap = {
  LocationType.inBuilding: '인빌딩',
  LocationType.adminBuilding: '행정동',
  LocationType.theme: '테마',
  LocationType.undefined: 'undefined',
};

const _$WirelessTypeEnumMap = {
  WirelessType.wLte: 'LTE',
  WirelessType.w5G: '5G',
  WirelessType.all: 'ALL',
  WirelessType.undefined: 'undefined',
};
