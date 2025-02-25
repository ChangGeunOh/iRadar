// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'table_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TableData _$TableDataFromJson(Map<String, dynamic> json) => TableData(
      pci: json['pci'] as String,
      nPci: json['nPci'] as String?,
      pciMw: json['pciMw'] as String?,
      nTime: json['nTime'] as String,
      nRsrp: json['nRsrp'] as String,
      index: json['index'] as String,
      sTime: json['sTime'] as String,
      rp: json['rp'] as String?,
      cqi: json['cqi'] as String,
      ri: json['ri'] as String,
      dlMcs: json['dlMcs'] as String,
      dlLayer: json['dlLayer'] as String,
      dlRb: json['dlRb'] as String,
      dlTp: json['dlTp'] as String,
      nDst: json['nDst'] as String,
      nRnm: json['nRnm'] as String,
      nId: json['nId'] as String,
      checked: Convert.stringToBool(json['checked'] as String),
      hasColor: Convert.stringToBool(json['hasColor'] as String),
    );

Map<String, dynamic> _$TableDataToJson(TableData instance) => <String, dynamic>{
      'pci': instance.pci,
      'nPci': instance.nPci,
      'pciMw': instance.pciMw,
      'nTime': instance.nTime,
      'nRsrp': instance.nRsrp,
      'index': instance.index,
      'sTime': instance.sTime,
      'rp': instance.rp,
      'cqi': instance.cqi,
      'ri': instance.ri,
      'dlMcs': instance.dlMcs,
      'dlLayer': instance.dlLayer,
      'dlRb': instance.dlRb,
      'dlTp': instance.dlTp,
      'nDst': instance.nDst,
      'nRnm': instance.nRnm,
      'nId': instance.nId,
      'checked': Convert.boolToString(instance.checked),
      'hasColor': Convert.boolToString(instance.hasColor),
    };
