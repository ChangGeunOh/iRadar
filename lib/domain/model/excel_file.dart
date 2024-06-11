import 'dart:math';

import 'package:collection/collection.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';

import 'upload/intf_data.dart';
import 'upload/intf_tt_data.dart';
import 'upload/measure_upload_data.dart';

class ExcelFile {
  final Uint8List bytes;
  late final MeasureUploadData measureUploadData;
  late final Excel excel;
  late final Sheet sheet;

  late bool isNoLocation;
  late bool isLteOnly;

  final defaultLocation = ['129.150552778', '35.1604083333'];

  ExcelFile({
    required this.bytes,
  }) {
    _init();
  }

  Future<void> _init() async {
    excel = Excel.decodeBytes(bytes);
    sheet = excel.sheets.values.first;
    isNoLocation = sheet.maxColumns == 20 || sheet.maxColumns == 10;
    isLteOnly = sheet.maxColumns == 11 || sheet.maxColumns == 13;
    getMeasureData();
  }

  void getMeasureData() {
    // MeasureUploadData measureUploadData = MeasureUploadData();
    DateTime? dt;
    List<IntfTtData> intfTTList = [];
    List<IntfData> intf5GList = [];
    List<IntfData> intfLteList = [];

    sheet.rows.forEachIndexed((index, row) {
      if (row.first != null &&
          row.first!.value.runtimeType == DateTimeCellValue) {
        final rowData = _makeData(row, isNoLocation, isLteOnly);
        intf5GList.addAll(rowData.intf5GList);
        intfLteList.addAll(rowData.intfLteList);
        intfTTList.addAll(rowData.intfTTList);
        if (rowData.intfTTList.first.dt != null) {
          dt = rowData.intfTTList.first.dt;
        }
      }
    });
    measureUploadData = MeasureUploadData(
      dt: dt,
      intf5GList: intf5GList,
      intfLteList: intfLteList,
      intfTTList: intfTTList,
    );
  }

  MeasureUploadData getUploadData({
    required String areaCode,
    required String area,
    required String division,
    required bool isWideArea,
    int? areaIdx = 0,
  }) {
    return measureUploadData.copyWith(
      area: area,
      division: division,
      areaIdx: areaIdx,
      areaCode: areaCode,
      isWideArea: isWideArea,
    );
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
    final dateTime = (list.first as DateTimeCellValue).asDateTimeLocal();

    final regex5g = RegExp(r'(\d+)\(([^)]+)\)\(([^)]+)\)');
    for (var match in regex5g.allMatches(list[3].toString())) {
      final rp = double.parse(match.group(2)!);
      final intf5GData = IntfData(
        idx: 0,
        area: 'area',
        pci: match.group(1)!,
        dt: dateTime,
        lat: double.parse(list[2].toString()),
        lng: double.parse(list[1].toString()),
        rp: rp,
        rpmw: pow(10, rp / 10.0).toDouble(),
        spci: list[4].toString(),
        srp: (list[5] as DoubleCellValue).value,
      );
      measureUploadData.intf5GList.add(intf5GData);
    }

    final regexLte = RegExp(r"(\d+)\[(-?\d+\.\d+)\]\[(-?\d+\.\d+)\]");
    for (var match in regexLte.allMatches(list[6].toString())) {
      final rp = double.parse(match.group(2)!);
      final intfData = IntfData(
        idx: 0,
        area: 'area',
        pci: match.group(1)!,
        dt: dateTime,
        lat: double.parse(list[2].toString()),
        lng: double.parse(list[1].toString()),
        rp: rp,
        rpmw: pow(10, rp / 10.0).toDouble(),
        // $rpmw = pow( 10 , ($spci[1]/10));
        spci: list[7].toString(),
        // int
        srp: _toDouble(list[8]) ?? 0, // double
      );
      measureUploadData.intfLteList.add(intfData);
    }

    // list[16] = list[16].toString().replaceAll(RegExp(r'[^0-9]'), '');
    list[18] = list[18].toString().replaceAll(RegExp(r'[^0-9]'), '');
    final intfTtData = IntfTtData(
      idx: 0,
      area: 'area',
      lat: _toDouble(list[2]),
      lng: _toDouble(list[1]),
      cells5: list[3].toString(),
      pci5: list[4].toString(),
      rp5: _toDouble(list[5]),
      cells: list[6].toString(),
      pci: list[7].toString(),
      rp: _toDouble(list[8]),
      cqi5: _toDouble(list[9]),
      ri5: _toDouble(list[10]),
      dlmcs5: _toDouble(list[11]),
      dll5: _toDouble(list[12]),
      dlrb5: _toDouble(list[13]),
      dltp5: _toDouble(list[14]),
      ear: _toInt(list[15]),
      ca: _caToInt(list[16]),
      cqi: _toDouble(list[17]),
      ri: _toDouble(list[18]),
      dlmcs: _toDouble(list[19]),
      dlrb: _toDouble(list[20]),
      dltp: _toDouble(list[21]),
      dt: dateTime,
    );

    print('ear: ${intfTtData.ear} ::: ca: ${intfTtData.ca}');
    measureUploadData.intfTTList.add(intfTtData);

    return measureUploadData;
  }

  double? _toDouble(dynamic value) {
    switch (value.runtimeType) {
      case const (DoubleCellValue):
        return (value as DoubleCellValue).value;
      case const (String):
        return double.tryParse(value);
      case const (double):
        return value;
      default:
        return value.toString().isEmpty ? null : double.parse(value.toString());
    }
  }

  int? _toInt(dynamic value) {
    switch (value.runtimeType) {
      case const (IntCellValue):
        return (value as IntCellValue).value;
      case const (String):
        return int.tryParse(value);
      case const (int):
        return value;
      default:
        return value.toString().isEmpty ? null : int.parse(value.toString());
    }
  }

  int? _caToInt(dynamic value) {
    switch (value.toString()) {
      case 'NonCA':
        return 1;
      case 'CA2':
        return 2;
      case 'CA3':
        return 3;
      case 'CA4':
        return 4;
      default:
        return 0;
    }
  }
}
