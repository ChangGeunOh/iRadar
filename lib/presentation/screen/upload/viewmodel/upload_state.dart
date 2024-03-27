import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';

import '../../../../domain/model/map/area_data.dart';
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
  final bool isSearch;
  final List<AreaData> areaList;
  final AreaData? areaData;
  final bool enabledAddData;

  UploadState({
    this.isNoLocation = false,
    this.isLteOnly = false,
    this.isWideArea = false,
    this.isAddData = false,
    this.group = '',
    this.division = '',
    this.area = '',
    this.location = '',
    this.fileName = '',
    this.isLoading = false,
    this.isDuplicate = false,
    this.filePickerResult,
    this.enabledSave = false,
    this.password = '',
    this.message = '',
    this.excelFile,
    this.isSearch = false,
    this.areaList = const [],
    this.areaData,
    this.enabledAddData = true,
  });

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
    bool? isSearch,
    List<AreaData>? areaList,
    AreaData? areaData,
    bool? enabledAddData,
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
      isSearch: isSearch ?? this.isSearch,
      areaList: areaList ?? this.areaList,
      areaData: areaData ?? this.areaData,
      enabledAddData: enabledAddData ?? this.enabledAddData,
    );
  }
}
