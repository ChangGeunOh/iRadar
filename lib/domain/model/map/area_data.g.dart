// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'area_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AreaData _$AreaDataFromJson(Map<String, dynamic> json) => AreaData(
      idx: (json['idx'] as num).toInt(),
      name: json['name'] as String,
      division: $enumDecodeNullable(_$LocationTypeEnumMap, json['division']),
      type: Convert.dynamicToWirelessType(json['type']),
      latitude: (json['lat'] as num?)?.toDouble(),
      longitude: (json['lng'] as num?)?.toDouble(),
      createdAt: Convert.dynamicToDateTime(json['create_at']),
      measuredAt: Convert.dynamicToDateTime(json['dt']),
    );

Map<String, dynamic> _$AreaDataToJson(AreaData instance) => <String, dynamic>{
      'idx': instance.idx,
      'name': instance.name,
      'type': Convert.wirelessTypeToDynamic(instance.type),
      'division': _$LocationTypeEnumMap[instance.division],
      'lat': instance.latitude,
      'lng': instance.longitude,
      'create_at': Convert.dateTimeToDynamic(instance.createdAt),
      'dt': Convert.dateTimeToDynamic(instance.measuredAt),
    };

const _$LocationTypeEnumMap = {
  LocationType.adminBuilding: '행정동',
  LocationType.inBuilding: '인빌딩',
  LocationType.theme: '테마',
  LocationType.undefined: 'undefined',
};
