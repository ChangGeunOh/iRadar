// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'intf_tt_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IntfTtData _$IntfTtDataFromJson(Map<String, dynamic> json) => IntfTtData(
      idx: (json['idx'] as num).toInt(),
      area: json['area'] as String,
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
      pci5: json['pci5'] as String?,
      rp5: (json['rp5'] as num?)?.toDouble(),
      pci: json['pci'] as String?,
      rp: (json['rp'] as num?)?.toDouble(),
      pw: json['pw'] as String?,
      cqi5: (json['cqi5'] as num?)?.toDouble(),
      ri5: (json['ri5'] as num?)?.toDouble(),
      dlmcs5: (json['dlmcs5'] as num?)?.toDouble(),
      dll5: (json['dll5'] as num?)?.toDouble(),
      dlrb5: (json['dlrb5'] as num?)?.toDouble(),
      dl5: (json['dl5'] as num?)?.toDouble(),
      ear: (json['ear'] as num?)?.toDouble(),
      ca: (json['ca'] as num?)?.toDouble(),
      cqi: (json['cqi'] as num?)?.toDouble(),
      ri: (json['ri'] as num?)?.toDouble(),
      mcs: (json['mcs'] as num?)?.toDouble(),
      rb: (json['rb'] as num?)?.toDouble(),
      dl: (json['dl'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$IntfTtDataToJson(IntfTtData instance) =>
    <String, dynamic>{
      'idx': instance.idx,
      'area': instance.area,
      'lat': instance.lat,
      'lng': instance.lng,
      'pci5': instance.pci5,
      'rp5': instance.rp5,
      'pci': instance.pci,
      'rp': instance.rp,
      'pw': instance.pw,
      'cqi5': instance.cqi5,
      'ri5': instance.ri5,
      'dlmcs5': instance.dlmcs5,
      'dll5': instance.dll5,
      'dlrb5': instance.dlrb5,
      'dl5': instance.dl5,
      'ear': instance.ear,
      'ca': instance.ca,
      'cqi': instance.cqi,
      'ri': instance.ri,
      'mcs': instance.mcs,
      'rb': instance.rb,
      'dl': instance.dl,
    };
