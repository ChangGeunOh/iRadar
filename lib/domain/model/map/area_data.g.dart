// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'area_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AreaData _$AreaDataFromJson(Map<String, dynamic> json) => AreaData(
      idx: (json['idx'] as num).toInt(),
      name: json['name'] as String,
      division: json['division'] == null
          ? null
          : LocationType.fromJson(json['division'] as String),
      type: Convert.dynamicToWirelessType(json['type']),
      latitude: (json['lat'] as num?)?.toDouble(),
      longitude: (json['lng'] as num?)?.toDouble(),
      isChartCached: json['is_chart_cached'] as bool? ?? false,
      isMapCached: json['is_map_cached'] as bool? ?? false,
      createdAt: Convert.dynamicToDateTime(json['create_at']),
      measuredAt: Convert.dynamicToDateTime(json['dt']),
    );

Map<String, dynamic> _$AreaDataToJson(AreaData instance) => <String, dynamic>{
      'idx': instance.idx,
      'name': instance.name,
      'type': Convert.wirelessTypeToDynamic(instance.type),
      'division': instance.division,
      'lat': instance.latitude,
      'lng': instance.longitude,
      'is_chart_cached': instance.isChartCached,
      'is_map_cached': instance.isMapCached,
      'create_at': Convert.dateTimeToDynamic(instance.createdAt),
      'dt': Convert.dateTimeToDynamic(instance.measuredAt),
    };
