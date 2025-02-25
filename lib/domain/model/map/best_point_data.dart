
import 'package:json_annotation/json_annotation.dart';

part 'best_point_data.g.dart';

@JsonSerializable()
class BestPointData {
  final int idx;
  final int pci;
  final double dltp;
  @JsonKey(name: 'lat')
  final double latitude;
  @JsonKey(name: 'lng')
  final double longitude;

  final String address;
  final String memo;

  BestPointData({
    required this.idx,
    required this.pci,
    required this.dltp,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.memo,
  });

  factory BestPointData.fromJson(Map<String, dynamic> json) =>
      _$BestPointDataFromJson(json);

  Map<String, dynamic> qtoJson() => _$BestPointDataToJson(this);

}


/*
class BestData(BaseModel):
    idx: int
    pci: int
    lat: float
    lng: float
    address: str
    memo: str

    class Config:
        from_attributes = True

 */