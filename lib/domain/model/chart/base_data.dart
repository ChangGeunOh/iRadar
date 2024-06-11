import 'package:json_annotation/json_annotation.dart';

part 'base_data.g.dart';

@JsonSerializable()
class BaseData {
  final String code;
  final String name;
  final double distance;
  final bool isChecked;

  BaseData({
    required this.code,
    required this.name,
    required this.distance,
    this.isChecked = false,
  });

  factory BaseData.fromJson(Map<String, dynamic> json) =>
      _$BaseDataFromJson(json);

  Map<String, dynamic> toJson() => _$BaseDataToJson(this);

  BaseData copyWith({
    String? code,
    String? name,
    double? distance,
    bool? isChecked,
  }) {
    return BaseData(
      code: code ?? this.code,
      name: name ?? this.name,
      distance: distance ?? this.distance,
      isChecked: isChecked ?? this.isChecked,
    );
  }

  String getDescription() {
    return '(${(distance).toStringAsFixed(2)}km) $name / $code';
  }
}
