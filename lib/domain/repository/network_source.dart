import 'package:googlemap/domain/model/excel_response_data.dart';
import 'package:googlemap/domain/model/measure_upload_data.dart';
import 'package:googlemap/domain/model/place_data.dart';
import 'package:googlemap/domain/model/response/response_data.dart';
import 'package:googlemap/domain/model/table_data.dart';
import 'package:googlemap/domain/model/token_data.dart';
import 'package:googlemap/domain/model/user_data.dart';

import '../model/chart_table_data.dart';
import '../model/map/area_data.dart';
import '../model/map/map_base_data.dart';
import '../model/map/map_data.dart';

abstract class NetworkSource {
  Future<ResponseData<UserData?>> login(
    String body,
  );

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

  Future<ResponseData<List<ExcelResponseData>>> loadExcelResponseData({
    required String group,
    required String type,
    required int idx,
    required List<String> bts,
    required String cmd,
  });

  Future<ResponseData<List<TableData>>> loadNpciTableList(
    String link,
    String npci,
  );

  Future<ResponseData> uploadMeasureData(
    MeasureUploadData measureUploadData,
  );

  Future<ResponseData<String>> getCountArea({
    required String group,
    required String area,
  });

  Future<void> saveMergedData({
    required String name,
    required String division,
    required double latitude,
    required double longitude,
    required String password,
    required String type,
    required List<int> mergedIdxList,
  });

  Future<ResponseData<TokenData?>> postTokenData(String jsonString);

  Future<ResponseData<List<AreaData>>> getAreaList(String areaCode);

  Future<ResponseData<MapData>> getMapDataList({
    required String areaCode,
    required int idx,
  });

}
