// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaceData _$PlaceDataFromJson(Map<String, dynamic> json) => PlaceData(
      wirelessType: $enumDecode(_$WirelessTypeEnumMap, json['wirelessType']),
      location: json['location'] as String,
      locationType: $enumDecode(_$LocationTypeEnumMap, json['locationType']),
      name: json['name'] as String,
      regDate: json['regDate'] as String,
      link: json['link'] as String,
    );

Map<String, dynamic> _$PlaceDataToJson(PlaceData instance) => <String, dynamic>{
      'wirelessType': _$WirelessTypeEnumMap[instance.wirelessType]!,
      'location': instance.location,
      'locationType': _$LocationTypeEnumMap[instance.locationType]!,
      'name': instance.name,
      'regDate': instance.regDate,
      'link': instance.link,
    };

const _$WirelessTypeEnumMap = {
  WirelessType.wLte: 'LTE',
  WirelessType.w5G: '5G',
  WirelessType.undefined: 'undefined',
};

const _$LocationTypeEnumMap = {
  LocationType.inBuilding: 'inBuilding',
  LocationType.adminBuilding: 'adminBuilding',
  LocationType.theme: 'theme',
  LocationType.undefined: 'undefined',
};
