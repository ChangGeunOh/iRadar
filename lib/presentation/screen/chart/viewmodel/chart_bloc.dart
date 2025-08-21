import 'dart:async';

import 'package:collection/collection.dart';
import 'package:excel/excel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:googlemap/common/utils/extension.dart';
import 'package:googlemap/domain/bloc/bloc_bloc.dart';
import 'package:googlemap/domain/model/chart/excel_data.dart';
import 'package:googlemap/domain/model/chart/measure_data.dart';
import 'package:googlemap/domain/model/excel_request_data.dart';
import 'package:googlemap/domain/model/excel_response_data.dart';
import 'package:googlemap/presentation/screen/chart/viewmodel/chart_event.dart';
import 'package:googlemap/presentation/screen/npci/npci_screen.dart';

import '../../../../common/const/constants.dart';
import '../../../../domain/bloc/bloc_event.dart';
import '../../../../domain/model/enum/wireless_type.dart';
import '../../../../domain/model/map/area_data.dart';
import '../../web/web_screen.dart';
import '../../../../common/utils/excel_maker.dart';
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
        if (!state.areaData.isChartCached) {
          state.onChangeAreaData?.call(state.areaData.copyWith(
            isChartCached: true,
          ));
        }
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
        context.push(
          NpciScreen.routeName,
          extra: {
            'areaData': state.areaData,
            'pci': event.extra as String,
          },
        );
        break;
      case ChartEvent.onTapExcel:
        ExcelMaker(
          areaData: state.areaData,
          excelDataList: _getExcelDataList(),
        ).makeExcel();
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
        emit(state.copyWith(filteredMeasureDataList: event.extra));
        break;
      case ChartEvent.onTapExcelDownload:
        makeChartExcel();
        break;
      case ChartEvent.onTapDeduplication:
        emit(state.copyWith(
          isDeduplication: event.extra as bool? ?? !state.isDeduplication,
        ));
        await _loadMeasureDataList(state.areaData, emit);
        break;
    }
  }

  Future<void> _loadMeasureDataList(
    AreaData areaData,
    Emitter<ChartState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, areaData: areaData));
    try {
      final response = await repository.loadMeasureList(
        areaData,
        state.isDeduplication,
      );
      final List<MeasureData> measureDataList = response.data;
      final sortedMeasureDataList = measureDataList
        ..sort((a, b) => b.inIndex.compareTo(a.inIndex));
      emit(state.copyWith(
        isLoading: false,
        measureDataList: sortedMeasureDataList,
        filteredMeasureDataList: sortedMeasureDataList,
        message: response.meta.message,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, message: e.toString()));
    }
  }

  List<ExcelData> _getExcelDataList() {
    List<ExcelData> excelDataList = [];
    for (var element in state.filteredMeasureDataList) {
      for (var base in element.baseList) {
        if (base.isChecked) {
          excelDataList.add(ExcelData(
            area: "${state.areaData.division!.name} ${state.areaData.name}",
            year: state.areaData.measuredAt!.toDateString(format: "yyyy년"),
            id: base.code,
            rnm: base.name,
            pci: element.pci,
            type: state.areaData.type!.name,
            regDate:
                state.areaData.measuredAt!.toDateString(format: 'yyyy-MM-dd'),
            hasColor: element.nPci.isNotEmpty,
          ));
        }
      }
    }
    return excelDataList;
  }

  Future<void> makeChartExcel() async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Sheet1'];
    sheetObject.setColumnAutoFit(1);
    sheetObject.merge(
      CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0),
      CellIndex.indexByColumnRow(
          columnIndex: state.filteredMeasureDataList.first
                  .getRowValues(state.areaData.type!)
                  .length -
              1,
          rowIndex: 0),
    );

    sheetObject.setRowHeight(0, 24);

    sheetObject.cell(CellIndex.indexByColumnRow(rowIndex: 0, columnIndex: 0))
      ..value =
          TextCellValue("${state.areaData.name} ${state.areaData.type?.name}")
      ..cellStyle = CellStyle(
        bold: true,
        underline: Underline.Single,
        horizontalAlign: HorizontalAlign.Center,
        verticalAlign: VerticalAlign.Center,
      );

    sheetObject.setColumnWidth(
      state.filteredMeasureDataList.first
              .getRowValues(state.areaData.type!)
              .length -
          2,
      50,
    );
    sheetObject.cell(CellIndex.indexByColumnRow(rowIndex: 0, columnIndex: 0))
      ..value = TextCellValue(state.areaData.name)
      ..cellStyle = CellStyle(
        bold: true,
        underline: Underline.Single,
        horizontalAlign: HorizontalAlign.Center,
      );

    var headerTitle = List.from(state.areaData.type == WirelessType.wLte
        ? headerLteTitle
        : header5gTitle);

    headerTitle.removeLast();
    headerTitle.add('거리\n(km)');
    headerTitle.add('국소명');
    headerTitle.add('장비ID');

    for (var i = 0; i < headerTitle.length; i++) {
      sheetObject.cell(CellIndex.indexByColumnRow(rowIndex: 1, columnIndex: i))
        ..value = TextCellValue(headerTitle[i])
        ..cellStyle = _cellStyle(ExcelColor.fromHexString('#D4D4D4'));
    }

    var index = 1;
    for (var measureData in state.filteredMeasureDataList) {
      measureData.getRowValues(state.areaData.type!).forEachIndexed((i, value) {
        sheetObject.cell(
            CellIndex.indexByColumnRow(rowIndex: index + 1, columnIndex: i))
          ..value = TextCellValue(value)
          ..cellStyle = _cellStyle(measureData.hasColor
              ? ExcelColor.fromHexString('#fffd54')
              : ExcelColor.none);
      });
      index++;
    }
    excel.save(
        fileName: '${state.areaData.name}_${state.areaData.type?.name}.xlsx');
  }

  CellStyle _cellStyle(ExcelColor background) => CellStyle(
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

  // e.hasColor ? ExcelColor.fromHexString('#fffd54'): ExcelColor.none
}
