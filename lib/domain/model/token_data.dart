import 'package:json_annotation/json_annotation.dart';

part 'token_data.g.dart';

@JsonSerializable()
class TokenData {
  @JsonKey(name : 'refresh_token')
  final String? refreshToken;
  @JsonKey(name : 'access_token')
  final String? accessToken;

  TokenData({
    this.refreshToken,
    this.accessToken,
  });

  TokenData copyWith({
    String? refreshToken,
    String? accessToken,
  }) {
    return TokenData(
      refreshToken: refreshToken ?? this.refreshToken,
      accessToken: accessToken ?? this.accessToken,
    );
  }

  factory TokenData.fromJson(Map<String, dynamic> json) => _$TokenDataFromJson(json);
  Map<String, dynamic> toJson() => _$TokenDataToJson(this);
}

