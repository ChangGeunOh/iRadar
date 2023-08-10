// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meta_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MetaData _$MetaDataFromJson(Map<String, dynamic> json) => MetaData(
      code: Convert.dynamicToInt(json['code']),
      message: json['message'] as String,
      count: Convert.dynamicToInt(json['count']),
      total: Convert.dynamicToInt(json['total']),
      page: Convert.dynamicToInt(json['page']),
    );

Map<String, dynamic> _$MetaDataToJson(MetaData instance) => <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'count': instance.count,
      'total': instance.total,
      'page': instance.page,
    };
