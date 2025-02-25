// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'measure_upload_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeasureUploadData _$MeasureUploadDataFromJson(Map<String, dynamic> json) =>
    MeasureUploadData(
      area: json['area'] as String? ?? '',
      division: json['division'] as String? ?? '',
      areaIdx: (json['area_idx'] as num?)?.toInt() ?? -1,
      isWideArea: json['is_wide_area'] as bool? ?? false,
      dt: json['dt'] == null ? null : DateTime.parse(json['dt'] as String),
      intf5GList: (json['intf_5g_list'] as List<dynamic>?)
              ?.map((e) => IntfData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      intfLteList: (json['intf_lte_list'] as List<dynamic>?)
              ?.map((e) => IntfData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      intfTTList: (json['intf_tt_list'] as List<dynamic>?)
              ?.map((e) => IntfTtData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$MeasureUploadDataToJson(MeasureUploadData instance) =>
    <String, dynamic>{
      'area': instance.area,
      'division': instance.division,
      'area_idx': instance.areaIdx,
      'is_wide_area': instance.isWideArea,
      'dt': instance.dt?.toIso8601String(),
      'intf_5g_list': instance.intf5GList.map((e) => e.toJson()).toList(),
      'intf_lte_list': instance.intfLteList.map((e) => e.toJson()).toList(),
      'intf_tt_list': instance.intfTTList.map((e) => e.toJson()).toList(),
    };
