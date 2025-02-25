// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pci_base.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PciBase _$PciBaseFromJson(Map<String, dynamic> json) => PciBase(
      rnm: json['rnm'] as String,
      code: json['code'] as String,
      latitude: (json['lat'] as num).toDouble(),
      longitude: (json['lng'] as num).toDouble(),
      distance: (json['distance'] as num).toDouble(),
    );

Map<String, dynamic> _$PciBaseToJson(PciBase instance) => <String, dynamic>{
      'rnm': instance.rnm,
      'code': instance.code,
      'lat': instance.latitude,
      'lng': instance.longitude,
      'distance': instance.distance,
    };
