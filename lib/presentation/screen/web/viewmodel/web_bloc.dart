import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googlemap/common/utils/extension.dart';
import 'package:googlemap/domain/bloc/bloc_bloc.dart';
import 'package:googlemap/domain/model/chart/measure_data.dart';
import 'package:googlemap/domain/model/excel_response_data.dart';
import 'package:googlemap/domain/model/map/area_data.dart';
import 'package:googlemap/presentation/screen/web/viewmodel/web_event.dart';
import 'package:googlemap/presentation/screen/web/viewmodel/web_state.dart';

import '../../../../domain/bloc/bloc_event.dart';
import '../../../../domain/model/chart/excel_data.dart';
import '../../chart/components/excel_maker.dart';

class WebBloc extends BlocBloc<BlocEvent<WebEvent>, WebState> {
  WebBloc(super.context, super.initialState) {
    init();
  }

  void init() {
    add(BlocEvent(WebEvent.onInit));
  }

  @override
  FutureOr<void> onBlocEvent(event, Emitter<WebState> emit) async {
    switch (event.type) {
      case WebEvent.onInit:
        emit(state.copyWith(isLoading: true));
        final List<ExcelResponseData> excelResponseData = [];
        for (var element in state.excelRequestData.measureDataList) {
          for (var base in element.baseList) {
            if (base.isChecked) {
              excelResponseData.add(ExcelResponseData(
                  area:
                      "${state.excelRequestData.areaData.division!.name} ${state.excelRequestData.areaData.name}",
                  year: state.excelRequestData.areaData.measuredAt!
                      .toDateString(format: "yyyy년"),
                  id: base.code,
                  rnm: base.name,
                  pci: element.pci,
                  type: state.excelRequestData.areaData.type!.name,
                  regDate: state.excelRequestData!.areaData.measuredAt!
                      .toDateString(format: 'yyyy-MM-dd'),
                  hasColor: element.nPci.isNotEmpty));
            }
          }
        }
        emit(state.copyWith(
            isLoading: false, excelResponseList: excelResponseData));
        break;
      case WebEvent.onTapDownload:
        ExcelMaker(
          areaData: state.excelRequestData.areaData,
          excelDataList: _getExcelDataList(
            state.excelRequestData.areaData,
            state.excelRequestData.measureDataList,
          ),
        ).makeExcel();
        break;
    }
  }



  List<ExcelData> _getExcelDataList(
      AreaData areaData, List<MeasureData> measureDataList) {
    List<ExcelData> excelDataList = [];

    for (var element in measureDataList) {
      for (var base in element.baseList) {
        if (base.isChecked) {
          excelDataList.add(ExcelData(
            area: "${areaData.division!.name} ${areaData.name}",
            year: areaData.measuredAt!.toDateString(format: "yyyy년"),
            id: base.code,
            rnm: base.name,
            pci: element.pci,
            type: areaData.type!.name,
            regDate: areaData.measuredAt!.toDateString(format: 'yyyy-MM-dd'),
            hasColor: element.nPci.isNotEmpty,
          ));
        }
      }
    }
    return excelDataList;
  }
}
