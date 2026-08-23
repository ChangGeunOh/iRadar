// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseData _$BaseDataFromJson(Map<String, dynamic> json) => BaseData(
      idx: (json['idx'] as num?)?.toInt() ?? -1,
      rnm: json['rnm'] as String,
      code: json['code'] as String,
      type: json['type'] as String,
      latitude: (json['lat'] as num).toDouble(),
      longitude: (json['lng'] as num).toDouble(),
      pci: BaseData._pciFromJson(json['pci'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$BaseDataToJson(BaseData instance) => <String, dynamic>{
      'idx': instance.idx,
      'rnm': instance.rnm,
      'code': instance.code,
      'type': instance.type,
      'lat': instance.latitude,
      'lng': instance.longitude,
      'createdAt': instance.createdAt.toIso8601String(),
      'pci': BaseData._pciToJson(instance.pci),
    };
