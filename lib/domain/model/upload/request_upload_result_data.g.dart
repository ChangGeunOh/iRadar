// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_upload_result_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestUploadResultData _$RequestUploadResultDataFromJson(
        Map<String, dynamic> json) =>
    RequestUploadResultData(
      keyDateTime: json['key_time'] as String,
      areaIdx: (json['area_idx'] as num).toInt(),
      ttCount: (json['tt_count'] as num).toInt(),
      lteCount: (json['lte_count'] as num).toInt(),
      fiveGCount: (json['5g_count'] as num).toInt(),
    );

Map<String, dynamic> _$RequestUploadResultDataToJson(
        RequestUploadResultData instance) =>
    <String, dynamic>{
      'key_time': instance.keyDateTime,
      'area_idx': instance.areaIdx,
      'tt_count': instance.ttCount,
      'lte_count': instance.lteCount,
      '5g_count': instance.fiveGCount,
    };
