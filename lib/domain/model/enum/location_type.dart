import 'package:json_annotation/json_annotation.dart';

enum LocationType {
  @JsonValue('행정동')
  adminBuilding('행정동'),
  @JsonValue('인빌딩')
  inBuilding('인빌딩'),
  @JsonValue('테마')
  theme('테마'),
  undefined('undefined');

  final String name;

  const LocationType(this.name);

  factory LocationType.getByName(String name) {
    return LocationType.values.firstWhere(
          (element) => element.name == name,
      orElse: () => LocationType.undefined,
    );
  }
}
