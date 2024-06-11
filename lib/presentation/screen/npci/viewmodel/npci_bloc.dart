import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:googlemap/domain/bloc/bloc_bloc.dart';
import 'package:googlemap/domain/bloc/bloc_event.dart';
import 'package:googlemap/domain/model/place_table_data.dart';
import 'package:googlemap/presentation/screen/npci/viewmodel/npci_event.dart';

import '../../../../domain/model/excel_request_data.dart';
import '../../../../domain/model/table_data.dart';
import '../../chart/components/excel_maker.dart';
import '../../web/web_screen.dart';
import 'npci_state.dart';

class NpciBloc extends BlocBloc<BlocEvent<NpciEvent>, NpciState> {
  NpciBloc(super.context, super.initialState);

  @override
  FutureOr<void> onBlocEvent(
      BlocEvent<NpciEvent> event, Emitter<NpciState> emit) async {
    switch (event.type) {
      case NpciEvent.init:
        final PlaceTableData placeTableData = event.extra;
        final tableList = await repository.loadNpciTableList(
          placeTableData.placeData.link,
          placeTableData.tableData.pci,
        );
        emit(state.copyWith(
          tableList: tableList,
          placeData: placeTableData.placeData,
        ));
        break;
      case NpciEvent.onTapNId:
        var tableData = event.extra as TableData;
        tableData.toggle();
        final index = state.tableList!
            .indexWhere((element) => element.pci == tableData.pci);
        state.tableList![index] = tableData;
        emit(
          state.copyWith(
            tableList: state.tableList,
            isCheck: false,
          ),
        );
        break;
      case NpciEvent.onTapToggle:
        final isCheck = !state.isCheck;
        final tableList = state.tableList!.map(
          (e) {
            e.isCheck(isCheck);
            return e;
          },
        ).toList();
        emit(
          state.copyWith(
            tableList: tableList,
            isCheck: isCheck,
          ),
        );
        break;
      case NpciEvent.onTapExcel:
        // final excelRequestData = ExcelRequestData(
        //   areaData: state.placeData!,
        //   tableList: state.tableList!,
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
      case NpciEvent.onTapWeb:
        // final excelRequestData = ExcelRequestData(
        //   placeData: state.placeData!,
        //   tableList: state.tableList!,
        // );
        // context.pushNamed(
        //   WebScreen.routeName,
        //   extra: excelRequestData,
        // );
        break;
    }
  }
}
