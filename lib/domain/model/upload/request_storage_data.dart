import 'dart:convert';

import 'package:googlemap/domain/model/enum/location_type.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../common/utils/convert.dart';

part 'request_storage_data.g.dart';

@JsonSerializable()
class RequestStorageData {

  @JsonKey(
    name: 'fileinfo_m_starttime',
  )
  final String keyDateTime;

  final LocationType division;
  final String name;
  final String address;
  final String center;

  @JsonKey(
    name: 'has_location',
    fromJson: Convert.dynamicToBool,
  )
  final bool hasLocation;

  @JsonKey(
    name: 'mobile_number',
    defaultValue: ''
  )
  final String mobileNumber;

  @JsonKey(
    name: 'is_lte_only',
    fromJson: Convert.dynamicToBool,
  )
  final bool isLteOnly;

  RequestStorageData({
    required this.center,
    required this.keyDateTime,
    required this.division,
    required this.name,
    required this.address,
    required this.mobileNumber,
    this.hasLocation = false,
    this.isLteOnly = false,
  });

  factory RequestStorageData.fromJson(Map<String, dynamic> json) =>
      _$RequestStorageDataFromJson(json);

  Map<String, dynamic> toJson() => _$RequestStorageDataToJson(this);
}
