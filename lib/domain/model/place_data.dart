import 'package:googlemap/domain/model/area_data.dart';
import 'package:json_annotation/json_annotation.dart';

import 'location_type.dart';
import 'wireless_type.dart';

part 'place_data.g.dart';

@JsonSerializable()
class PlaceData {
  final WirelessType wirelessType;
  final String location;
  final LocationType locationType;
  final String name;
  final String regDate;
  final String link;

  PlaceData({
    required this.wirelessType,
    required this.location,
    required this.locationType,
    required this.name,
    required this.regDate,
    required this.link,
  });

  factory PlaceData.fromJson(Map<String, dynamic> json) =>
      _$PlaceDataFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceDataToJson(this);

  // 5G,부산,인빌딩,강서구 김해공항(국제선) ,20230623
  factory PlaceData.fromLine(List<String> values) {
    return PlaceData(
      wirelessType: WirelessType.getByName(values[0]),
      location: values[1],
      locationType: LocationType.getByName(values[2]),
      name: values[3].trim(),
      regDate: values.last,
      link: values.join(" ")
    );
  }

  factory PlaceData.fromAreaData(AreaData areaData) {
    final split = areaData.area.split(' ');
    final firstSplit = split.first.split('_');
    return PlaceData(
      wirelessType: areaData.type,
      location: firstSplit.first,
      locationType: LocationType.getByName(firstSplit.last),
      name: split.last,
      regDate: areaData.date,
      link: areaData.area,
    );
  }
}
