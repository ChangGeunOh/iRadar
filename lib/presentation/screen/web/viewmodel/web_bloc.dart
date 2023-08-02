import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googlemap/domain/bloc/bloc_bloc.dart';
import 'package:googlemap/presentation/screen/web/viewmodel/web_event.dart';
import 'package:googlemap/presentation/screen/web/viewmodel/web_state.dart';

import '../../../../domain/bloc/bloc_event.dart';

class WebBloc extends BlocBloc<BlocEvent<WebEvent>, WebState> {
  WebBloc(super.context, super.initialState);

  @override
  FutureOr<void> onBlocEvent(event, Emitter<WebState> emit) {
    switch(event) {
      case WebEvent.onInit:
        final excelRequestData = event.extra;
        repository.loadExcelResponseData(excelRequestData);
        break;
    }
  }

}