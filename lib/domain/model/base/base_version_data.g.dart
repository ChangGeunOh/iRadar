// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_version_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseVersionData _$BaseVersionDataFromJson(Map<String, dynamic> json) =>
    BaseVersionData(
      view5g: json['view_5g'] as String? ?? '',
      viewLte: json['view_lte'] as String? ?? '',
      table5g: json['table_5g'] as String? ?? '',
      tableLte: json['table_lte'] as String? ?? '',
    );

Map<String, dynamic> _$BaseVersionDataToJson(BaseVersionData instance) =>
    <String, dynamic>{
      'view_5g': instance.view5g,
      'view_lte': instance.viewLte,
      'table_5g': instance.table5g,
      'table_lte': instance.tableLte,
    };
