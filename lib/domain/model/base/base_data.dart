import 'package:json_annotation/json_annotation.dart';

part 'base_data.g.dart';

@JsonSerializable()
class BaseData {
  final int idx;
  final String rnm;
  final String code;
  final String type;
  @JsonKey(name: 'lat')
  final double latitude;
  @JsonKey(name: 'lng')
  final double longitude;
  final DateTime createdAt;
  final int pci;

  BaseData({
    this.idx = -1,
    required this.rnm,
    required this.code,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.pci,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory BaseData.fromJson(Map<String, dynamic> json) =>
      _$BaseDataFromJson(json);

  Map<String, dynamic> toJson() => _$BaseDataToJson(this);

  BaseData clearIdx() {
    return BaseData(
      idx: -1,
      rnm: rnm,
      code: code,
      type: type,
      latitude: latitude,
      longitude: longitude,
      pci: pci,
    );
  }

  bool isNotValid() {
    return rnm.replaceAll('-', '').trim().isEmpty ||
        code.replaceAll('-', '').trim().isEmpty ||
        type.isEmpty ||
        latitude == 0.0 ||
        longitude == 0.0;
  }
}

// class BaseTable(Base):
//     __tablename__ = 'table_base'
//     idx = Column(BigInteger, primary_key=True, autoincrement=True)
//     rnm = Column(String(128))
//     type = Column(String(8))
//     code = Column(String(32))
//     group = Column(String(32))
//     lat = Column(Double)
//     lng = Column(Double)
//     pci = Column(String(4))
//     create_at = Column(DateTime, default=datetime.datetime.now, onupdate=datetime.datetime.now)
