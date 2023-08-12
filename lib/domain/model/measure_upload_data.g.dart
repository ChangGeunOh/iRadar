// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'measure_upload_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeasureUploadData _$MeasureUploadDataFromJson(Map<String, dynamic> json) =>
    MeasureUploadData()
      ..group = json['group'] as String
      ..area = json['area'] as String
      ..password = json['password'] as String?;

Map<String, dynamic> _$MeasureUploadDataToJson(MeasureUploadData instance) =>
    <String, dynamic>{
      'group': instance.group,
      'area': instance.area,
      'password': instance.password,
    };
