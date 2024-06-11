// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'intf_tt_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IntfTtData _$IntfTtDataFromJson(Map<String, dynamic> json) => IntfTtData(
      idx: json['idx'] as int,
      area: json['area'] as String,
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
      cells5: json['cells5'] as String,
      pci5: json['pci5'] as String?,
      rp5: (json['rp5'] as num?)?.toDouble(),
      cells: json['cells'] as String,
      pci: json['pci'] as String?,
      rp: (json['rp'] as num?)?.toDouble(),
      cqi5: (json['cqi5'] as num?)?.toDouble(),
      ri5: (json['ri5'] as num?)?.toDouble(),
      dlmcs5: (json['dlmcs5'] as num?)?.toDouble(),
      dll5: (json['dll5'] as num?)?.toDouble(),
      dlrb5: (json['dlrb5'] as num?)?.toDouble(),
      dltp5: (json['dltp5'] as num?)?.toDouble(),
      ear: json['ear'] as int?,
      ca: json['ca'] as int?,
      cqi: (json['cqi'] as num?)?.toDouble(),
      ri: (json['ri'] as num?)?.toDouble(),
      dlmcs: (json['dlmcs'] as num?)?.toDouble(),
      dlrb: (json['dlrb'] as num?)?.toDouble(),
      dltp: (json['dltp'] as num?)?.toDouble(),
      dt: json['dt'] == null ? null : DateTime.parse(json['dt'] as String),
    );

Map<String, dynamic> _$IntfTtDataToJson(IntfTtData instance) =>
    <String, dynamic>{
      'idx': instance.idx,
      'area': instance.area,
      'lat': instance.lat,
      'lng': instance.lng,
      'cells5': instance.cells5,
      'pci5': instance.pci5,
      'rp5': instance.rp5,
      'cells': instance.cells,
      'pci': instance.pci,
      'rp': instance.rp,
      'cqi5': instance.cqi5,
      'ri5': instance.ri5,
      'dlmcs5': instance.dlmcs5,
      'dll5': instance.dll5,
      'dlrb5': instance.dlrb5,
      'dltp5': instance.dltp5,
      'ear': instance.ear,
      'ca': instance.ca,
      'cqi': instance.cqi,
      'ri': instance.ri,
      'dlmcs': instance.dlmcs,
      'dlrb': instance.dlrb,
      'dltp': instance.dltp,
      'dt': instance.dt?.toIso8601String(),
    };
