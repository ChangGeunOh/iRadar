import 'package:googlemap/domain/model/place_data.dart';
import 'package:googlemap/domain/model/table_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'place_table_data.g.dart';

@JsonSerializable()
class PlaceTableData {
  final PlaceData placeData;
  final TableData tableData;

  PlaceTableData({
    required this.placeData,
    required this.tableData,
});

  factory PlaceTableData.fromJson(Map<String, dynamic> json) => _$PlaceTableDataFromJson(json);
  Map<String, dynamic> toJson() => _$PlaceTableDataToJson(this);
}