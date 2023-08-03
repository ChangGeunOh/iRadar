import '../../../../domain/model/excel_response_data.dart';

class WebState {
  final List<ExcelResponseData>? excelResponseList;

  WebState({
    this.excelResponseList,
  });

  WebState copyWith({
    List<ExcelResponseData>? excelResponseList,
  }) {
    return WebState(
      excelResponseList: excelResponseList ?? this.excelResponseList,
    );
  }
}
