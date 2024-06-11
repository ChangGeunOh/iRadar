// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merge_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MergeData _$MergeDataFromJson(Map<String, dynamic> json) => MergeData(
      name: json['name'] as String,
      wirelessType: $enumDecode(_$WirelessTypeEnumMap, json['wireless_type']),
      locationType: $enumDecode(_$LocationTypeEnumMap, json['location_type']),
      latitude: (json['lat'] as num).toDouble(),
      longitude: (json['lng'] as num).toDouble(),
      data: (json['data'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$MergeDataToJson(MergeData instance) => <String, dynamic>{
      'name': instance.name,
      'wireless_type': _$WirelessTypeEnumMap[instance.wirelessType]!,
      'location_type': _$LocationTypeEnumMap[instance.locationType]!,
      'lat': instance.latitude,
      'lng': instance.longitude,
      'data': instance.data,
    };

const _$WirelessTypeEnumMap = {
  WirelessType.wLte: 'LTE',
  WirelessType.w5G: '5G',
  WirelessType.all: 'ALL',
  WirelessType.undefined: 'undefined',
};

const _$LocationTypeEnumMap = {
  LocationType.inBuilding: '인빌딩',
  LocationType.adminBuilding: '행정동',
  LocationType.theme: '테마',
  LocationType.undefined: 'undefined',
};