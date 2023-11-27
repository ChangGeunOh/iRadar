import 'package:json_annotation/json_annotation.dart';

import 'base_data.dart';
import 'map_data.dart';

part 'map_base_data.g.dart';

@JsonSerializable()
class MapBaseData {
  @JsonKey(name: 'map_list')
  final List<MapData> measureList;
  @JsonKey(name: 'base_list')
  final List<BaseData> baseList;
  @JsonKey(
    includeFromJson: false,
    includeToJson: true,
  )
  final bool isSelected;

  MapBaseData({
    required this.measureList,
    required this.baseList,
    bool? isSelected,
  }) : isSelected = isSelected ?? true;

  Map<String, dynamic> toJson() => _$MapBaseDataToJson(this);

  factory MapBaseData.fromJson(Map<String, dynamic> json) =>
      _$MapBaseDataFromJson(json);

  MapBaseData copyWith({
    List<MapData>? measureList,
    List<BaseData>? baseList,
    bool? isSelected,
  }) {
    return MapBaseData(
      measureList: measureList ?? this.measureList,
      baseList: baseList ?? this.baseList,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  bool isEmpty() {
    return measureList.isEmpty && baseList.isEmpty;
  }
}
