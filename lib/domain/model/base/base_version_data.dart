import 'package:json_annotation/json_annotation.dart';

part 'base_version_data.g.dart';

@JsonSerializable()
class BaseVersionData {
  @JsonKey(
    name: 'view_5g',
  )
  final String view5g;
  @JsonKey(
    name: 'view_lte',
  )
  final String viewLte;
  @JsonKey(
    name: 'table_5g',
  )
  final String table5g;
  @JsonKey(
    name: 'table_lte',
  )
  final String tableLte;

  BaseVersionData({
    this.view5g = '',
    this.viewLte = '',
    this.table5g = '',
    this.tableLte = '',
  });

  factory BaseVersionData.fromJson(Map<String, dynamic> json) =>
      _$BaseVersionDataFromJson(json);

  Map<String, dynamic> toJson() => _$BaseVersionDataToJson(this);
}
