import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:googlemap/domain/bloc/bloc_bloc.dart';
import 'package:googlemap/domain/model/chart_table_data.dart';
import 'package:googlemap/domain/model/excel_request_data.dart';
import 'package:googlemap/domain/model/place_table_data.dart';
import 'package:googlemap/domain/model/table_data.dart';
import 'package:googlemap/presentation/screen/chart/components/excel_maker.dart';
import 'package:googlemap/presentation/screen/chart/viewmodel/chart_event.dart';

import '../../../../domain/bloc/bloc_event.dart';
import '../../npci/npci_screen.dart';
import '../../web/web_screen.dart';
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
        final placeTableData = PlaceTableData(
          placeData: state.placeData!,
          tableData: event.extra,
        );
        context.pushNamed(
          NpciScreen.routeName,
          extra: placeTableData,
        );
        break;
      case ChartEvent.onTapWeb:
        final excelRequestData = ExcelRequestData(
          placeData: state.placeData!,
          tableList: state.chartTableData!.tableList,
        );
        context.pushNamed(
          WebScreen.routeName,
          extra: excelRequestData,
        );
        break;
      case ChartEvent.onTapExcel:
        final excelRequestData = ExcelRequestData(
          placeData: state.placeData!,
          tableList: state.chartTableData!.tableList,
        );
        final excelResponseData =
            await repository.loadExcelResponseData(excelRequestData);
        if (excelResponseData != null) {
          ExcelMaker(
            placeData: state.placeData!,
            excelResponseList: excelResponseData,
          ).makeExcel();
        }
        break;
    }
  }
}
