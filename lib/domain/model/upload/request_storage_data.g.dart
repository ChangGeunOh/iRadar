// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_storage_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestStorageData _$RequestStorageDataFromJson(Map<String, dynamic> json) =>
    RequestStorageData(
      center: json['center'] as String,
      keyDateTime: json['fileinfo_m_starttime'] as String,
      division: LocationType.fromJson(json['division'] as String),
      name: json['name'] as String,
      address: json['address'] as String,
      mobileNumber: json['mobile_number'] as String? ?? '',
      hasLocation: json['has_location'] == null
          ? false
          : Convert.dynamicToBool(json['has_location']),
      isLteOnly: json['is_lte_only'] == null
          ? false
          : Convert.dynamicToBool(json['is_lte_only']),
    );

Map<String, dynamic> _$RequestStorageDataToJson(RequestStorageData instance) =>
    <String, dynamic>{
      'fileinfo_m_starttime': instance.keyDateTime,
      'division': instance.division,
      'name': instance.name,
      'address': instance.address,
      'center': instance.center,
      'has_location': instance.hasLocation,
      'mobile_number': instance.mobileNumber,
      'is_lte_only': instance.isLteOnly,
    };
