import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:googlemap/domain/bloc/bloc_bloc.dart';
import 'package:googlemap/domain/bloc/bloc_event.dart';
import 'package:googlemap/domain/model/excel_file.dart';
import 'package:googlemap/domain/model/measure_upload_data.dart';
import 'package:googlemap/presentation/screen/upload/viewmodel/upload_event.dart';
import 'package:googlemap/presentation/screen/upload/viewmodel/upload_state.dart';

class UploadBloc extends BlocBloc<BlocEvent<UploadEvent>, UploadState> {
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
        emit(state.copyWith(group: repository.getLoginData().group));
        break;
      case UploadEvent.onChanged:
        emit(await _getState(event.extra, state));
        break;
      case UploadEvent.onTapFile:
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          allowedExtensions: ['xls', 'xlsx'],
          type: FileType.custom,
          allowMultiple: false,
        );
        if (result != null) {
          emit(state.copyWith(
            isLoading: true,
            filePickerResult: result,
            fileName: result.files.single.name,
          ));
        }
        break;
      case UploadEvent.onReadExcel:
        var bytes = event.extra.files.single.bytes;
        final excelFile = ExcelFile(bytes: bytes);
        emit(
          state.copyWith(
            isLoading: false,
            excelFile: excelFile,
            isNoLocation: state.isNoLocation,
            isLteOnly: state.isLteOnly,
          ),
        );
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
        final uploadData = excelFile!.getUploadData(
          type: state.division,
          area: state.area,
          group: state.group,
          password: state.password,
          isAddData: state.isAddData,
          isWideArea: state.isWideArea,
        );
        await _saveData(uploadData);
        emit(state.copyWith(message: '자료를 등록 하였습니디.', isLoading: false));
        break;
      case UploadEvent.onDoneToast:
        emit(state.copyWith(message: ''));
        context.pop();
        break;
    }
  }

  Future<bool> _saveData(
    MeasureUploadData measureUploadData,
  ) async {
    await repository.uploadMeasureData(measureUploadData);
    return true;
  }

  Future<UploadState> _getState(
      UploadChangeData uploadChangeData, UploadState state) async {
    switch (uploadChangeData.type) {
      case UploadChangedType.isNoLocation:
        return state.copyWith(isNoLocation: uploadChangeData.value);
      case UploadChangedType.isLteOnly:
        return state.copyWith(isLteOnly: uploadChangeData.value);
      case UploadChangedType.isWideArea:
        return state.copyWith(isWideArea: uploadChangeData.value);
      case UploadChangedType.isAddData:
        final tempState = state.copyWith(isAddData: uploadChangeData.value);
        return tempState.copyWith(enabledSave: _enabledSave(tempState));
      case UploadChangedType.onDivision:
        final tempState = state.copyWith(division: uploadChangeData.value);
        return tempState.copyWith(enabledSave: _enabledSave(tempState));
      case UploadChangedType.onArea:
        final loginData = repository.getLoginData();
        final rowCount = await repository.getCountArea(
          group: loginData.group,
          area: uploadChangeData.value,
        );
        final tempState = state.copyWith(
          area: uploadChangeData.value,
          isDuplicate: rowCount > 0,
        );
        return tempState.copyWith(enabledSave: _enabledSave(tempState));
      case UploadChangedType.onPassword:
        final tempState = state.copyWith(password: uploadChangeData.value);
        return tempState.copyWith(enabledSave: _enabledSave(tempState));
    }
  }

  bool _enabledSave(UploadState state) {
    final checkDuplicate =
        state.isDuplicate && state.isAddData || !state.isDuplicate;
    return checkDuplicate &&
        state.password.length > 3 &&
        state.area.length > 3 &&
        state.division.isNotEmpty;
  }
}
