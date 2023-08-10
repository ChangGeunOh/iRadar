import 'package:json_annotation/json_annotation.dart';

import 'location_type.dart';
import 'wireless_type.dart';

part 'place_data.g.dart';

@JsonSerializable()
class PlaceData {
  @JsonKey(name: 'type')
  final WirelessType wirelessType;
  final String location;
  final LocationType locationType;
  final String name;
  @JsonKey(name: 'date')
  final String regDate;
  @JsonKey(name: 'area')
  final String link;

  PlaceData({
    required this.wirelessType,
    required this.regDate,
    required this.link,
  })  : location = _getLocation(link),
        name = _getName(link),
        locationType = _getLocationType(link);

  static String _getLocation(String area) {
    return area.split('_').first;
  }

  static String _getName(String area) {
    return area.split(' ').last;
  }

  static LocationType _getLocationType(String area) {
    return LocationType.getByName(area.split(' ').first.split('_').last);
  }

  factory PlaceData.fromJson(Map<String, dynamic> json) =>
      _$PlaceDataFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceDataToJson(this);

  factory PlaceData.fromLine(List<String> values) {
    return PlaceData(
        wirelessType: WirelessType.getByName(values[0]),
        regDate: values.last,
        link: values.join(" "));
  }
}
