import 'package:json_annotation/json_annotation.dart';

import 'base_data.dart';
import 'measure_data.dart';

part 'map_data.g.dart';

@JsonSerializable()
class MapData {
  @JsonKey(name: 'measure_list')
  final List<MeasureData> measureList;
  @JsonKey(name: 'base_list')
  final List<BaseData> baseList;
  @JsonKey(
    includeFromJson: false,
    includeToJson: true,
  )
  final bool isSelected;

  MapData({
    required this.measureList,
    required this.baseList,
    bool? isSelected,
  }) : isSelected = isSelected ?? true;

  Map<String, dynamic> toJson() => _$MapDataToJson(this);

  factory MapData.fromJson(Map<String, dynamic> json) =>
      _$MapDataFromJson(json);

  MapData copyWith(bool? isSelected) {
    return MapData(
      measureList: measureList,
      baseList: baseList,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
