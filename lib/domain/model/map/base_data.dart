import 'package:json_annotation/json_annotation.dart';

import '../../../common/utils/convert.dart';
import '../enum/wireless_type.dart';

part 'base_data.g.dart';

@JsonSerializable()
class BaseData {
  final int idx;
  @JsonKey(
      fromJson: Convert.dynamicToWirelessType
  )
  final WirelessType type;
  final String code;
  final String rnm;
  final int pci;
  @JsonKey(name: 'lat')
  final double latitude;
  @JsonKey(name: 'lng')
  final double longitude;

  BaseData({
    required this.idx,
    required this.code,
    required this.rnm,
    required this.pci,
    required this.latitude,
    required this.longitude,
    required this.type,
  });

  factory BaseData.fromJson(Map<String, dynamic> json) => _$BaseDataFromJson(json);
  Map<String, dynamic> toJson() => _$BaseDataToJson(this);

}


// -- auto-generated definition
// create table test_base
// (
//     idx        int auto_increment
//         primary key,
//     type       varchar(50)                          not null,
//     code       varchar(10)                          null,
//     rnm        varchar(150)                         null,
//     pci        int                                  null,
//     lat        double                               null,
//     lng        double                               null,
//     created_at datetime default current_timestamp() null
// );
