// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_storage_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestStorageData _$RequestStorageDataFromJson(Map<String, dynamic> json) =>
    RequestStorageData(
      requestNumber: (json['request_number'] as num).toInt(),
      division: $enumDecode(_$LocationTypeEnumMap, json['division']),
      name: json['name'] as String,
      address: json['address'] as String,
      startDate: DateTime.parse(json['start_time'] as String),
      endDate: DateTime.parse(json['end_time'] as String),
      hasLocation: json['has_location'] == null
          ? false
          : Convert.dynamicToBool(json['has_location']),
      isLteOnly: json['is_lte_only'] == null
          ? false
          : Convert.dynamicToBool(json['is_lte_only']),
    );

Map<String, dynamic> _$RequestStorageDataToJson(RequestStorageData instance) =>
    <String, dynamic>{
      'request_number': instance.requestNumber,
      'division': _$LocationTypeEnumMap[instance.division]!,
      'name': instance.name,
      'address': instance.address,
      'start_time': instance.startDate.toIso8601String(),
      'end_time': instance.endDate.toIso8601String(),
      'has_location': instance.hasLocation,
      'is_lte_only': instance.isLteOnly,
    };

const _$LocationTypeEnumMap = {
  LocationType.adminBuilding: '행정동',
  LocationType.inBuilding: '인빌딩',
  LocationType.theme: '테마',
  LocationType.undefined: 'undefined',
};
