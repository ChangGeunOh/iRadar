import 'package:googlemap/domain/model/excel_request_data.dart';

import '../../../../domain/model/excel_response_data.dart';

class WebState {
  final ExcelRequestData? excelRequestData;
  final List<ExcelResponseData>? excelResponseList;
  final bool isLoading;

  WebState({
    this.excelRequestData,
    this.excelResponseList,
    this.isLoading = false,
  });

  WebState copyWith({
    ExcelRequestData? excelRequestData,
    List<ExcelResponseData>? excelResponseList,
    bool? isLoading,
  }) {
    return WebState(
      excelRequestData: excelRequestData ?? this.excelRequestData,
      excelResponseList: excelResponseList ?? this.excelResponseList,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
