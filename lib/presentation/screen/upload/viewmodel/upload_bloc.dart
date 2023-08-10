import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googlemap/domain/bloc/bloc_bloc.dart';
import 'package:googlemap/presentation/screen/upload/viewmodel/upload_event.dart';
import 'package:googlemap/presentation/screen/upload/viewmodel/upload_state.dart';

class UploadBloc extends BlocBloc<UploadEvent, UploadState> {
  UploadBloc(super.context, super.initialState);

  @override
  FutureOr<void> onBlocEvent(UploadEvent event, Emitter<UploadState> emit) {
    // TODO: implement onBlocEvent
    throw UnimplementedError();
  }

}