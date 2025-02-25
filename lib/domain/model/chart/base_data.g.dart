// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseData _$BaseDataFromJson(Map<String, dynamic> json) => BaseData(
      code: json['code'] as String,
      name: json['name'] as String,
      distance: (json['distance'] as num).toDouble(),
      isChecked: json['isChecked'] as bool? ?? false,
    );

Map<String, dynamic> _$BaseDataToJson(BaseData instance) => <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
      'distance': instance.distance,
      'isChecked': instance.isChecked,
    };
