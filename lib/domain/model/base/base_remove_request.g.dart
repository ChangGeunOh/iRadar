// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_remove_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseRemoveRequest _$BaseRemoveRequestFromJson(Map<String, dynamic> json) =>
    BaseRemoveRequest(
      idList: (json['idList'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          const [],
    );

Map<String, dynamic> _$BaseRemoveRequestToJson(BaseRemoveRequest instance) =>
    <String, dynamic>{
      'idList': instance.idList,
    };
