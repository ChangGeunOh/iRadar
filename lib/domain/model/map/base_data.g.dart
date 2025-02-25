// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseData _$BaseDataFromJson(Map<String, dynamic> json) => BaseData(
      idx: (json['idx'] as num).toInt(),
      code: json['code'] as String,
      rnm: json['rnm'] as String,
      pci: (json['pci'] as num).toInt(),
      latitude: (json['lat'] as num).toDouble(),
      longitude: (json['lng'] as num).toDouble(),
      type: Convert.dynamicToWirelessType(json['type']),
    );

Map<String, dynamic> _$BaseDataToJson(BaseData instance) => <String, dynamic>{
      'idx': instance.idx,
      'type': _$WirelessTypeEnumMap[instance.type]!,
      'code': instance.code,
      'rnm': instance.rnm,
      'pci': instance.pci,
      'lat': instance.latitude,
      'lng': instance.longitude,
    };

const _$WirelessTypeEnumMap = {
  WirelessType.wLte: 'LTE',
  WirelessType.w5G: '5G',
  WirelessType.all: 'ALL',
  WirelessType.undefined: 'undefined',
};
