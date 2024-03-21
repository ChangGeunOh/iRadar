import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'login_data.g.dart';

@JsonSerializable()
class LoginData {
  final String userid;
  final String password;

  LoginData({
    required this.userid,
    required this.password,
  });

  Map<String, dynamic> toJson() => _$LoginDataToJson(this);
  factory LoginData.fromJson(Map<String, dynamic> json) => _$LoginDataFromJson(json);

  String toJsonString() => jsonEncode(_$LoginDataToJson(this));
}
