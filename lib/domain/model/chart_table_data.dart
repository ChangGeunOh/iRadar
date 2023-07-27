import 'package:googlemap/domain/model/table_data.dart';
import 'package:json_annotation/json_annotation.dart';

import 'chart_data.dart';

part 'chart_table_data.g.dart';

@JsonSerializable()
class ChartTableData {
  @JsonKey(name: 'chart_data')
  final List<ChartData> chartList;
  @JsonKey(name: 'table_data')
  final List<TableData> tableList;

  ChartTableData({
    required this.chartList,
    required this.tableList,
  });

  factory ChartTableData.fromJson(Map<String, dynamic> json) =>
      _$ChartTableDataFromJson(json);

  Map<String, dynamic> toJson() => _$ChartTableDataToJson(this);
}
