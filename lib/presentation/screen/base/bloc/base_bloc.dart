import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/utils/base_csv_file.dart';
import '../../../../domain/bloc/bloc_bloc.dart';
import '../../../../domain/bloc/bloc_event.dart';
import 'base_event.dart';
import 'base_state.dart';

class BaseBloc extends BlocBloc<BlocEvent<BaseEvent>, BaseState> {
  BaseBloc(super.context, super.initialState) {
    init();
  }

  void init() {
    add(BlocEvent(BaseEvent.init));
  }

  @override
  Future<FutureOr<void>> onBlocEvent(
    BlocEvent<BaseEvent> event,
    Emitter<BaseState> emit,
  ) async {
    switch (event.type) {
      case BaseEvent.init:
        break;
      case BaseEvent.onTapFinder:
        await _onFinder(emit);
        break;
      case BaseEvent.onTapUpload:
        emit(state.copyWith(isLoading: true));
        final baseDataList = state.baseDataList;
        final uploadData = baseDataList.where((e) => !e.isNotValid()).toList();
        final errorData = baseDataList.where((e) => e.isNotValid()).toList();
        final response = await repository.uploadBaseData(uploadData);
        if (response.meta.code != 200) {
          emit(state.copyWith(
            isLoading: false,
            baseDataList: baseDataList,
            message: '업로드 중 오류가 발생했습니다.',
          ));
        } else {
          emit(state.copyWith(
            isLoading: false,
            baseDataList: errorData,
            message: '업로드를 완료 했습니다.',
          ));
        }
      // if (baseDataList.isNotEmpty) {
      //   var end = (baseDataList.length < 5000) ? baseDataList.length : 5000;
      //   final targetData = baseDataList.sublist(0, end);
      //   final uploadData = targetData.where((e) => !e.isNotValid()).toList();
      //   final errorData = targetData.where((e) => e.isNotValid()).toList();
      //   final errorDataList = List<BaseData>.from(state.errorDataList);
      //   final response = await repository.uploadBaseData(uploadData);
      //   if (response.meta.code != 200) {
      //     errorDataList.addAll(targetData);
      //     emit(state.copyWith(
      //       baseDataList: errorDataList,
      //       errorDataList: [],
      //       isLoading: false,
      //     ));
      //   } else {
      //     baseDataList.removeRange(0, end);
      //     errorDataList.addAll(errorData);
      //     emit(state.copyWith(
      //       baseDataList: baseDataList,
      //       errorDataList: errorDataList,
      //     ));
      //     add(BlocEvent(BaseEvent.onTapUpload));
      //   }
      // }
      // else {
      // emit(state.copyWith(
      // baseDataList: state.errorDataList,
      // isLoading: false,
      // ));
      // }
      break;
      case BaseEvent.onTapRemove:
        emit(state.copyWith(
          baseDataList: [],
          errorDataList: [],
        ));
        break;
      case BaseEvent.onMessage:
        emit(state.copyWith(message: event.extra));
        break;
    }
  }

  Future<void> _onFinder(Emitter<BaseState> emit) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['csv'],
      type: FileType.custom,
      allowMultiple: false,
    );
    if (result != null) {
      emit(state.copyWith(isLoading: true));
      print('-----------------------> isLoading: true');
      await Future.delayed(const Duration(milliseconds: 200));
      final file = result.files.single;
      final baseCsvFile = BaseCsvFile(file: file);
      await baseCsvFile.process();
      print('-----------------------> isLoading: false');
      emit(state.copyWith(
        isLoading: false,
        baseDataList: baseCsvFile.getBaseDataList,
      ));
    }
  }
}
