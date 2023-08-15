import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googlemap/common/utils/extension.dart';
import 'package:googlemap/domain/bloc/bloc_bloc.dart';
import 'package:googlemap/domain/bloc/bloc_event.dart';
import 'package:googlemap/domain/model/excel_file.dart';
import 'package:googlemap/domain/model/intf_tt_data.dart';
import 'package:googlemap/domain/model/measure_upload_data.dart';
import 'package:googlemap/presentation/screen/upload/viewmodel/upload_event.dart';
import 'package:googlemap/presentation/screen/upload/viewmodel/upload_state.dart';

import '../../../../domain/model/intf_data.dart';

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
        emit(_getState(event.extra, state));
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
        emit(state.copyWith(isLoading: true));
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
        emit(state.copyWith(isLoading: false));
        break;
    }
  }

  Future<bool> _saveData(
    MeasureUploadData measureUploadData,
  ) async {
    await repository.uploadMeasureData(measureUploadData);
    return true;
  }

  UploadState _getState(UploadChangeData uploadChangeData, UploadState state) {
    switch (uploadChangeData.type) {
      case UploadChangedType.isNoLocation:
        return state.copyWith(isNoLocation: uploadChangeData.value);
      case UploadChangedType.isLteOnly:
        return state.copyWith(isLteOnly: uploadChangeData.value);
      case UploadChangedType.isWideArea:
        return state.copyWith(isWideArea: uploadChangeData.value);
      case UploadChangedType.isAddData:
        return state.copyWith(isAddData: uploadChangeData.value);
      case UploadChangedType.onDivision:
        final enableButton = state.password.length > 3 &&
            state.area.length > 5 &&
            uploadChangeData.value.toString().isNotEmpty;
        return state.copyWith(
            division: uploadChangeData.value, enabledSave: enableButton);
      case UploadChangedType.onArea:
        final enableButton = state.password.length > 3 &&
            uploadChangeData.value.toString().length > 5 &&
            state.division.isNotEmpty;
        return state.copyWith(
            area: uploadChangeData.value, enabledSave: enableButton);
      case UploadChangedType.onPassword:
        final enableButton = uploadChangeData.value.toString().length > 3 &&
            state.area.length > 5 &&
            state.division.isNotEmpty;
        return state.copyWith(
            password: uploadChangeData.value, enabledSave: enableButton);
    }
  }
}
