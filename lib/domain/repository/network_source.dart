import 'package:googlemap/domain/model/excel_response_data.dart';
import 'package:googlemap/domain/model/login_data.dart';
import 'package:googlemap/domain/model/measure_upload_data.dart';
import 'package:googlemap/domain/model/place_data.dart';
import 'package:googlemap/domain/model/response_data.dart';
import 'package:googlemap/domain/model/table_data.dart';

import '../model/chart_table_data.dart';
import '../model/map_base_data.dart';

abstract class NetworkSource {
  Future<List<String>> loadBanners();

  Future<dynamic> loadMovieChart();

  Future<ResponseData<LoginData>> login(
      {required String area, required String password});

  Future<ResponseData<List<PlaceData>>> loadPlaceList({
    required String group,
    required String type,
    int page,
    int count,
  });

  Future<ResponseData<MapBaseData>> loadMapBaseData({
    required String group,
    required int idx,
  });

  Future<ResponseData<ChartTableData>> loadChartTableData({
    required String group,
    required int idx,
  });

  Future<ResponseData<List<ExcelResponseData>>> loadExcelResponseData(
      String tbl, String area, List<String> bts, String cmd);

  Future<ResponseData<List<TableData>>> loadNpciTableList(
    String link,
    String npci,
  );

  Future<ResponseData<String>> uploadMeasureData(
    MeasureUploadData measureUploadData,
  );

  Future<ResponseData<String>> getCountArea({
    required String group,
    required String area,
  });
}
