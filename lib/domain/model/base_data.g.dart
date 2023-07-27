// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseData _$BaseDataFromJson(Map<String, dynamic> json) => BaseData(
      idx: json['idx'] as int,
      id: json['id'] as String,
      rnm: json['rnm'] as String,
      pci: json['pci'] as int,
      latitude: (json['lat'] as num).toDouble(),
      longitude: (json['lng'] as num).toDouble(),
    );

Map<String, dynamic> _$BaseDataToJson(BaseData instance) => <String, dynamic>{
      'idx': instance.idx,
      'id': instance.id,
      'rnm': instance.rnm,
      'pci': instance.pci,
      'lat': instance.latitude,
      'lng': instance.longitude,
    };
