import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/utils/utils.dart';
import '../../../../domain/bloc/bloc_bloc.dart';
import '../../../../domain/bloc/bloc_event.dart';
import 'compare_event.dart';
import 'compare_state.dart';

class CompareBloc extends BlocBloc<BlocEvent<CompareEvent>, CompareState> {
  CompareBloc(super.context, super.initialState) {
    init();
  }

  void init() {
    add(BlocEvent(CompareEvent.init));
  }

  @override
  FutureOr<void> onBlocEvent(
    BlocEvent<CompareEvent> event,
    Emitter<CompareState> emit,
  ) async {
    switch (event.type) {
      case CompareEvent.init:
        emit(state.copyWith(
          isLeftLoading: true,
          isRightLoading: true,
        ));
        final rsrpMarkerSet = await Utils.makeMeasureMarkerByAreaSet(
          areaDataSet: state.areaDataSet,
          type: state.type,
          isSpeed: false,
          isLabel: false,
          repository: repository,
        );
        emit(
          state.copyWith(
            leftMarkers: rsrpMarkerSet,
            isLeftLoading: false,
          ),
        );
        final speedMarkerSet = await Utils.makeMeasureMarkerByAreaSet(
          areaDataSet: state.areaDataSet,
          type: state.type,
          isSpeed: true,
          isLabel: false,
          repository: repository,
        );
        emit(
          state.copyWith(
            rightMarkers: speedMarkerSet,
            isRightLoading: false,
          ),
        );
        break;
    }
  }
}
