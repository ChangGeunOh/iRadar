import 'package:json_annotation/json_annotation.dart';

import 'place_data.dart';
import 'table_data.dart';

part 'excel_request_data.g.dart';

@JsonSerializable()
class ExcelRequestData {
  final PlaceData placeData;
  final List<TableData> tableList;

  ExcelRequestData({
    required this.placeData,
    required this.tableList,
  });
  
  Map<String, dynamic> toJson() => _$ExcelRequestDataToJson(this);
  factory ExcelRequestData.fromJson(Map<String, dynamic> json) => _$ExcelRequestDataFromJson(json);
}
