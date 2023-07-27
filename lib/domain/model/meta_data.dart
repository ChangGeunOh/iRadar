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

  MetaData({
  required this.code,
  required this.message,
  });

  factory MetaData.fromJson(Map<String, dynamic> json) => _$MetaDataFromJson(json);

  Map<String, dynamic> toJson() => _$MetaDataToJson(this);
  }
