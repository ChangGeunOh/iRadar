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

  factory MapBaseData.fromJson(Map<String, dynamic> json) =>
      _$MapBaseDataFromJson(json);

  Map<String, dynamic> toJson() => _$MapBaseDataToJson(this);

  MapBaseData copyWith({
    String? code,
    String? name,
    int? pci,
    double? latitude,
    double? longitude,
  }) {
    return MapBaseData(
      code: code ?? this.code,
      name: name ?? this.name,
      pci: pci ?? this.pci,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  bool get isRelay => ['RS', 'RB', 'RE'].any((e) => code.startsWith(e));

  String iconPath(WirelessType type) {
    if (type == WirelessType.w5G) {
      return 'assets/icons/pin_base_5g.png';
    } else if (isRelay) {
      return 'assets/icons/pin_base_relay.png';
    }
    return 'assets/icons/pin_base_lte.png';
  }
}
