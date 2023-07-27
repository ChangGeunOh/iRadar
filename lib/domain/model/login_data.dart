import 'package:json_annotation/json_annotation.dart';

part 'login_data.g.dart';

@JsonSerializable()
class LoginData {
  final int idx;
  final String area;

  LoginData({
    required this.idx,
    required this.area,
  });

  Map<String, dynamic> toJson() => _$LoginDataToJson(this);
  factory LoginData.fromJson(Map<String, dynamic> json) => _$LoginDataFromJson(json);
}
