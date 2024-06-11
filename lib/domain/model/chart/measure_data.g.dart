// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'measure_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeasureData _$MeasureDataFromJson(Map<String, dynamic> json) => MeasureData(
      pci: json['pci'] as String,
      nPci: json['nPci'] as String,
      nTime: json['nTime'] as int,
      nRsrp: (json['nRsrp'] as num).toDouble(),
      sTime: json['sTime'] as int?,
      rp: (json['rp'] as num?)?.toDouble(),
      freq: json['freq'] as int?,
      ca: json['ca'] as int?,
      cqi: (json['cqi'] as num?)?.toDouble(),
      ri: (json['ri'] as num?)?.toDouble(),
      dlMcs: (json['dlMcs'] as num?)?.toDouble(),
      dlLayer: (json['dlLayer'] as num?)?.toDouble(),
      dlRb: (json['dlRb'] as num?)?.toDouble(),
      dlTp: (json['dlTp'] as num?)?.toDouble(),
      inIndex: (json['inIndex'] as num).toDouble(),
      baseList: (json['baseList'] as List<dynamic>)
          .map((e) => BaseData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MeasureDataToJson(MeasureData instance) =>
    <String, dynamic>{
      'pci': instance.pci,
      'nPci': instance.nPci,
      'nTime': instance.nTime,
      'nRsrp': instance.nRsrp,
      'sTime': instance.sTime,
      'rp': instance.rp,
      'freq': instance.freq,
      'ca': instance.ca,
      'cqi': instance.cqi,
      'ri': instance.ri,
      'dlMcs': instance.dlMcs,
      'dlLayer': instance.dlLayer,
      'dlRb': instance.dlRb,
      'dlTp': instance.dlTp,
      'inIndex': instance.inIndex,
      'baseList': instance.baseList,
    };
