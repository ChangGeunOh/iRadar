import 'package:collection/collection.dart';
import 'package:excel/excel.dart';
import 'package:googlemap/domain/model/place_data.dart';

import '../../../../common/const/constants.dart';
import '../../../../domain/model/excel_response_data.dart';

class ExcelMaker {
  final PlaceData placeData;
  final List<ExcelResponseData> excelResponseList;

  ExcelMaker({
    required this.placeData,
    required this.excelResponseList,
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

  CellStyle _cellStyle(String background) => CellStyle(
        horizontalAlign: HorizontalAlign.Center,
        bold: true,
        backgroundColorHex: background,
        leftBorder: Border(borderStyle: BorderStyle.Thin),
        rightBorder: Border(borderStyle: BorderStyle.Thin),
        topBorder: Border(borderStyle: BorderStyle.Thin),
        bottomBorder: Border(borderStyle: BorderStyle.Thin),
      );

  void makeExcel({String? fileName}) {
    var saveFileName = fileName ?? placeData.name;
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
        ..value = placeData.link
        ..cellStyle = CellStyle(
          bold: true,
          underline: Underline.Single,
          horizontalAlign: HorizontalAlign.Center,
        );

      var cell = sheet.cell(
        CellIndex.indexByColumnRow(columnIndex: index, rowIndex: 1),
      );
      sheet.setColWidth(index, excelCellWidths[index]);
      cell.value = element;
      cell.cellStyle = _cellStyle('#D4D4D4');
    });
  }

  void _makeRowData(Sheet sheet) {
    excelResponseList.forEachIndexed((row, e) {
      final background = e.hasColor ? '#fffd54' : 'none';
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
        e.regDate.split(' ').first,
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
    String background = 'none',
  }) {
    sheet.cell(
      CellIndex.indexByColumnRow(
        rowIndex: row,
        columnIndex: column,
      ),
    )
      ..value = value
      ..cellStyle = _cellStyle(background);
  }
}
