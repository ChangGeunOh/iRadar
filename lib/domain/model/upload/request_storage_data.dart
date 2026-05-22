import 'dart:convert';

import 'package:googlemap/domain/model/enum/location_type.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../common/utils/convert.dart';

part 'request_storage_data.g.dart';

@JsonSerializable()
class RequestStorageData {
  @JsonKey(
    name: 'request_number',
  )
  final int requestNumber;
  final LocationType division;
  final String name;
  final String address;
  @JsonKey(
    name: 'start_time',
  )
  final DateTime startDate;
  @JsonKey(
    name: 'end_time',
  )
  final DateTime endDate;

  @JsonKey(
    name: 'has_location',
    fromJson: Convert.dynamicToBool,
  )
  final bool hasLocation;

  @JsonKey(
    name: 'is_lte_only',
    fromJson: Convert.dynamicToBool,
  )
  final bool isLteOnly;

  RequestStorageData({
    required this.requestNumber,
    required this.division,
    required this.name,
    required this.address,
    required this.startDate,
    required this.endDate,
    this.hasLocation = false,
    this.isLteOnly = false,
  });

  factory RequestStorageData.fromJson(Map<String, dynamic> json) =>
      _$RequestStorageDataFromJson(json);

  Map<String, dynamic> toJson() => _$RequestStorageDataToJson(this);
}
