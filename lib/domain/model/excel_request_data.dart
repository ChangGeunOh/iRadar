import 'package:googlemap/domain/model/map/area_data.dart';
import 'package:json_annotation/json_annotation.dart';

import 'chart/measure_data.dart';
import 'place_data.dart';
import 'table_data.dart';

part 'excel_request_data.g.dart';

@JsonSerializable()
class ExcelRequestData {
  final AreaData areaData;
  final List<MeasureData> measureDataList;

  ExcelRequestData({
    required this.areaData,
    required this.measureDataList,
  });
  
  Map<String, dynamic> toJson() => _$ExcelRequestDataToJson(this);
  factory ExcelRequestData.fromJson(Map<String, dynamic> json) => _$ExcelRequestDataFromJson(json);
}
