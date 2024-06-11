import 'package:json_annotation/json_annotation.dart';

import 'intf_data.dart';
import 'intf_tt_data.dart';

part 'measure_upload_data.g.dart';

@JsonSerializable(explicitToJson: true)
class MeasureUploadData {
  final String area;
  final String division;
  @JsonKey(
    name: 'area_idx',
  )
  final int areaIdx;
  @JsonKey(
    defaultValue: false,
    name: 'is_wide_area',
  )
  final bool isWideArea;
  @JsonKey(
    name: 'area_code',
  )
  final String areaCode;
  final DateTime? dt;

  @JsonKey(
    defaultValue: [],
    name: 'intf_5g_list',
  )
  final List<IntfData> intf5GList;
  @JsonKey(
    defaultValue: [],
    name: 'intf_lte_list',
  )
  final List<IntfData> intfLteList;
  @JsonKey(
    defaultValue: [],
    name: 'intf_tt_list',
  )
  final List<IntfTtData> intfTTList;

  MeasureUploadData({
    this.area = '',
    this.division = '',
    this.areaIdx = 0,
    this.isWideArea = false,
    this.areaCode = '',
    this.dt,
    List<IntfData>? intf5GList,
    List<IntfData>? intfLteList,
    List<IntfTtData>? intfTTList,
  })  : intf5GList = intf5GList ?? List.empty(growable: true),
        intfLteList = intfLteList ?? List.empty(growable: true),
        intfTTList = intfTTList ?? List.empty(growable: true);

  MeasureUploadData copyWith({
    String? area,
    String? type,
    int? areaIdx,
    String? division,
    bool? isWideArea,
    String? areaCode,
    DateTime? dt,
    List<IntfData>? intf5GList,
    List<IntfData>? intfLteList,
    List<IntfTtData>? intfTTList,
  }) {
    return MeasureUploadData(
      area: area ?? this.area,
      areaIdx: areaIdx ?? this.areaIdx,
      division: division ?? this.division,
      areaCode: areaCode ?? this.areaCode,
      isWideArea: isWideArea ?? this.isWideArea,
      dt: dt ?? this.dt,
      intf5GList: intf5GList ?? this.intf5GList,
      intfLteList: intfLteList ?? this.intfLteList,
      intfTTList: intfTTList ?? this.intfTTList,
    );
  }

  Map<String, dynamic> toJson() => _$MeasureUploadDataToJson(this);

  factory MeasureUploadData.fromJson(Map<String, dynamic> json) =>
      _$MeasureUploadDataFromJson(json);
}
