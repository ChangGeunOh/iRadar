import 'package:json_annotation/json_annotation.dart';

enum LocationType {
  @JsonValue('행정동')
  adminBuilding('행정동'),
  @JsonValue('인빌딩')
  inBuilding('인빌딩'),
  @JsonValue('테마')
  theme('테마'),
  @JsonValue('모름')
  undefined('undefined');

  final String name;

  const LocationType(this.name);

  // json_annotation 호환용 fromJson / toJson
  factory LocationType.fromJson(String name) {
    return LocationType.values.firstWhere(
          (element) => element.name == name,
      orElse: () {
        if (name == '도로') {
          return LocationType.adminBuilding;
        }
        return LocationType.undefined;
      },
    );
  }

  String toJson() => name;
}
