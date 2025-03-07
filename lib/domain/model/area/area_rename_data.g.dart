// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'area_rename_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AreaRenameData _$AreaRenameDataFromJson(Map<String, dynamic> json) =>
    AreaRenameData(
      idx: (json['idx'] as num).toInt(),
      oldName: json['old_name'] as String,
      newName: json['new_name'] as String,
    );

Map<String, dynamic> _$AreaRenameDataToJson(AreaRenameData instance) =>
    <String, dynamic>{
      'idx': instance.idx,
      'old_name': instance.oldName,
      'new_name': instance.newName,
    };
