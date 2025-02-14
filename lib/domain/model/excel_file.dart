import 'dart:math';

import 'package:collection/collection.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';

import 'upload/intf_data.dart';
import 'upload/intf_tt_data.dart';
import 'upload/measure_upload_data.dart';

class ExcelFile {
  final Uint8List bytes;
  late MeasureUploadData measureUploadData = MeasureUploadData();
  late final Excel excel;
  late final Sheet sheet;

  late bool isNoLocation;
  late bool isLteOnly;

  final defaultLocation = ['129.150552778', '35.1604083333'];

  ExcelFile._(this.bytes);

  static Future<ExcelFile> fromBytes(Uint8List bytes) async {
    return ExcelFile._(bytes).._init();
  }

  Future<void> _init() async {
    excel = Excel.decodeBytes(bytes);
    sheet = excel.sheets.values.first;
    isNoLocation = sheet.maxColumns == 20 || sheet.maxColumns == 10;
    isLteOnly = sheet.maxColumns == 11 || sheet.maxColumns == 13;
    print('sheet.maxColumns: ${sheet.maxColumns}');
    print('isNoLocation: $isNoLocation :: isLteOnly: $isLteOnly');
    getMeasureData();
  }

  void getMeasureData() {
    // MeasureUploadData measureUploadData = MeasureUploadData();
    DateTime? dt;
    List<IntfTtData> intfTTList = [];
    List<IntfData> intf5GList = [];
    List<IntfData> intfLteList = [];

    sheet.rows.forEachIndexed((index, row) {
      if (_isDateTimeParsable(row.first?.value)) {
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

    print('intfTTList.length: ${measureUploadData.intfTTList.length}, intf5GList.length: ${measureUploadData.intf5GList.length}, intfLteList.length: ${measureUploadData.intfLteList.length}');
  }

  bool _isDateTimeParsable(dynamic value) {
    if (value == null) return false;

    if (value is DateTimeCellValue) {
      return true; // 이미 DateTimeCellValue 타입인 경우
    }

    if (value is TextCellValue) {
      return DateTime.tryParse(value.toString()) != null; // 파싱 가능 여부 확인
    }

    return false; // 다른 모든 경우 false
  }

  MeasureUploadData getUploadData({
    required String area,
    required String division,
    required bool isWideArea,
    int? areaIdx = -1,
  }) {
    return measureUploadData.copyWith(
      area: area,
      division: division,
      areaIdx: areaIdx,
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

    final dateTime = list.first.runtimeType is DateTimeCellValue
        ? (list.first as DateTimeCellValue).asDateTimeLocal()
        : DateTime.parse(list.first.toString());

    final regex5g = RegExp(r'(\d+)(?:\(([^)]+)\))?(?:\(([^)]+)\))?');
    for (var match in regex5g.allMatches(list[3].toString())) {

      try {
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
          srp: double.parse(list[5].toString()),
          // srp: (list[5] as DoubleCellValue).value,
        );
        measureUploadData.intf5GList.add(intf5GData);
      } catch (e) {
        print('Error: $e');
      }
    }

    // final regexLte = RegExp(r'(\d+)\(([^)]+)\)\(([^)]+)\)');
    final regexLte = RegExp(r'(\d+)[\[\(]([^)\]]+)[\)\]][\[\(]([^)\]]+)[\)\]]');

    for (var match in regexLte.allMatches(list[6].toString())) {
      print('match: ${match.group(1)} ::: ${match.group(2)}');
      final rp = double.parse(match.group(2)!);
      try {
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
      } catch (e) {
        print('Error: $e ::: $rp');
      }
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
      // CA Type
      cqi: _toDouble(list[17]),
      ri: _toRankIndex(list[18]),
      // RI
      dlmcs: _toDouble(list[19]),
      dlrb: _toDouble(list[20]),
      dltp: _toDouble(list[21]),
      dt: dateTime,
    );

    // print('ear: ${intfTtData.ear} ::: ca: ${intfTtData.ca}');
    measureUploadData.intfTTList.add(intfTtData);

    return measureUploadData;
  }

  double? _toDouble(dynamic value) {
    switch (value.runtimeType) {
      case const (DoubleCellValue):
        return (value as DoubleCellValue).value;
      case const (TextCellValue):
        final text = (value).value.text;
        return double.tryParse(text ?? '');
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
      case const (TextCellValue):
        final text = (value).value.text;
        return int.tryParse(text ?? '');
      case const (String):
        return int.tryParse(value);
      case const (int):
        return value;
      default:
        return value.toString().isEmpty ? null : int.parse(value.toString());
    }
  }

  int? _caToInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is String) {
      final intValue = int.tryParse(value);
      if (intValue != null) {
        return intValue;
      }
    }
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

  int? _toRankIndex(dynamic value) {
    final RegExp numberRegExp = RegExp(r'\d+');
    final Match? match = numberRegExp.firstMatch(value..toString());

    if (match != null) {
      return int.tryParse(match.group(0)!) ?? 0;
    } else {
      return 0; // 숫자를 찾지 못하면 원래 문자열을 반환
    }
  }
}
