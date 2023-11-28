// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaceData _$PlaceDataFromJson(Map<String, dynamic> json) => PlaceData(
      idx: json['idx'] as int,
      type: $enumDecode(_$WirelessTypeEnumMap, json['type']),
      group: json['group'] as String,
      name: json['name'] as String,
      division: $enumDecode(_$LocationTypeEnumMap, json['division']),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      dateTime: json['dateTime'] as String,
      password: json['password'] as String? ?? '',
      link: json['link'] as String?,
      isSelected: json['isSelected'] as bool?,
    );

Map<String, dynamic> _$PlaceDataToJson(PlaceData instance) => <String, dynamic>{
      'idx': instance.idx,
      'type': _$WirelessTypeEnumMap[instance.type]!,
      'group': instance.group,
      'name': instance.name,
      'division': _$LocationTypeEnumMap[instance.division]!,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'dateTime': instance.dateTime,
      'link': instance.link,
      'password': instance.password,
      'isSelected': instance.isSelected,
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
