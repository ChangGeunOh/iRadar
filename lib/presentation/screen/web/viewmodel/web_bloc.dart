import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googlemap/domain/bloc/bloc_bloc.dart';
import 'package:googlemap/presentation/screen/web/viewmodel/web_event.dart';
import 'package:googlemap/presentation/screen/web/viewmodel/web_state.dart';

import '../../../../domain/bloc/bloc_event.dart';

class WebBloc extends BlocBloc<BlocEvent<WebEvent>, WebState> {
  WebBloc(super.context, super.initialState);

  @override
  FutureOr<void> onBlocEvent(event, Emitter<WebState> emit) async {
    switch (event.type) {
      case WebEvent.onInit:
        emit(state.copyWith(isLoading: true));
        break;
      case WebEvent.onLoading:
        print("onLoading>");
        final excelRequestData = event.extra;
        final excelResponseData =
            await repository.loadExcelResponseData(excelRequestData);

        emit(state.copyWith(
          excelResponseList: excelResponseData,
          isLoading: false,
        ));
        break;
    }
  }
}
