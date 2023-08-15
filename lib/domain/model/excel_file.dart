import 'dart:math';

import 'package:collection/collection.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:googlemap/common/utils/extension.dart';

import 'intf_data.dart';
import 'intf_tt_data.dart';
import 'measure_upload_data.dart';

class ExcelFile {
  final Uint8List bytes;
  final MeasureUploadData measureUploadData;
  late final Excel excel;
  late final Sheet sheet;

  late bool isNoLocation;
  late bool isLteOnly;

  final defaultLocation = ['129.150552778', '35.1604083333'];

  ExcelFile({
    required this.bytes,
  }) : measureUploadData = MeasureUploadData() {
    _init();
  }

  Future<void> _init() async {
    excel = Excel.decodeBytes(bytes);
    sheet = excel.sheets.values.first;
    isNoLocation = sheet.maxCols == 20 || sheet.maxCols == 10;
    isLteOnly = sheet.maxCols == 11 || sheet.maxCols == 13;
    getMeasureData();
  }

  MeasureUploadData getMeasureData() {
    // MeasureUploadData measureUploadData = MeasureUploadData();
    sheet.rows.forEachIndexed((index, row) {
      if (row.first != null && row.first!.value.runtimeType == double) {
        final rowData = _makeData(row, isNoLocation, isLteOnly);
        measureUploadData.intf5GList.addAll(rowData.intf5GList);
        measureUploadData.intfLteList.addAll(rowData.intfLteList);
        measureUploadData.intfTTList.addAll(rowData.intfTTList);
      }
    });

    return measureUploadData;
  }

  MeasureUploadData getUploadData({
    required String type,
    required String area,
    required String group,
    required String password,
    required bool isAddData,
    required bool isWideArea,
  }) {
    measureUploadData.type = type;
    measureUploadData.area = area;
    measureUploadData.group = group;
    measureUploadData.password = password;
    measureUploadData.isAddData = isAddData;
    measureUploadData.isWideArea = isWideArea;

    return measureUploadData;
  }

  MeasureUploadData _makeData(
    List<Data?> row,
    bool isNoLocation,
    bool isLteOnly,
  ) {
    MeasureUploadData measureUploadData = MeasureUploadData();

    var list = row.map((e) => e?.value ?? '').toList();
    if (isNoLocation) {
      list.insertAll(1, defaultLocation); // '129.150552778','35.1604083333'
    }
    if (isLteOnly) {
      list.insertAll(3, ['', '', '']);
      list.insertAll(9, ['', '', '', '', '', '']);
    }

    final regex5g = RegExp(r'(\d+)\(([^)]+)\)\(([^)]+)\)');
    for (var match in regex5g.allMatches(list[3].toString())) {
      final rp = double.parse(match.group(2)!);
      final intf5GData = IntfData(
        idx: 0,
        area: 'area',
        pci: match.group(1)!,
        dt: (list[0] as double).toDateTime(),
        lat: double.parse(list[2].toString()),
        lng: double.parse(list[1].toString()),
        rp: rp,
        rpmw: pow(10, rp / 10.0).toDouble(),
        spci: list[4].toString(),
        srp: list[5], // double
      );
      measureUploadData.intf5GList.add(intf5GData);
    }

    final regexLte = RegExp(r"(\d+)\[(-?\d+\.\d+)\]\[(-?\d+\.\d+)\]");
    for (var match in regexLte.allMatches(list[6].toString())) {
      // print("${match.group(1)}, ${match.group(2)}, ${match.group(3)}");
      final rp = double.parse(match.group(2)!);
      final intfData = IntfData(
        idx: 0,
        area: 'area',
        pci: match.group(1)!,
        dt: (list[0] as double).toDateTime(),
        lat: double.parse(list[2].toString()),
        lng: double.parse(list[1].toString()),
        rp: rp,
        rpmw: pow(10, rp / 10.0).toDouble(),
        // $rpmw = pow( 10 , ($spci[1]/10));
        spci: list[7].toString(),
        // int
        srp: list[8], // double
      );
      measureUploadData.intfLteList.add(intfData);
    }

    list[16] = list[16].toString().replaceAll(RegExp(r'[^0-9]'), '');
    list[18] = list[18].toString().replaceAll(RegExp(r'[^0-9]'), '');
    final intfTtData = IntfTtData(
      idx: 0,
      area: 'area',
      lat: _getDouble(list[2]),
      lng: _getDouble(list[1]),
      pci5: list[4].toString(),
      rp5: _getDouble(list[5]),
      pci: list[7].toString(),
      rp: _getDouble(list[8]),
      pw: 'pw',
      cqi5: _getDouble(list[9]),
      ri5: _getDouble(list[10]),
      dlmcs5: _getDouble(list[11]),
      dll5: _getDouble(list[12]),
      dlrb5: _getDouble(list[13]),
      dl5: _getDouble(list[14]),
      ear: _getDouble(list[15]),
      ca: _getDouble(list[16]),
      cqi: _getDouble(list[17]),
      ri: _getDouble(list[18]),
      mcs: _getDouble(list[19]),
      rb: _getDouble(list[20]),
      dl: _getDouble(list[21]),
    );
    measureUploadData.intfTTList.add(intfTtData);

    return measureUploadData;
  }

  double? _getDouble(dynamic value) {
    return value.runtimeType == double
        ? value
        : value.toString().isEmpty
            ? null
            : double.parse(value.toString());
  }
}
