// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoticeData _$NoticeDataFromJson(Map<String, dynamic> json) => NoticeData(
      idx: (json['idx'] as num).toInt(),
      title: json['title'] as String,
      content: json['content'] as String?,
      createdAt: Convert.dynamicToDateTime(json['created_at']),
    );

Map<String, dynamic> _$NoticeDataToJson(NoticeData instance) =>
    <String, dynamic>{
      'idx': instance.idx,
      'title': instance.title,
      'content': instance.content,
      'created_at': instance.createdAt.toIso8601String(),
    };
