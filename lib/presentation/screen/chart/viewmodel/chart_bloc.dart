import 'dart:async';

import 'package:excel/excel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googlemap/domain/bloc/bloc_bloc.dart';
import 'package:googlemap/domain/model/chart_table_data.dart';
import 'package:googlemap/domain/model/table_data.dart';
import 'package:googlemap/presentation/screen/chart/viewmodel/chart_event.dart';

import '../../../../domain/bloc/bloc_event.dart';
import 'chart_state.dart';

class ChartBloc extends BlocBloc<BlocEvent<ChartEvent>, ChartState> {
  ChartBloc(super.context, super.initialState);

  @override
  FutureOr<void> onBlocEvent(
    BlocEvent<ChartEvent> event,
    Emitter<ChartState> emit,
  ) async {
    switch (event.type) {
      case ChartEvent.init:
        break;
      case ChartEvent.onPlaceData:
        emit(state.copyWith(placeData: event.extra));
        final chartTableData = await repository.loadChartTableData(event.extra);
        if (chartTableData != null) {
          emit(state.copyWith(chartTableData: chartTableData));
        }
        break;
      case ChartEvent.onChatData:
        break;
      case ChartEvent.onTapNId:
        print("onTapNid>");
        var tableData = event.extra as TableData;
        tableData.toggle();
        final index = state.chartTableData!.tableList
            .indexWhere((element) => element.pci == tableData.pci);
        state.chartTableData!.tableList[index] = tableData;
        emit(
          state.copyWith(
            chartTableData: state.chartTableData,
            isCheck: false,
          ),
        );
        break;
      case ChartEvent.onTapToggle:
        print("ChartEvent.onTapToogle");
        final isCheck = !state.isCheck;
        final tableList = state.chartTableData!.tableList.map(
          (e) {
            e.isCheck(isCheck);
            return e;
          },
        ).toList();
        emit(
          state.copyWith(
            chartTableData: ChartTableData(
              chartList: state.chartTableData!.chartList,
              tableList: tableList,
            ),
            isCheck: isCheck,
          ),
        );
        break;
      case ChartEvent.onTapPci:
        print("ChartEvent.onTapPci");
        break;
      case ChartEvent.onTapNPci:
        print("ChartEvent.onTapNPci");
        break;
      case ChartEvent.onTapWeb:
        print('ChartEvent.onTapWeb');
        break;
      case ChartEvent.onTapExcel:
        print('ChartEvent.onTapExcel');
        var excel = Excel.createExcel();
        Sheet sheetObject = excel['Sheet1'];
        CellStyle cellStyle = CellStyle(backgroundColorHex: '#1AFF1A', fontFamily : getFontFamily(FontFamily.Calibri));
        cellStyle.underline = Underline.Single; // or Underline.Double

        var cell = sheetObject.cell(CellIndex.indexByString('A1'));
        cell.value = 8; // dynamic values support provided;
        cell.cellStyle = cellStyle;
        cell = sheetObject.cell(CellIndex.indexByString('A2'));
        cell.value = "THIS IS EXCEL TEST...";
        excel.save(fileName: 'EXCEl_TEST.xlsx');

        break;
    }
  }
}
