import 'package:json_annotation/json_annotation.dart';

enum WirelessType {
  @JsonValue('LTE')
  wLte('LTE'),
  @JsonValue('5G')
  w5G('5G'),
  @JsonValue('ALL')
  all('ALL'),
  undefined('undefined');

  final String name;

  const WirelessType(this.name);

  factory WirelessType.getByName(String name) {
    return WirelessType.values.firstWhere(
          (element) => element.name == name,
      orElse: () => WirelessType.undefined,
    );
  }
}