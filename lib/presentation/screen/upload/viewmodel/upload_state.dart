import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';

import '../../../../domain/model/excel_file.dart';

class UploadState {
  final String message;
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
  final bool enabledSave;
  final String password;
  final ExcelFile? excelFile;
  final bool isDuplicate;

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
    bool? isDuplicate,
    this.filePickerResult,
    bool? enabledSave,
    String? password,
    String? message,
    this.excelFile,
  })  : isNoLocation = isNoLocation ?? false,
        isLteOnly = isLteOnly ?? false,
        isWideArea = isWideArea ?? false,
        isAddData = isAddData ?? false,
        group = group ?? '',
        division = division ?? '',
        area = area ?? '',
        location = location ?? '',
        fileName = fileName ?? '',
        isLoading = isLoading ?? false,
        enabledSave = enabledSave ?? false,
        password = password ?? '',
        isDuplicate = isDuplicate ?? false,
        message = message ?? '';

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
    bool? enabledSave,
    String? password,
    ExcelFile? excelFile,
    String? message,
    bool? isDuplicate,
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
      enabledSave: enabledSave ?? this.enabledSave,
      password: password ?? this.password,
      excelFile: excelFile ?? this.excelFile,
      message: message ?? this.message,
      isDuplicate: isDuplicate ?? this.isDuplicate,
    );
  }
}
