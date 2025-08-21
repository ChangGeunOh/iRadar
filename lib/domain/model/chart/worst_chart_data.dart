import 'package:googlemap/domain/model/chart/measure_data.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../common/utils/convert.dart';

part 'worst_chart_data.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class WorstChartData {
  final int idx;
  final String name;

  @JsonKey(
    name: 'measured_at',
    fromJson: Convert.dynamicToDateTime,
  )
  final DateTime measuredAt;
  @JsonKey(
    name: 'worst_list'
  )
  final List<MeasureData>? worstList;

  WorstChartData({
    required this.idx,
    required this.name,
    required this.measuredAt,
    this.worstList = const [],
  });

  factory WorstChartData.fromJson(Map<String, dynamic> json) =>
      _$WorstChartDataFromJson(json);
  Map<String, dynamic> toJson() => _$WorstChartDataToJson(this);

}
