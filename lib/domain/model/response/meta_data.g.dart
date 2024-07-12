// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meta_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MetaData _$MetaDataFromJson(Map<String, dynamic> json) => MetaData(
      code: json['code'] == null ? 200 : Convert.dynamicToInt(json['code']),
      message: json['message'] as String? ?? '',
      timeStamp: Convert.dynamicToInt(json['time_stamp']),
      pageData: json['page_data'] == null
          ? null
          : PageData.fromJson(json['page_data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MetaDataToJson(MetaData instance) => <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'time_stamp': instance.timeStamp,
      'page_data': instance.pageData,
    };
