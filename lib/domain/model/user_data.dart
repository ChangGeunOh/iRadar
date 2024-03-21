import 'package:json_annotation/json_annotation.dart';

part 'user_data.g.dart';

@JsonSerializable()
class UserData {
  @JsonKey(name: 'userid')
  final String userId;
  @JsonKey(name: 'username')
  final String userName;
  @JsonKey(defaultValue: '')
  final String phone;
  final String group1;
  final String group2;
  final String group3;
  final String group4;
  final String group5;
  @JsonKey(name: 'area_code')
  final String areaCode;


  UserData({
    required this.userId,
    required this.userName,
    required this.phone,
    required this.group1,
    required this.group2,
    required this.group3,
    required this.group4,
    required this.group5,
    required this.areaCode,
  });

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}
//║             userid: "12345678",
// ║             username: "오창근",
// ║             phone: "01066552842",
// ║             group1: "부산/경남광역본부",
// ║             group2: "부산/경남NW운용본부",
// ║             group3: "경남액세스운용센터",
// ║             group4: "동진주운용부",
// ║             group5: "",
// ║             area_code: "test"


// class UserCreate(UserLogin):
// username: str
// phone: str
// group1: str
// group2: str
// group3: str
// group4: str
// group5: str
// area_code: str