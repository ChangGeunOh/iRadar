import 'package:json_annotation/json_annotation.dart';

import 'location_type.dart';
import 'wireless_type.dart';

part 'place_data.g.dart';

@JsonSerializable()
class PlaceData {
  final int idx;
  final WirelessType type;
  final String group;
  final String name;
  final LocationType division;
  final double latitude;
  final double longitude;
  final String dateTime;
  final String link;
  late bool isSelected = false;

  /*
          {
            "idx": 104,
            "type": "5G",
            "area": "[MOS]중구_보수동",
            "division": "행정동",
            "latitude": 35.10589,
            "longitude": 129.02375,
            "datetime": "2023-07-17 12:59:16"
        },
   */

  PlaceData({
    required this.idx,
    required this.type,
    required this.group,
    required this.name,
    required this.division,
    required this.latitude,
    required this.longitude,
    required this.dateTime,
    String? link,
    bool? isSelected,
  })  : link = link ?? '';

  factory PlaceData.fromJson(Map<String, dynamic> json) =>
      _$PlaceDataFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceDataToJson(this);

  PlaceData copy() {
    return PlaceData(
      idx: idx,
      type: type,
      group: group,
      name: name,
      division: division,
      latitude: latitude,
      longitude: longitude,
      dateTime: dateTime,
      link: link,
      isSelected: isSelected,
    );
  }

  toggle() {
    isSelected = !isSelected;
  }
}
