// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'page_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PageData _$PageDataFromJson(Map<String, dynamic> json) => PageData(
      page: (json['page'] as num).toInt(),
      count: (json['count'] as num).toInt(),
      total: (json['total'] as num).toInt(),
    );

Map<String, dynamic> _$PageDataToJson(PageData instance) => <String, dynamic>{
      'page': instance.page,
      'count': instance.count,
      'total': instance.total,
    };
