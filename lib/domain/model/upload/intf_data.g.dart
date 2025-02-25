// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'intf_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IntfData _$IntfDataFromJson(Map<String, dynamic> json) => IntfData(
      idx: (json['idx'] as num).toInt(),
      area: json['area'] as String,
      pci: json['pci'] as String,
      dt: DateTime.parse(json['dt'] as String),
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      rp: (json['rp'] as num).toDouble(),
      rpmw: (json['rpmw'] as num).toDouble(),
      spci: json['spci'] as String,
      srp: (json['srp'] as num).toDouble(),
    );

Map<String, dynamic> _$IntfDataToJson(IntfData instance) => <String, dynamic>{
      'idx': instance.idx,
      'area': instance.area,
      'pci': instance.pci,
      'dt': instance.dt.toIso8601String(),
      'lat': instance.lat,
      'lng': instance.lng,
      'rp': instance.rp,
      'rpmw': instance.rpmw,
      'spci': instance.spci,
      'srp': instance.srp,
    };
