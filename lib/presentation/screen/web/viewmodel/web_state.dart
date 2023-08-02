import 'package:googlemap/domain/model/excel_request_data.dart';

class WebState {
  final ExcelRequestData? excelRequestData;

  WebState({
    this.excelRequestData,
  });

  WebState copyWith({
    ExcelRequestData? excelRequestData,
  }) {
    return WebState(
      excelRequestData: excelRequestData ?? this.excelRequestData,
    );
  }
}
