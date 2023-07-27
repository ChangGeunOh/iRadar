// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chart_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChartData _$ChartDataFromJson(Map<String, dynamic> json) => ChartData(
      pci: Convert.stringToInt(json['pci'] as String),
      index: Convert.stringToDouble(json['index'] as String),
      hasColor: Convert.stringToBool(json['hasColor'] as String),
    );

Map<String, dynamic> _$ChartDataToJson(ChartData instance) => <String, dynamic>{
      'pci': Convert.intToString(instance.pci),
      'index': Convert.doubleToString(instance.index),
      'hasColor': Convert.boolToString(instance.hasColor),
    };
