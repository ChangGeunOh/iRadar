import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googlemap/domain/bloc/bloc_bloc.dart';
import 'package:googlemap/domain/bloc/bloc_event.dart';

import 'npci_state.dart';

class NpciBloc extends BlocBloc<BlocEvent<NpciBloc>, NpciState> {
  NpciBloc(super.context, super.initialState);

  @override
  FutureOr<void> onBlocEvent(BlocEvent<NpciBloc> event, Emitter<NpciState> emit) {
    // TODO: implement onBlocEvent
    throw UnimplementedError();
  }

}