import 'package:json_annotation/json_annotation.dart';

import 'intf_data.dart';
import 'intf_tt_data.dart';

part 'measure_upload_data.g.dart';

@JsonSerializable()
class MeasureUploadData {
  late String group;
  late String area;
  late String? password;
  final List<IntfData> intf5GList = List.empty(growable: true);
  final List<IntfData> intfLteList = List.empty(growable: true);
  final List<IntfTtData> intfTTList = List.empty(growable: true);

  MeasureUploadData();
  
  Map<String, dynamic> toJson() => _$MeasureUploadDataToJson(this);
  factory MeasureUploadData.fromJson(Map<String, dynamic> json) => _$MeasureUploadDataFromJson(json);
  
}
