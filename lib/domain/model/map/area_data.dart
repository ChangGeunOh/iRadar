import 'package:googlemap/domain/model/enum/location_type.dart';
import 'package:googlemap/domain/model/enum/wireless_type.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../common/utils/convert.dart';

part 'area_data.g.dart';

@JsonSerializable()
class AreaData {
  final int idx;
  final String name;
  @JsonKey(
    name: 'type',
    fromJson: Convert.dynamicToWirelessType,
    toJson: Convert.wirelessTypeToDynamic,
  )
  final WirelessType? type;
  final LocationType? division;
  @JsonKey(
    name: 'lat',
  )
  final double? latitude;
  @JsonKey(
    name: 'lng',
  )
  final double? longitude;
  @JsonKey(
    name: 'create_at',
    fromJson: Convert.dynamicToDateTime,
    toJson: Convert.dateTimeToDynamic,
  )
  final DateTime? createdAt;
  @JsonKey(
    name: 'dt',
    fromJson: Convert.dynamicToDateTime,
    toJson: Convert.dateTimeToDynamic,
  )
  final DateTime? measuredAt;

  AreaData({
    required this.idx,
    required this.name,
    this.division,
    this.type,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.measuredAt,
  });

  AreaData copyWith({
    int? idx,
    String? name,
    DateTime? createdAt,
    LocationType? division,
    WirelessType? type,
    double? latitude,
    double? longitude,
    DateTime? measuredAt,
  }) {
    return AreaData(
      idx: idx ?? this.idx,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      division: division ?? this.division,
      type: type ?? this.type,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      measuredAt: measuredAt ?? this.measuredAt,
    );
  }

  factory AreaData.fromJson(Map<String, dynamic> json) =>
      _$AreaDataFromJson(json);

  Map<String, dynamic> toJson() => _$AreaDataToJson(this);


}


// class AreaData(BaseModel):
//     idx: int
//     lat: float
//     lng: float
//     division: str
//     type: str
//     name: str
//     dt: datetime.datetime
//     create_at: datetime.datetime
//
//     class Config:
//         from_attributes = True