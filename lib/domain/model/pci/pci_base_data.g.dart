// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pci_base_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PciBaseData _$PciBaseDataFromJson(Map<String, dynamic> json) => PciBaseData(
      sPciDataList: (json['spci'] as List<dynamic>)
          .map((e) => PciData.fromJson(e as Map<String, dynamic>))
          .toList(),
      nPciDataList: (json['npci'] as List<dynamic>)
          .map((e) => PciData.fromJson(e as Map<String, dynamic>))
          .toList(),
      pciBaseList: (json['base'] as List<dynamic>)
          .map((e) => PciBase.fromJson(e as Map<String, dynamic>))
          .toList(),
      position: Position.fromJson(json['position'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PciBaseDataToJson(PciBaseData instance) =>
    <String, dynamic>{
      'spci': instance.sPciDataList,
      'npci': instance.nPciDataList,
      'base': instance.pciBaseList,
      'position': instance.position,
    };

Position _$PositionFromJson(Map<String, dynamic> json) => Position(
      latitude: (json['lat'] as num).toDouble(),
      longitude: (json['lng'] as num).toDouble(),
    );

Map<String, dynamic> _$PositionToJson(Position instance) => <String, dynamic>{
      'lat': instance.latitude,
      'lng': instance.longitude,
    };
