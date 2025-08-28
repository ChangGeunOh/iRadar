import 'package:excel/excel.dart';
import 'package:googlemap/common/utils/extension.dart';
import 'package:googlemap/domain/model/chart/measure_data.dart';
import 'package:googlemap/domain/model/chart/worst_chart_data.dart';
import 'package:googlemap/domain/model/enum/location_type.dart';

import '../../domain/model/enum/wireless_type.dart';
import '../const/constants.dart';

class WorstExcelMaker {
  final WirelessType type;
  final LocationType division;
  final List<WorstChartData> worstChartDataList;

  WorstExcelMaker({
    required this.type,
    required this.division,
    required this.worstChartDataList,
  });

  Excel makeChartExcel() {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];
    sheetObject.setColumnAutoFit(1);
    sheetObject.merge(
      CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0),
      CellIndex.indexByColumnRow(
          columnIndex: type == WirelessType.wLte ? 17 : 16, rowIndex: 0),
    );

    sheetObject.setRowHeight(0, 24);

    sheetObject.cell(CellIndex.indexByColumnRow(rowIndex: 0, columnIndex: 0))
      ..value = TextCellValue("${division.name} Worst Cell 대상 (최적화 우선 순위)")
      ..cellStyle = CellStyle(
        fontSize: 20,
        bold: true,
        underline: Underline.Single,
        horizontalAlign: HorizontalAlign.Center,
        verticalAlign: VerticalAlign.Center,
      );

    List.generate(type == WirelessType.wLte ? 17 : 16, (index) {
      sheetObject.setColumnWidth(index, 15);
    });

    var headerTitle =
        List.from(type == WirelessType.wLte ? headerLteTitle : header5gTitle);
    headerTitle.insert(0, '측정날짜');
    headerTitle.insert(1, '측정장소');

    headerTitle.removeLast();
    headerTitle.add('거리\n(km)');
    headerTitle.add('국소명');
    headerTitle.add('장비ID');

    sheetObject.setColumnAutoFit(3);
    sheetObject.setColumnWidth(0, 20);
    sheetObject.setColumnWidth(1, 30);
    sheetObject.setColumnWidth(3, 70);
    sheetObject.setColumnWidth(headerTitle.length - 2, 45);
    sheetObject.setColumnWidth(headerTitle.length - 1, 20);

    for (var i = 0; i < headerTitle.length; i++) {
      sheetObject.cell(CellIndex.indexByColumnRow(rowIndex: 1, columnIndex: i))
        ..value = TextCellValue(headerTitle[i])
        ..cellStyle =
            _cellStyle(background: ExcelColor.fromHexString('#D4D4D4'));
    }

    var rowIndex = 2;
    for (var row in worstChartDataList) {
      sheetObject
          .cell(CellIndex.indexByColumnRow(rowIndex: rowIndex, columnIndex: 0))
        ..value = TextCellValue(row.measuredAt.toDateString())
        ..cellStyle = _cellStyle();

      sheetObject
          .cell(CellIndex.indexByColumnRow(rowIndex: rowIndex, columnIndex: 1))
        ..value = TextCellValue(row.name)
        ..cellStyle = _cellStyle();
      var startRowIndex = rowIndex;
      for (MeasureData data in row.worstList!) {
        final values = data.getRowValues(type);
        for (var i = 0; i < values.length; i++) {
          sheetObject.cell(CellIndex.indexByColumnRow(
              rowIndex: rowIndex, columnIndex: i + 2))
            ..value = TextCellValue(values[i])
            ..cellStyle = _cellStyle(
              background: data.hasColor
                  ? ExcelColor.fromHexString('#fffd54')
                  : ExcelColor.none,
            );
        }
        List.generate(2, (column) {
          sheetObject.cell(
            CellIndex.indexByColumnRow(
              rowIndex: rowIndex,
              columnIndex: column,
            ),
          ).cellStyle = _cellStyle();

        });
        rowIndex++;
      }

      List.generate(2, (index) {
        sheetObject.merge(
          CellIndex.indexByColumnRow(
            columnIndex: index,
            rowIndex: startRowIndex,
          ),
          CellIndex.indexByColumnRow(
            columnIndex: index,
            rowIndex: rowIndex - 1,
          ),
        );
      });
    }
    return excel;
  }

  CellStyle _cellStyle({
    ExcelColor background = ExcelColor.none,
  }) =>
      CellStyle(
        horizontalAlign: HorizontalAlign.Center,
        verticalAlign: VerticalAlign.Center,
        bold: true,
        textWrapping: TextWrapping.WrapText,
        backgroundColorHex: background,
        leftBorder: Border(borderStyle: BorderStyle.Thin),
        rightBorder: Border(borderStyle: BorderStyle.Thin),
        topBorder: Border(borderStyle: BorderStyle.Thin),
        bottomBorder: Border(borderStyle: BorderStyle.Thin),
      );
}
