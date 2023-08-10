// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaceData _$PlaceDataFromJson(Map<String, dynamic> json) => PlaceData(
      wirelessType: $enumDecode(_$WirelessTypeEnumMap, json['type']),
      regDate: json['date'] as String,
      link: json['area'] as String,
    );

Map<String, dynamic> _$PlaceDataToJson(PlaceData instance) => <String, dynamic>{
      'type': _$WirelessTypeEnumMap[instance.wirelessType]!,
      'date': instance.regDate,
      'area': instance.link,
    };

const _$WirelessTypeEnumMap = {
  WirelessType.wLte: 'LTE',
  WirelessType.w5G: '5G',
  WirelessType.undefined: 'undefined',
};
