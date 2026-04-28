import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

import '../../domain/model/base/base_data.dart';

class BaseCsvFile {
  final ruId = ['ru_id', 'id', '장비ID'];
  final ruName = ['ru_name', 'name', '장비명'];
  final pci = ['pci', 'physicalLayerCellId', 'LTE모국(1.8)PN'];
  final lat = ['lat', 'latitude', '위도'];
  final lng = ['lng', 'longitude', '경도'];

  final PlatformFile file;
  final List<List<dynamic>> fields = [];
  final List<BaseData> baseDataList = [];

  BaseCsvFile({
    required this.file,
  });

  Future<void> process() async {
    // csv 8.x부터는 스트림 변환용 CsvToListConverter가 제거되어,
    // 바이트를 문자열로 디코딩 후 fromCsvString으로 파싱한다.
    final bytes = file.bytes;
    if (bytes == null) {
      return;
    }

    final csvText = const Utf8Decoder().convert(bytes);
    final list = const CsvDecoder().convert(csvText);

    final header = list.first;
    final ruIdIndex = header.indexWhere((element) => ruId.contains(element));
    final ruNameIndex =
        header.indexWhere((element) => ruName.contains(element));
    final pciIndex = header.indexWhere((element) => pci.contains(element));
    final latIndex = header.indexWhere((element) => lat.contains(element));
    final lngIndex = header.indexWhere((element) => lng.contains(element));

    for (var i = 1; i < list.length; i++) {
      final row = list[i];
      if (kDebugMode) {
        // ignore: avoid_print
        print('row: $row');
        // ignore: avoid_print
        print(
          'i: $i, ruIdIndex: $ruIdIndex, ruNameIndex: $ruNameIndex, pciIndex: $pciIndex, latIndex: $latIndex, lngIndex: $lngIndex',
        );
      }
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

    List<String> parts = coordinate.split(RegExp(r"[-:\s]+"));
    if (kDebugMode) {
      // ignore: avoid_print
      print(
        'coordinate: $coordinate :: parts: $parts :: parts.length: ${parts.length}',
      );
    }
    if (parts.length != 4 && parts.length != 3) {
      return 0.0;
    }
    double degrees = double.parse(parts[parts.length == 4 ? 1 : 0].replaceAll(RegExp(r'[^\d.-]'), ''));
    double minutes = double.parse(parts[parts.length == 4 ? 2 : 1]);
    double seconds = double.parse(parts[parts.length == 4 ? 3 : 2]);
    double decimalDegrees = degrees + (minutes / 60) + (seconds / 3600);

    return decimalDegrees;
  }
}

/*
void main() {
  print(convertToLatLng("035:33:51.402"));  // 결과: 35.564278333333336
  print(convertToLatLng("128:44:15.594"));  // 결과: 128.737665
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

  // ':' 또는 공백 문자로 분할
  List<String> parts = coordinate.split(RegExp(r"[:\s]+"));
  print('coordinate: $coordinate :: parts: $parts :: parts.length: ${parts.length}');

  if (parts.length < 3) {
    return 0.0;
  }

  double degrees = double.parse(parts[0].replaceAll(RegExp(r'[^\d.-]'), ''));
  double minutes = double.parse(parts[1]);
  double seconds = double.parse(parts[2]);
  double decimalDegrees = degrees + (minutes / 60) + (seconds / 3600);

  return decimalDegrees;
}

 */