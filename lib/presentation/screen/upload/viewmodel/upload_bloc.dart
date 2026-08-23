import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../domain/bloc/bloc_bloc.dart';
import '../../../../domain/bloc/bloc_event.dart';
import 'upload_event.dart';
import 'upload_state.dart';


class UploadBloc extends BlocBloc<BlocEvent<UploadEvent>, UploadState> {
  final TextEditingController searchEditingController = TextEditingController();

  UploadBloc(super.context, super.initialState) {
    add(BlocEvent(UploadEvent.init));
  }

  @override
  FutureOr<void> onBlocEvent(
    BlocEvent<UploadEvent> event,
    Emitter<UploadState> emit,
  ) async {
    switch (event.type) {
      case UploadEvent.init:
        final userData = await repository.getUserData();
        emit(state.copyWith(group: userData?.group1));
        break;
      case UploadEvent.onLoading:
        emit(state.copyWith(isLoading: event.extra));
        break;
      case UploadEvent.onTapSave:
        emit(state.copyWith(isLoading: true));
        final responseData = await repository.uploadRequestData(
          requestUploadData: event.extra,
        );
        // // final responseData = await repository.uploadMeasureData(requestNumber: requestNumber, measureUploadData: event.extra);
        // emit(state.copyWith(isLoading: false));
        // if (responseData.meta.code == 200) {
        //   emit(state.copyWith(message: '자료를 등록 하였습니다.', isLoading: false));
        //   if (context.mounted) {
        //     context.pop(true);
        //   }
        // } else {
        //   emit(state.copyWith(message: responseData.meta.message, isLoading: false));
        // }

        if (responseData.meta.code == 200) {
          emit(state.copyWith(message: '자료를 등록 하였습니다.', isLoading: false));
          if (context.mounted) {
            context.pop(true);
          }
        }
        emit(state.copyWith(message: responseData.meta.message, isLoading: false));
        break;
      case UploadEvent.onClearMessage:
        emit(state.copyWith(message: ''));
        break;
      case UploadEvent.onChangedData:
        emit(state.copyWith(
          measureProcessData: event.extra,
        ));
        break;
    }
  }

}
