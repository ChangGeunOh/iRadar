import 'package:json_annotation/json_annotation.dart';

import '../../common/utils/convert.dart';

part 'meta_data.g.dart';

@JsonSerializable()
class MetaData {
  @JsonKey(
    fromJson: Convert.dynamicToInt,
  )
  final int code;
  final String message;
  @JsonKey(
    fromJson: Convert.dynamicToInt,
  )
  final int count;
  @JsonKey(
    fromJson: Convert.dynamicToInt,
  )
  final int total;
  @JsonKey(
    fromJson: Convert.dynamicToInt,
  )
  final int page;

  MetaData({
    required this.code,
    required this.message,
    int? count,
    int? total,
    int? page,
  })  : count = count ?? 30,
        total = total ?? 0,
        page = page ?? 0;

  factory MetaData.fromJson(Map<String, dynamic> json) =>
      _$MetaDataFromJson(json);

  Map<String, dynamic> toJson() => _$MetaDataToJson(this);
}
