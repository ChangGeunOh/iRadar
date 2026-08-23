import 'package:googlemap/domain/model/enum/location_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'request_upload_data.g.dart';

@JsonSerializable(explicitToJson: true)
class RequestUploadData {
  @JsonKey(
    name: 'key_date_time',
  )
  String keyDateTime;
  LocationType division;

  String name;

  @JsonKey(
    name: 'append_key',
  )
  int appendAreIdx;

  RequestUploadData({
    required this.keyDateTime,
    required this.division,
    required this.name,
    this.appendAreIdx = 0,
  });

  factory RequestUploadData.fromJson(Map<String, dynamic> json) =>
      _$RequestUploadDataFromJson(json);

  Map<String, dynamic> toJson() => _$RequestUploadDataToJson(this);

}