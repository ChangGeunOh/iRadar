import 'package:json_annotation/json_annotation.dart';

import '../../../common/utils/convert.dart';
import 'page_data.dart';

part 'meta_data.g.dart';

@JsonSerializable()
class MetaData {
  @JsonKey(
    fromJson: Convert.dynamicToInt,
  )
  final int code;
  final String message;
  @JsonKey(
    name: 'time_stamp',
    fromJson: Convert.dynamicToInt,
  )
  final int timeStamp;
  @JsonKey(
    name: 'page_data'
  )
  final PageData? pageData;

  MetaData({
    this.code = 200,
    this.message = '',
    this.timeStamp = 0,
    this.pageData,
  });

  factory MetaData.fromJson(Map<String, dynamic> json) =>
      _$MetaDataFromJson(json);

  Map<String, dynamic> toJson() => _$MetaDataToJson(this);
}

