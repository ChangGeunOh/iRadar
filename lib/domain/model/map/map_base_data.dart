import 'package:json_annotation/json_annotation.dart';

import '../../../common/utils/convert.dart';
import '../enum/wireless_type.dart';

part 'map_base_data.g.dart';

@JsonSerializable()
class MapBaseData {
  final String code;
  @JsonKey(name: 'rnm')
  final String name;
  @JsonKey(name: 'lat')
  final double latitude;
  @JsonKey(name: 'lng')
  final double longitude;
  final int pci;


  MapBaseData({
    required this.code,
    required this.name,
    required this.pci,
    required this.latitude,
    required this.longitude,
  });

  factory MapBaseData.fromJson(Map<String, dynamic> json) => _$MapBaseDataFromJson(json);
  Map<String, dynamic> toJson() => _$MapBaseDataToJson(this);
}


//      "idx": 22052,
//       "type": "5G",
//       "code": "NRPS09267S",
//       "rnm": "초량3동_망양로삼거리주택_N32T_A",
//       "lat": 35.1230019444,
//       "lng": 129.036281944,
//       "pci": 104