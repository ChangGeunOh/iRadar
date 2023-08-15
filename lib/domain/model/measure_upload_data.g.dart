// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'measure_upload_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeasureUploadData _$MeasureUploadDataFromJson(Map<String, dynamic> json) =>
    MeasureUploadData(
      intf5GList: (json['intf5GList'] as List<dynamic>?)
          ?.map((e) => IntfData.fromJson(e as Map<String, dynamic>))
          .toList(),
      intfLteList: (json['intfLteList'] as List<dynamic>?)
          ?.map((e) => IntfData.fromJson(e as Map<String, dynamic>))
          .toList(),
      intfTTList: (json['intfTTList'] as List<dynamic>?)
          ?.map((e) => IntfTtData.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..group = json['group'] as String
      ..area = json['area'] as String
      ..type = json['type'] as String
      ..password = json['password'] as String
      ..isAddData = json['isAddData'] as bool
      ..isWideArea = json['isWideArea'] as bool;

Map<String, dynamic> _$MeasureUploadDataToJson(MeasureUploadData instance) =>
    <String, dynamic>{
      'group': instance.group,
      'area': instance.area,
      'type': instance.type,
      'password': instance.password,
      'isAddData': instance.isAddData,
      'isWideArea': instance.isWideArea,
      'intf5GList': instance.intf5GList.map((e) => e.toJson()).toList(),
      'intfLteList': instance.intfLteList.map((e) => e.toJson()).toList(),
      'intfTTList': instance.intfTTList.map((e) => e.toJson()).toList(),
    };
