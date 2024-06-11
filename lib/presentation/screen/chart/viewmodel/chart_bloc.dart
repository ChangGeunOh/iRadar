import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:googlemap/domain/bloc/bloc_bloc.dart';
import 'package:googlemap/domain/model/excel_request_data.dart';
import 'package:googlemap/presentation/screen/chart/viewmodel/chart_event.dart';

import '../../../../domain/bloc/bloc_event.dart';
import '../../../../domain/model/map/area_data.dart';
import '../../web/web_screen.dart';
import 'chart_state.dart';

class ChartBloc extends BlocBloc<BlocEvent<ChartEvent>, ChartState> {
  ChartBloc(super.context, super.initialState) {
    init();
  }

  void init() {
    add(BlocEvent(ChartEvent.init));
  }

  @override
  FutureOr<void> onBlocEvent(
    BlocEvent<ChartEvent> event,
    Emitter<ChartState> emit,
  ) async {
    switch (event.type) {
      case ChartEvent.init:
        await _loadMeasureDataList(
          state.areaData,
          emit,
        );
        break;
      // case ChartEvent.onPlaceData:
      //   emit(state.copyWith(placeData: event.extra, isLoading: true));
      //   final response = await repository.loadMeasureList(state.placeData!);
      //   emit(state.copyWith(
      //     isLoading: false,
      //     measureDataList: response.data,
      //     message: response.meta.message,
      //   ));
      //   break;
      case ChartEvent.onTapNId:
        // var tableData = event.extra as TableData;
        // tableData.toggle();
        // final index = state.chartTableData!.tableList
        //     .indexWhere((element) => element.pci == tableData.pci);
        // state.chartTableData!.tableList[index] = tableData;
        // emit(
        //   state.copyWith(
        //     chartTableData: state.chartTableData,
        //     isCheck: false,
        //   ),
        // );
        break;
      case ChartEvent.onTapToggle:
        // print("ChartEvent.onTapToogle");
        // final isCheck = !state.isCheck;
        // final tableList = state.chartTableData!.tableList.map(
        //   (e) {
        //     e.isCheck(isCheck);
        //     return e;
        //   },
        // ).toList();
        // emit(
        //   state.copyWith(
        //     chartTableData: ChartTableData(
        //       chartList: state.chartTableData!.chartList,
        //       tableList: tableList,
        //     ),
        //     isCheck: isCheck,
        //   ),
        // );
        break;
      case ChartEvent.onTapPci:
        print("ChartEvent.onTapPci");
        break;
      case ChartEvent.onTapNPci:
        // final placeTableData = PlaceTableData(
        //   placeData: state.placeData!,
        //   tableData: event.extra,
        // );
        // context.pushNamed(
        //   NpciScreen.routeName,
        //   extra: placeTableData,
        // );
        break;
      case ChartEvent.onTapWeb:
        final excelRequestData = ExcelRequestData(
          areaData: state.areaData,
          measureDataList: state.measureDataList,
        );
        context.pushNamed(
          WebScreen.routeName,
          extra: excelRequestData,
        );
        break;
      case ChartEvent.onTapExcel:
        // final excelRequestData = ExcelRequestData(
        //   placeData: state.placeData!,
        //   tableList: state.chartTableData!.tableList,
        // );
        // final excelResponseData =
        //     await repository.loadExcelResponseData(excelRequestData);
        // if (excelResponseData != null) {
        //   ExcelMaker(
        //     placeData: state.placeData!,
        //     excelResponseList: excelResponseData,
        //   ).makeExcel();
        // }
        break;
      case ChartEvent.onChangedAreaData:
        final areaData = event.extra as AreaData;
        await _loadMeasureDataList(areaData, emit);
        break;
      // case ChartEvent.onChangedAreaDataSet:
      //   final areaDataSet = event.extra as Set<AreaData>;
      //   emit(state.copyWith(isLoading: true, areaDataSet: areaDataSet));
      //
      //   List<MeasureData> measureDataList = [];
      //   String message = '';
      //   for (final areaData in areaDataSet) {
      //     final response = await repository.loadMeasureList(areaData);
      //     measureDataList.addAll(response.data);
      //     if (response.meta.message.isNotEmpty) {
      //       message = response.meta.message;
      //     }
      //   }
      //   emit(state.copyWith(
      //     isLoading: false,
      //     measureDataList: measureDataList,
      //     message: message,
      //   ));

      // emit(state.copyWith(areaDataSet: areaDataSet));
      case ChartEvent.onChangedMeasureList:
        print("ChartEvent.onChangedMeasureList");
        emit(state.copyWith(measureDataList: event.extra));
        break;
    }
  }

  Future<void> _loadMeasureDataList(
      AreaData areaData,
    Emitter<ChartState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, areaData: areaData));
    final response = await repository.loadMeasureList(areaData);
    emit(state.copyWith(
        isLoading: false,
        measureDataList: response.data,
        message: response.meta.message));
    emit(state.copyWith(areaData: areaData));
  }
}
