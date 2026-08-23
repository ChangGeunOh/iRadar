import 'package:json_annotation/json_annotation.dart';

part 'request_upload_result_data.g.dart';

@JsonSerializable()
class RequestUploadResultData {
  @JsonKey(
    name: 'key_time',
  )
  final String keyDateTime;

  @JsonKey(
    name: 'area_idx',
  )
  final int areaIdx;

  @JsonKey(name: 'tt_count',)
  final int ttCount;

  @JsonKey(name: 'lte_count',)
  final int lteCount;

  @JsonKey(name: '5g_count',)
  final int fiveGCount;

  RequestUploadResultData({
    required this.keyDateTime,
    required this.areaIdx,
    required this.ttCount,
    required this.lteCount,
    required this.fiveGCount,
  });

  factory RequestUploadResultData.fromJson(Map<String, dynamic> json) =>
      _$RequestUploadResultDataFromJson(json);

  Map<String, dynamic> toJson() => _$RequestUploadResultDataToJson(this);

}