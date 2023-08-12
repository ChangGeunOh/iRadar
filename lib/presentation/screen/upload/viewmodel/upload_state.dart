import 'package:file_picker/file_picker.dart';

import '../../../../domain/model/measure_upload_data.dart';

class UploadState {
  final bool isNoLocation;
  final bool isLteOnly;
  final bool isWideArea;
  final bool isAddData;
  final String group;
  final String division;
  final String area;
  final String location;
  final String fileName;
  final bool isLoading;
  final FilePickerResult? filePickerResult;
  final MeasureUploadData? measureUploadData;
  final bool enabledSave;
  final String password;

  UploadState({
    bool? isNoLocation,
    bool? isLteOnly,
    bool? isWideArea,
    bool? isAddData,
    String? group,
    String? division,
    String? area,
    String? location,
    String? fileName,
    bool? isLoading,
    this.filePickerResult,
    this.measureUploadData,
    bool? enabledSave,
    String? password,
  })  : isNoLocation = isNoLocation ?? false,
        isLteOnly = isLteOnly ?? false,
        isWideArea = isWideArea ?? false,
        isAddData = isAddData ?? false,
        group = group ?? '',
        division = division ?? '행정동',
        area = area ?? '',
        location = location ?? '',
        fileName = fileName ?? '',
        isLoading = isLoading ?? false,
        enabledSave = enabledSave ?? false,
        password = password ?? '';

  UploadState copyWith({
    bool? isNoLocation,
    bool? isLteOnly,
    bool? isWideArea,
    bool? isAddData,
    String? group,
    String? division,
    String? area,
    String? location,
    String? fileName,
    bool? isLoading,
    FilePickerResult? filePickerResult,
    MeasureUploadData? measureUploadData,
    bool? enabledSave,
    String? password,
  }) {
    return UploadState(
      isNoLocation: isNoLocation ?? this.isNoLocation,
      isLteOnly: isLteOnly ?? this.isLteOnly,
      isWideArea: isWideArea ?? this.isWideArea,
      isAddData: isAddData ?? this.isAddData,
      location: location ?? this.location,
      group: group ?? this.group,
      area: area ?? this.area,
      division: division ?? this.division,
      fileName: fileName ?? this.fileName,
      isLoading: isLoading ?? this.isLoading,
      filePickerResult: filePickerResult ?? this.filePickerResult,
      measureUploadData: measureUploadData ?? this.measureUploadData,
      enabledSave: enabledSave ?? this.enabledSave,
      password: password ?? this.password,
    );
  }
}
