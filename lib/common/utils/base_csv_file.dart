import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';

import '../../domain/model/base/base_data.dart';

class BaseCsvFile {
  final ruId = ['ru_id', 'id'];
  final ruName = ['ru_name', 'name'];
  final pci = ['pci', 'physicalLayerCellId'];
  final lat = ['lat', 'latitude', '위도'];
  final lng = ['lng', 'longitude', '경도'];

  final PlatformFile file;
  final List<List<dynamic>> fields = [];
  final List<BaseData> baseDataList = [];

  BaseCsvFile({
    required this.file,
  });

  Future<void> process() async {
    final input = Stream.fromIterable(file.bytes!.map((e) => [e]));
    final list = await input
        .transform(const Utf8Decoder())
        .transform(const CsvToListConverter())
        .toList();

    final header = list.first;
    final ruIdIndex = header.indexWhere((element) => ruId.contains(element));
    final ruNameIndex =
        header.indexWhere((element) => ruName.contains(element));
    final pciIndex = header.indexWhere((element) => pci.contains(element));
    final latIndex = header.indexWhere((element) => lat.contains(element));
    final lngIndex = header.indexWhere((element) => lng.contains(element));

    for (var i = 1; i < list.length; i++) {
      final row = list[i];
      final baseData = _createBaseData(
        i,
        row,
        ruIdIndex,
        ruNameIndex,
        pciIndex,
        latIndex,
        lngIndex,
      );
      if (baseData != null) {
        baseDataList.add(baseData);
      }
    }
  }

  List<BaseData> get getBaseDataList => baseDataList;

  BaseData? _createBaseData(
    int index,
    List<dynamic> row,
    int ruIdIndex,
    int ruNameIndex,
    int pciIndex,
    int latIndex,
    int lngIndex,
  ) {
    final ruId = row[ruIdIndex]?.toString();
    final ruName = row[ruNameIndex]?.toString();
    final pci = row[pciIndex]?.toString();
    final lat = row[latIndex]?.toString();
    final lng = row[lngIndex]?.toString();

    final doubleLat = convertToLatLng(lat ?? '');
    final doubleLng = convertToLatLng(lng ?? '');
    final intPci = int.tryParse(pci ?? '');

    // if (intPci == null ||
    //     ruName == '-' ||
    //     (ruName?.isEmpty ?? true) ||
    //     ruId == '-' ||
    //     (ruId?.isEmpty ?? true) ||
    //     lat == '-' ||
    //     (lat?.isEmpty ?? true) ||
    //     lng == '-' ||
    //     (lng?.isEmpty ?? true) ||
    //     doubleLat == 0.0 ||
    //     doubleLng == 0.0) {
    //   return null;
    // }

    return BaseData(
      idx: index,
      rnm: ruName!,
      code: ruId!,
      type: ruId.startsWith('R') ? 'LTE' : '5G',
      latitude: doubleLat,
      longitude: doubleLng,
      pci: intPci ?? -1,
    );
  }

  double convertToLatLng(String coordinate) {
    var latLng = int.tryParse(coordinate);
    if (latLng != null) {
      return latLng.toDouble() / 1000000.0;
    }

    final doubleLatLng = double.tryParse(coordinate);
    if (doubleLatLng != null) {
      return doubleLatLng;
    }

    List<String> parts = coordinate.split(RegExp(r"[ :]+"));
    if (parts.length != 4) {
      return 0.0;
    }
    double degrees = double.parse(parts[1]);
    double minutes = double.parse(parts[2]);
    double seconds = double.parse(parts[3]);
    double decimalDegrees = degrees + (minutes / 60) + (seconds / 3600);

    return decimalDegrees;
  }
}