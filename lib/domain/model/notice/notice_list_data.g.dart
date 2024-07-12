// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice_list_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoticeListData _$NoticeListDataFromJson(Map<String, dynamic> json) =>
    NoticeListData(
      currentPage: (json['currentPage'] as num?)?.toInt() ?? 0,
      totalPage: (json['totalPage'] as num?)?.toInt() ?? 0,
      dataList: (json['dataList'] as List<dynamic>)
          .map((e) => NoticeData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NoticeListDataToJson(NoticeListData instance) =>
    <String, dynamic>{
      'currentPage': instance.currentPage,
      'totalPage': instance.totalPage,
      'dataList': instance.dataList,
    };
