// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'area_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AreaData _$AreaDataFromJson(Map<String, dynamic> json) => AreaData(
      type: $enumDecode(_$WirelessTypeEnumMap, json['type']),
      area: json['area'] as String,
      date: json['date'] as String,
    );

Map<String, dynamic> _$AreaDataToJson(AreaData instance) => <String, dynamic>{
      'type': _$WirelessTypeEnumMap[instance.type]!,
      'area': instance.area,
      'date': instance.date,
    };

const _$WirelessTypeEnumMap = {
  WirelessType.wLte: 'LTE',
  WirelessType.w5G: '5G',
  WirelessType.undefined: 'undefined',
};
