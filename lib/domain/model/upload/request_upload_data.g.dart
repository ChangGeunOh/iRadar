// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_upload_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestUploadData _$RequestUploadDataFromJson(Map<String, dynamic> json) =>
    RequestUploadData(
      keyDateTime: json['key_date_time'] as String,
      division: LocationType.fromJson(json['division'] as String),
      name: json['name'] as String,
      appendAreIdx: (json['append_key'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$RequestUploadDataToJson(RequestUploadData instance) =>
    <String, dynamic>{
      'key_date_time': instance.keyDateTime,
      'division': instance.division.toJson(),
      'name': instance.name,
      'append_key': instance.appendAreIdx,
    };
