import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemap/common/const/constants.dart';
import 'package:googlemap/domain/model/chart_table_data.dart';
import 'package:googlemap/domain/model/enum/wireless_type.dart';
import 'package:googlemap/domain/model/excel_request_data.dart';
import 'package:googlemap/domain/model/login_data.dart';
import 'package:googlemap/domain/model/map/map_base_data.dart';
import 'package:googlemap/domain/model/map/map_data.dart';
import 'package:googlemap/domain/model/place_data.dart';
import 'package:googlemap/domain/model/response/response_data.dart';
import 'package:googlemap/domain/model/token_data.dart';
import 'package:googlemap/domain/model/user_data.dart';

import '../../domain/model/excel_response_data.dart';
import '../../domain/model/map/area_data.dart';
import '../../domain/model/response/meta_data.dart';
import '../../domain/model/table_data.dart';
import '../../domain/model/upload/measure_upload_data.dart';
import '../../domain/repository/database_source.dart';
import '../../domain/repository/datacache_source.dart';
import '../../domain/repository/datastore_source.dart';
import '../../domain/repository/network_source.dart';

class Repository {
  final DataCacheSource _dataCacheSource;
  final DatabaseSource _databaseSource;
  final DataStoreSource _dataStoreSource;
  final NetworkSource _networkSource;

  Repository({
    required DatabaseSource databaseSource,
    required DataStoreSource dataStoreSource,
    required NetworkSource networkSource,
    required DataCacheSource dataCacheSource,
  })  : _databaseSource = databaseSource,
        _dataStoreSource = dataStoreSource,
        _networkSource = networkSource,
        _dataCacheSource = dataCacheSource;

  Future<ResponseData> login({
    required String userid,
    required String password,
  }) async {
    final loginData = LoginData(
      userid: userid,
      password: password,
    );
    final ResponseData<UserData?> response =
        await _networkSource.login(loginData.toJsonString());
    if (response.data != null) {
      _dataCacheSource.setUserData(response.data!);
    }
    final ResponseData<TokenData?> tokenResponse =
        await _networkSource.postTokenData(loginData.toJsonString());
    return response;
  }

  // Future<List<PlaceData>> loadPlaceList(WirelessType type) async {
  //   var placeList = await _dataStoreSource.loadPlaceList(type);
  //   if (placeList.isEmpty) {
  //     final response = await _networkSource.loadPlaceList(type: type.name);
  //     if (response.meta.code == 200) {
  //       placeList = response.data!;
  //       _dataCacheSource.setMetaData(response.meta)
  //       _dataStoreSource.savePlaceList(type, placeList)
  //     }
  //   }
  //   return placeList;
  // }

  bool hasMorePlaceList(WirelessType type) {
    var metaData = _dataCacheSource.getMetaData(type);
    return metaData.pageData!.page < metaData.pageData!.total ||
        metaData.pageData!.total == 0;
  }

  Future<void> remove(WirelessType type) async {
    _dataCacheSource.setMetaData(type, MetaData(code: 0, message: ''));
    await _dataStoreSource.remove(type);
  }

  Future<MapBaseData?> loadMapBaseData(PlaceData placeData) async {
    var mapBaseData = _dataCacheSource.getMapBaseData(placeData.idx);

    if (mapBaseData == null) {
      final responseData = await _networkSource.loadMapBaseData(
        group: placeData.group,
        idx: placeData.idx,
      );
      if (responseData.data != null) {
        mapBaseData = responseData.data!;
        _dataCacheSource.setMapBaseData(placeData.idx, mapBaseData);
      }
    }
    return mapBaseData;
  }

  Future<ChartTableData?> loadChartTableData(PlaceData placeData) async {
    var chartTableData = _dataCacheSource.getChartTableData(placeData.idx);
    if (chartTableData == null) {
      final responseData = await _networkSource.loadChartTableData(
        group: placeData.group,
        idx: placeData.idx,
      );
      if (responseData.data != null) {
        chartTableData = responseData.data!;
        _dataCacheSource.setChartTableData(placeData.idx, chartTableData);
      }
    }
    return chartTableData;
  }

  void setGoogleMapController(GoogleMapController controller) {
    _dataCacheSource.setGoogleMapController(controller);
  }

  GoogleMapController? getGoogleMapController() {
    return _dataCacheSource.getGoogleMapController();
  }

  void setCameraPosition(CameraPosition cameraPosition) {
    _dataCacheSource.setCameraPosition(cameraPosition);
  }

  CameraPosition getCameraPosition() {
    return _dataCacheSource.getCameraPosition() ?? initCameraPosition;
  }

  Future<List<ExcelResponseData>?> loadExcelResponseData(
    ExcelRequestData excelRequestData,
  ) async {
    // final List<String> bts = excelRequestData.tableList
    //     .where((element) => element.checked)
    //     .map((e) => '${e.nId}:${e.hasColor ? "1" : ""}')
    //     .toList();
    // final loginData = getLoginData();
    // var excelResponseDataList = _dataCacheSource.getExcelResponseDataList(
    //   excelRequestData.placeData.idx,
    // );
    //
    // if (excelResponseDataList == null) {
    //   var responseData = await _networkSource.loadExcelResponseData(
    //     group: loginData.group,
    //     type: excelRequestData.placeData.type.name,
    //     idx: excelRequestData.placeData.idx,
    //     bts: bts,
    //     cmd: '',
    //   );
    //
    //   excelResponseDataList = responseData.data;
    //   if (excelResponseDataList != null) {
    //     _dataCacheSource.setExcelResponseDataList(
    //       excelRequestData.placeData.idx,
    //       excelResponseDataList,
    //     );
    //   }
    // }
    //
    // return excelResponseDataList;
  }

  void setMeasureMarkers(PlaceData placeData, Set<Marker> markers) {
    _dataCacheSource.setMeasureMarkers(placeData.idx, markers);
  }

  Set<Marker>? getMeasureMarkers(int idx) {
    return _dataCacheSource.getMeasureMarkers(idx);
  }

  void setBaseMarkers(int idx, Set<Marker> markers) {
    _dataCacheSource.setBaseMarkers(idx, markers);
  }

  Set<Marker>? getBaseMarkers(int idx) {
    return _dataCacheSource.getBaseMarkers(idx)?.toSet();
  }

  Future<List<TableData>?> loadNpciTableList(
    String link,
    String nPci,
  ) async {
    final response = await _networkSource.loadNpciTableList(link, nPci);
    return response.data;
  }

  LoginData getLoginData() {
    // TODO: null 체크 부문 수정 요함
    // return _dataCacheSource.getLoginData() ?? LoginData(idx: 1, group: '부산');
    return LoginData(userid: 'admin', password: 'admin');
  }

  Future<ResponseData> uploadMeasureData(
    MeasureUploadData measureUploadData,
  ) async {
    final result = await _networkSource.uploadMeasureData(measureUploadData);
    print('uploadMeasureData>${result.toString()}');
    return result;
  }

  Future<int> getCountArea({
    required String group,
    required String area,
  }) async {
    final response = await _networkSource.getCountArea(
      group: group,
      area: area,
    );
    if (response.data != null) {
      return int.parse(response.data!);
    }
    return 0;
  }

  Future<void> saveMergedData(
    PlaceData mergedPlaceData,
    List<PlaceData> placeDataList,
  ) async {
    final mergedIdxList = placeDataList.map((e) => e.idx).toList();
    await _networkSource.saveMergedData(
      name: mergedPlaceData.name,
      division: mergedPlaceData.division.name,
      latitude: mergedPlaceData.latitude,
      longitude: mergedPlaceData.longitude,
      type: mergedPlaceData.type.name,
      mergedIdxList: mergedIdxList,
      password: mergedPlaceData.password,
    );
  }

  UserData? getUserData() {
    return _dataCacheSource.getUserData();
  }

  Future<ResponseData<List<AreaData>>> getAreaList() async {
    final userData = getUserData();
    return await _networkSource.getAreaList(userData?.areaCode ?? 'test');
  }

  Future<ResponseData<MapData>> getMapDataList(int areaCode) async {
    final userData = getUserData();

    final dataList = await _dataStoreSource.loadMapDataList(areaCode);
    if (dataList.isEmpty) {
      return await _networkSource.getMapDataList(
        areaCode: userData?.areaCode ?? 'test',
        idx: areaCode,
      );
    } else {
      return ResponseData();
    }
  }
}
