// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
      userId: json['userid'] as String,
      userName: json['username'] as String,
      phone: json['phone'] as String? ?? '',
      group1: json['group1'] as String,
      group2: json['group2'] as String,
      group3: json['group3'] as String,
      group4: json['group4'] as String,
      group5: json['group5'] as String,
      areaCode: json['area_code'] as String,
    );

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'userid': instance.userId,
      'username': instance.userName,
      'phone': instance.phone,
      'group1': instance.group1,
      'group2': instance.group2,
      'group3': instance.group3,
      'group4': instance.group4,
      'group5': instance.group5,
      'area_code': instance.areaCode,
    };
