// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenData _$TokenDataFromJson(Map<String, dynamic> json) => TokenData(
      refreshToken: json['refresh_token'] as String?,
      accessToken: json['access_token'] as String?,
    );

Map<String, dynamic> _$TokenDataToJson(TokenData instance) => <String, dynamic>{
      'refresh_token': instance.refreshToken,
      'access_token': instance.accessToken,
    };
