import 'package:json_annotation/json_annotation.dart';

import 'intf_data.dart';
import 'intf_tt_data.dart';

part 'measure_upload_data.g.dart';

@JsonSerializable(explicitToJson: true)
class MeasureUploadData {
  late String group;
  late String area;
  late String type;
  late String password;
  late bool isAddData;
  late bool isWideArea;
  final List<IntfData> intf5GList;
  final List<IntfData> intfLteList;
  final List<IntfTtData> intfTTList;

  MeasureUploadData({
    List<IntfData>? intf5GList,
    List<IntfData>? intfLteList,
    List<IntfTtData>? intfTTList,
  })  : intf5GList = intf5GList ?? List.empty(growable: true),
        intfLteList = intfLteList ?? List.empty(growable: true),
        intfTTList = intfTTList ?? List.empty(growable: true);

  Map<String, dynamic> toJson() => _$MeasureUploadDataToJson(this);

  factory MeasureUploadData.fromJson(Map<String, dynamic> json) =>
      _$MeasureUploadDataFromJson(json);
}
