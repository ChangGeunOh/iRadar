import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:googlemap/common/utils/extension.dart';
import 'package:googlemap/domain/bloc/bloc_bloc.dart';
import 'package:googlemap/domain/bloc/bloc_event.dart';
import 'package:googlemap/domain/model/chart/measure_data.dart';
import 'package:googlemap/presentation/screen/npci/viewmodel/npci_event.dart';

import '../../../../domain/model/chart/excel_data.dart';
import '../../../../domain/model/excel_request_data.dart';
import '../../chart/components/excel_maker.dart';
import '../../web/web_screen.dart';
import 'npci_state.dart';

class NpciBloc extends BlocBloc<BlocEvent<NpciEvent>, NpciState> {
  NpciBloc(super.context, super.initialState) {
    add(BlocEvent(NpciEvent.init));
  }

  @override
  FutureOr<void> onBlocEvent(
    BlocEvent<NpciEvent> event,
    Emitter<NpciState> emit,
  ) async {
    switch (event.type) {
      case NpciEvent.init:
        final response = await repository.loadNpciList(
          type: state.areaData.type!.name,
          idx: state.areaData.idx,
          spci: state.pci,
        );
        final list = response.data as List<MeasureData>;
        var measureDataList = list.map((e) {
          final baseList = e.baseList.map((base) {
            return base.copyWith(isChecked: !e.hasColor);
          }).toList();
          return e.copyWith(baseList: baseList);
        }).toList();

        final measureList = measureDataList.map((e) {
          final measureData = state.measureDataList.firstWhere(
            (element) => element.pci == e.pci,
          );
          return e.copyWith(
            mw: measureData.mw,
            sTime: measureData.sTime,
            rp: measureData.rp,
            freq: measureData.freq,
            ca: measureData.ca,
            cqi: measureData.cqi,
            ri: measureData.ri,
            dlMcs: measureData.dlMcs,
            dlLayer: measureData.dlLayer,
            dlRb: measureData.dlRb,
            dlTp: measureData.dlTp,
          );
        }).toList();

        emit(state.copyWith(
          measureDataList: measureList,
          message: response.meta.message,
        ));
        break;
      case NpciEvent.onTapNId:
        break;
      case NpciEvent.onTapToggle:
        break;
      case NpciEvent.onTapExcel:
        ExcelMaker(
          areaData: state.areaData,
          excelDataList: _getExcelDataList(),
        ).makeExcel();
        break;
      case NpciEvent.onMessage:
        emit(state.copyWith(message: event.extra));
        break;
    }
  }

  List<ExcelData> _getExcelDataList() {
    List<ExcelData> excelDataList = [];
    for (var element in state.measureDataList) {
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
}
