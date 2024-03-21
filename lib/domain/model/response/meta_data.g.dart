// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meta_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MetaData _$MetaDataFromJson(Map<String, dynamic> json) => MetaData(
      code: Convert.dynamicToInt(json['code']),
      message: json['message'] as String,
      timeStamp: json['time_stamp'] == null
          ? 0
          : Convert.dynamicToInt(json['time_stamp']),
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
