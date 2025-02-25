// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pci_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PciData _$PciDataFromJson(Map<String, dynamic> json) => PciData(
      pci: json['pci'] as String,
      rsrp: (json['rp'] as num).toDouble(),
      latitude: (json['lat'] as num).toDouble(),
      longitude: (json['lng'] as num).toDouble(),
    );

Map<String, dynamic> _$PciDataToJson(PciData instance) => <String, dynamic>{
      'pci': instance.pci,
      'rp': instance.rsrp,
      'lat': instance.latitude,
      'lng': instance.longitude,
    };
