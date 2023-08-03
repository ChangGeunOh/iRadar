import 'package:googlemap/domain/model/area_data.dart';
import 'package:googlemap/domain/model/base_data.dart';
import 'package:googlemap/domain/model/excel_request_data.dart';
import 'package:googlemap/domain/model/excel_response_data.dart';
import 'package:googlemap/domain/model/login_data.dart';
import 'package:googlemap/domain/model/measure_data.dart';
import 'package:googlemap/domain/model/response_data.dart';

import '../model/chart_table_data.dart';
import '../model/map_data.dart';

abstract class NetworkSource {
  Future<List<String>> loadBanners();

  Future<dynamic> loadMovieChart();

  Future<ResponseData<LoginData>> login({required String area, required String password});

  Future<ResponseData<List<AreaData>>> loadPlaceList(String type);

  Future<ResponseData<MapData>> loadMapData(String area);

  Future<ResponseData<ChartTableData>> loadChartTableData(String link);

  Future<ResponseData<List<ExcelResponseData>>> loadExcelResponseData(String tbl, String area, List<String> bts, String cmd);

}