import 'package:googlemap/common/utils/convert.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chart_data.g.dart';

@JsonSerializable()
class ChartData {
  @JsonKey(
    fromJson: Convert.stringToInt,
    toJson: Convert.intToString,
  )
  final int pci;
  @JsonKey(
    fromJson: Convert.stringToDouble,
    toJson: Convert.doubleToString,
  )
  final double index;
  @JsonKey(
    fromJson: Convert.stringToBool,
    toJson: Convert.boolToString,
  )
  final bool hasColor;

  ChartData({
    required this.pci,
    required this.index,
    required this.hasColor,
  });

  factory ChartData.fromJson(Map<String, dynamic> json) =>
      _$ChartDataFromJson(json);

  Map<String, dynamic> toJson() => _$ChartDataToJson(this);
}
