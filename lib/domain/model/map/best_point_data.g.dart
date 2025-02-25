// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'best_point_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BestPointData _$BestPointDataFromJson(Map<String, dynamic> json) =>
    BestPointData(
      idx: (json['idx'] as num).toInt(),
      pci: (json['pci'] as num).toInt(),
      dltp: (json['dltp'] as num).toDouble(),
      latitude: (json['lat'] as num).toDouble(),
      longitude: (json['lng'] as num).toDouble(),
      address: json['address'] as String,
      memo: json['memo'] as String,
    );

Map<String, dynamic> _$BestPointDataToJson(BestPointData instance) =>
    <String, dynamic>{
      'idx': instance.idx,
      'pci': instance.pci,
      'dltp': instance.dltp,
      'lat': instance.latitude,
      'lng': instance.longitude,
      'address': instance.address,
      'memo': instance.memo,
    };
