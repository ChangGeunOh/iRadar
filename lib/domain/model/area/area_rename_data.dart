import 'package:json_annotation/json_annotation.dart';

part 'area_rename_data.g.dart';

@JsonSerializable()
class AreaRenameData {
  final int idx;
  @JsonKey(name:'old_name')
  final String oldName;
  @JsonKey(name: 'new_name')
  final String newName;

  AreaRenameData({
    required this.idx,
    required this.oldName,
    required this.newName,
  });

  factory AreaRenameData.fromJson(Map<String, dynamic> json) =>
      _$AreaRenameDataFromJson(json);

  Map<String, dynamic> toJson() => _$AreaRenameDataToJson(this);
}