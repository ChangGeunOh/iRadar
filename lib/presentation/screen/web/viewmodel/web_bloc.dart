import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googlemap/common/utils/extension.dart';
import 'package:googlemap/domain/bloc/bloc_bloc.dart';
import 'package:googlemap/domain/model/excel_response_data.dart';
import 'package:googlemap/presentation/screen/web/viewmodel/web_event.dart';
import 'package:googlemap/presentation/screen/web/viewmodel/web_state.dart';

import '../../../../domain/bloc/bloc_event.dart';

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
          print('element: ${element.toJson()}');
          for (var base in element.baseList) {
            print('base: ${base.toJson()}');
            if (base.isChecked) {
              excelResponseData.add(ExcelResponseData(
                area: "${state.excelRequestData.areaData.division.name} ${state.excelRequestData.areaData.name}",
                year: state.excelRequestData.areaData.measuredAt.toDateString(format: "yyyy년"),
                id: base.code,
                rnm: base.name,
                pci: element.pci,
                type: state.excelRequestData.areaData.type.name,
                regDate: state.excelRequestData!.areaData.measuredAt.toDateString(format: 'yyyy-MM-dd'),
                hasColor: element.nPci.isNotEmpty
              ));
            }
          }
        }
        emit(state.copyWith(isLoading: false, excelResponseList: excelResponseData));
        break;
    }
  }
}
