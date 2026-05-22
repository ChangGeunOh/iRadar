import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';

import 'upload/intf_tt_data.dart';

class ExcelFile {
  final Uint8List bytes;

  List<IntfTtData> intfTTList = [];

  late bool isNoLocation;
  late bool isLteOnly;

  ExcelFile._(this.bytes);

  static Future<ExcelFile> fromBytes(Uint8List bytes) async {
    final result = await compute(_parseExcelBytes, bytes);

    return ExcelFile._(bytes)
      ..isNoLocation = result.isNoLocation
      ..isLteOnly = result.isLteOnly
      ..intfTTList = result.intfTTList;
  }
}

class _ExcelParseResult {
  final bool isNoLocation;
  final bool isLteOnly;
  final List<IntfTtData> intfTTList;

  _ExcelParseResult({
    required this.isNoLocation,
    required this.isLteOnly,
    required this.intfTTList,
  });
}

@pragma('vm:entry-point')
_ExcelParseResult _parseExcelBytes(Uint8List bytes) {
  final excel = Excel.decodeBytes(bytes);
  final sheet = excel.sheets.values.first;

  final isNoLocation = sheet.maxColumns == 20 || sheet.maxColumns == 10;
  final isLteOnly = sheet.maxColumns == 11 || sheet.maxColumns == 13;

  final defaultLocation = ['129.150552778', '35.1604083333'];

  final intfTTList = <IntfTtData>[];

  sheet.rows.forEachIndexed((index, row) {
    if (_isDateTimeParsable(row.firstOrNull?.value)) {
      final data = _getIntfTtData(
        row: row,
        isNoLocation: isNoLocation,
        isLteOnly: isLteOnly,
        defaultLocation: defaultLocation,
      );

      intfTTList.add(data);
    }
  });

  return _ExcelParseResult(
    isNoLocation: isNoLocation,
    isLteOnly: isLteOnly,
    intfTTList: intfTTList,
  );
}

bool _isDateTimeParsable(dynamic value) {
  if (value == null) return false;

  if (value is DateTimeCellValue) {
    return true;
  }

  if (value is TextCellValue) {
    return DateTime.tryParse(value.value.text ?? '') != null;
  }

  return DateTime.tryParse(value.toString()) != null;
}

double? _toDouble(dynamic value) {
  if (value == null) return null;

  switch (value) {
    case DoubleCellValue v:
      return v.value;
    case IntCellValue v:
      return v.value.toDouble();
    case TextCellValue v:
      return double.tryParse(v.value.text ?? '');
    case String v:
      return double.tryParse(v);
    case double v:
      return v;
    case int v:
      return v.toDouble();
    default:
      final text = value.toString();
      if (text.isEmpty) return null;
      return double.tryParse(text);
  }
}

int? _toInt(dynamic value) {
  if (value == null) return null;

  switch (value) {
    case IntCellValue v:
      return v.value;
    case DoubleCellValue v:
      return v.value.toInt();
    case TextCellValue v:
      return int.tryParse(v.value.text ?? '');
    case String v:
      return int.tryParse(v);
    case int v:
      return v;
    case double v:
      return v.toInt();
    default:
      final text = value.toString();
      if (text.isEmpty) return null;
      return int.tryParse(text);
  }
}

int _caToInt(dynamic value) {
  if (value == null) return 0;

  if (value is int) return value;

  final text = value.toString();

  final intValue = int.tryParse(text);
  if (intValue != null) return intValue;

  switch (text) {
    case 'NonCA':
      return 1;
    case 'CA2' || '2CA':
      return 2;
    case 'CA3' || '3CA':
      return 3;
    case 'CA4' || '4CA':
      return 4;
    default:
      return 0;
  }
}

int _toRankIndex(dynamic value) {
  final numberRegExp = RegExp(r'\d+');
  final match = numberRegExp.firstMatch(value.toString());

  if (match == null) return 0;

  return int.tryParse(match.group(0)!) ?? 0;
}

IntfTtData _getIntfTtData({
  required List<Data?> row,
  required bool isNoLocation,
  required bool isLteOnly,
  required List<String> defaultLocation,
}) {
  final list = row.map((e) => e?.value ?? '').toList();

  if (isNoLocation) {
    list.insertAll(1, defaultLocation);
  }

  if (isLteOnly) {
    list.insertAll(3, ['', '', '']);
    list.insertAll(9, ['', '', '', '', '', '']);
  }

  final firstValue = list.first;

  final dateTime = firstValue is DateTimeCellValue
      ? firstValue.asDateTimeLocal()
      : DateTime.parse(firstValue.toString());

  list[18] = list[18].toString().replaceAll(RegExp(r'[^0-9]'), '');

  return IntfTtData(
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
    ri: _toRankIndex(list[18]),
    dlmcs: _toDouble(list[19]),
    dlrb: _toDouble(list[20]),
    dltp: _toDouble(list[21]),
    dt: dateTime,
  );
}