import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:googlemap/domain/bloc/bloc_bloc.dart';
import 'package:googlemap/domain/bloc/bloc_event.dart';
import 'package:googlemap/domain/model/map/area_data.dart';
import 'package:googlemap/domain/model/excel_file.dart';
import 'package:googlemap/presentation/screen/upload/viewmodel/upload_event.dart';
import 'package:googlemap/presentation/screen/upload/viewmodel/upload_state.dart';


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
        final userData = repository.getUserData();
        emit(state.copyWith(group: userData?.group1));
        break;
      case UploadEvent.onTapFile:
        await _onTapFile(emit);
        break;
      case UploadEvent.onLoading:
        emit(state.copyWith(isLoading: event.extra));
        break;
      case UploadEvent.onAddData:
        emit(state.copyWith(isAddData: event.extra));
        break;
      case UploadEvent.onWideArea:
        emit(state.copyWith(isWideArea: event.extra));
        break;
      case UploadEvent.onTapSave:
        final excelFile = state.excelFile;
        final userData= repository.getUserData();
        final areaIdx = state.areaData?.idx == null ? 0 : state.isAddData ? state.areaData!.idx : 0;
        final uploadData = excelFile!.getUploadData(
          area: state.area,
          isWideArea: state.isWideArea,
          division: state.division,
          areaIdx: areaIdx,
          areaCode: userData?.areaCode ?? 'test',
        );
        print(uploadData.toJson());
        final responseData = await repository.uploadMeasureData(uploadData);
        print(responseData.meta.toJson());
        if (responseData.meta.code == 200) {
          emit(state.copyWith(message: '자료를 등록 하였습니다.', isLoading: false));
          add(BlocEvent(UploadEvent.onPreviousScreen));
        } else {
          emit(state.copyWith(message: responseData.meta.message, isLoading: false));
        }
        break;
      case UploadEvent.onDoneToast:
        emit(state.copyWith(message: ''));
        break;
      case UploadEvent.onSearch:
        List<AreaData> areaList = [];
        if (event.extra) {
          emit(state.copyWith(isLoading: true));
          final response = await repository.getAreaList();
          if (response.data != null) {
            areaList = response.data!;
          }
        }
        emit(state.copyWith(
          isLoading: false,
          isSearch: event.extra,
          areaList: areaList,
        ));
        break;
      case UploadEvent.onTapArea:
        final areaData = event.extra as AreaData;
        final division = state.division.isEmpty ? areaData.division.name : state.division;
        emit(state.copyWith(
          areaData: areaData,
          area: areaData.name,
          division: areaData.division.name,
          isAddData: true,
          enabledAddData: true,
          enabledSave:
              _enabledSave(division, areaData.name, state.fileName),
        ));
      case UploadEvent.onClearMessage:
        emit(state.copyWith(message: ''));
        break;
      case UploadEvent.onChangedArea:
        emit(state.copyWith(
          area: event.extra,
          isAddData: false,
          enabledAddData: event.extra == state.areaData?.name,
          enabledSave:
              _enabledSave(state.division, event.extra, state.fileName),
        ));
        break;
      case UploadEvent.onChangedDivision:
        FocusScope.of(context).unfocus();
        emit(state.copyWith(
          division: event.extra,
          enabledSave: _enabledSave(event.extra, state.area, state.fileName),
        ));
        break;
      case UploadEvent.onChangedPassword:
        emit(state.copyWith(password: event.extra));
        break;
      case UploadEvent.onChangedWide:
        emit(state.copyWith(isWideArea: event.extra));
        break;
      case UploadEvent.onChangedAddData:
        emit(state.copyWith(isAddData: event.extra));
        break;
      case UploadEvent.onPreviousScreen:
        context.pop();
        break;
    }
  }

  Future<void> _onTapFile(Emitter<UploadState> emit) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['xls', 'xlsx'],
      type: FileType.custom,
      allowMultiple: false,
    );
    if (result != null) {
      final file = result.files.single;
      emit(state.copyWith(isLoading: true, fileName: file.name));
      final excelFile = ExcelFile(bytes: file.bytes!);
      emit(state.copyWith(
        isLoading: false,
        excelFile: excelFile,
        enabledSave: _enabledSave(state.division, state.area, file.name),
      ));
    }
  }


  bool _enabledSave(String division, String area, String fileName) {
    print('division: $division, area: $area, fileName: $fileName');
    return area.length > 3 && division.isNotEmpty && fileName.isNotEmpty;
  }
}
