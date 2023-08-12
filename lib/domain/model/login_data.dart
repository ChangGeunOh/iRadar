import 'package:json_annotation/json_annotation.dart';

part 'login_data.g.dart';

@JsonSerializable()
class LoginData {
  final int idx;
  final String group;

  LoginData({
    required this.idx,
    required this.group,
  });

  Map<String, dynamic> toJson() => _$LoginDataToJson(this);
  factory LoginData.fromJson(Map<String, dynamic> json) => _$LoginDataFromJson(json);
}
