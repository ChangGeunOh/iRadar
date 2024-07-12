import 'package:collection/collection.dart';
import 'package:excel/excel.dart';
import 'package:googlemap/domain/model/chart/excel_data.dart';
import 'package:googlemap/domain/model/map/area_data.dart';
import 'package:googlemap/domain/model/place_data.dart';

import '../../../../common/const/constants.dart';
import '../../../../domain/model/excel_response_data.dart';

class ExcelMaker {
  final AreaData areaData;
  final List<ExcelData> excelDataList;

  ExcelMaker({
    required this.areaData,
    required this.excelDataList,
  });

  final excelCellWidths = [
    8.14,
    6.1,
    6.1,
    40.00,
    3.82,
    3.82,
    12.29,
    10.71,
    15.43,
    35.00,
    10.57,
    7.43,
    11.14,
    11.14,
    11.14,
    5.71,
    15.15,
    16.71,
  ];

  CellStyle _cellStyle(ExcelColor background) => CellStyle(
        horizontalAlign: HorizontalAlign.Center,
        bold: true,
        backgroundColorHex: background,
        leftBorder: Border(borderStyle: BorderStyle.Thin),
        rightBorder: Border(borderStyle: BorderStyle.Thin),
        topBorder: Border(borderStyle: BorderStyle.Thin),
        bottomBorder: Border(borderStyle: BorderStyle.Thin),
      );

  void makeExcel({String? fileName}) {
    var saveFileName = fileName ?? areaData.name;
    var excel = Excel.createExcel();
    Sheet sheet = excel['Sheet1'];
    _makeRowTitle(sheet);
    _makeRowData(sheet);
    excel.save(fileName: '$saveFileName.xlsx');
  }

  void _makeRowTitle(
    Sheet sheet,
  ) {
    kWebHeaders.forEachIndexed((index, element) {
      sheet.merge(
        CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0),
        CellIndex.indexByColumnRow(columnIndex: 17, rowIndex: 0),
      );
      sheet.cell(
        CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0),
      )
        ..value = TextCellValue(areaData.name)
        ..cellStyle = CellStyle(
          bold: true,
          underline: Underline.Single,
          horizontalAlign: HorizontalAlign.Center,
        );

      var cell = sheet.cell(
        CellIndex.indexByColumnRow(columnIndex: index, rowIndex: 1),
      );
      sheet.setColumnWidth(index, excelCellWidths[index]); // setColWidth(index, excelCellWidths[index]);
      cell.value = TextCellValue(element.toString()); // element.toString(
      cell.cellStyle = _cellStyle(ExcelColor.fromHexString('#D4D4D4'));
    });
  }

  void _makeRowData(Sheet sheet) {
    excelDataList.forEachIndexed((row, e) {
      final background = e.hasColor ? ExcelColor.fromHexString('#fffd54'): ExcelColor.none;
      final cellValues = [
        e.division,
        e.sido,
        e.sigungu,
        e.area,
        e.team,
        e.jo,
        e.year,
        e.type,
        e.id,
        e.rnm,
        e.memo,
        e.atten,
        e.cellLock,
        e.ruLock,
        e.relayLock,
        e.pci,
        e.scenario,
        e.regDate,
      ];

      cellValues.forEachIndexed((column, value) {
        _makeCell(
          sheet: sheet,
          row: row + 2,
          column: column,
          value: value,
          background: background,
        );
      });
    });
  }

  void _makeCell({
    required Sheet sheet,
    required int row,
    required int column,
    required String value,
    ExcelColor background = ExcelColor.none,
  }) {
    sheet.cell(
      CellIndex.indexByColumnRow(
        rowIndex: row,
        columnIndex: column,
      ),
    )
      ..value = TextCellValue(value)
      ..cellStyle = _cellStyle(background);
  }
}
