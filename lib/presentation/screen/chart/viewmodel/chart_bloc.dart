import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googlemap/domain/bloc/bloc_bloc.dart';
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
        final chartTableData = await repository.loadChartTableData(event.extra);
        if (chartTableData != null) {
          emit(state.copyWith(chartTableData: chartTableData));
        }
        break;
      case ChartEvent.onChatData:
        break;
    }
  }
}
