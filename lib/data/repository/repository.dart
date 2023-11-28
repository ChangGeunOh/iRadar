import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemap/common/const/constants.dart';
import 'package:googlemap/domain/model/chart_table_data.dart';
import 'package:googlemap/domain/model/excel_request_data.dart';
import 'package:googlemap/domain/model/login_data.dart';
import 'package:googlemap/domain/model/map_base_data.dart';
import 'package:googlemap/domain/model/measure_upload_data.dart';
import 'package:googlemap/domain/model/place_data.dart';
import 'package:googlemap/domain/model/wireless_type.dart';

import '../../domain/model/excel_response_data.dart';
import '../../domain/model/meta_data.dart';
import '../../domain/model/table_data.dart';
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

  Future<bool> login({
    required String location,
    required String password,
  }) async {
    final responseData = await _networkSource.login(
      area: location,
      password: password,
    );
    if (responseData.meta.code == 200) {
      _dataCacheSource.setLoginData(responseData.data!);
    }
    print('retrofit response>${responseData.toString()}');
    print('retrofit response>${responseData.data?.toJson()}');
    return responseData.meta.code == 200;
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
    return metaData.page < metaData.total || metaData.total == 0;
  }

  Future<List<PlaceData>> loadPlaceList(WirelessType type) async {
    var metaData = _dataCacheSource.getMetaData(type);
    List<PlaceData> placeList = List.empty(growable: true);
    List<PlaceData> list = await _dataStoreSource.loadPlaceList(type);
    print('::Saved PlaceList>${list.length}');
    placeList.addAll(list);

    if (metaData.page < metaData.total || metaData.total == 0) {
      var response = await _networkSource.loadPlaceList(
        group: getLoginData().group,
        type: type.name,
        page: metaData.page + 1,
        count: metaData.count,
      );

      if (response.meta.code == 200) {
        print('::Download PlaceList>${response.data!.length}');
        List<PlaceData> list = response.data!;
        print('::Total PlaceList>${placeList!.length}');
        placeList.addAll(list);
        print('::Total PlaceList>${placeList!.length}');
        _dataCacheSource.setMetaData(type, response.meta);
        _dataStoreSource.savePlaceList(type, placeList);
      }
    }
    print('loadPlaceList>${placeList.length}');
    return placeList;
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
    print("MapBaseData>${mapBaseData?.toJson()}");
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
    final List<String> bts = excelRequestData.tableList
        .where((element) => element.checked)
        .map((e) => '${e.nId}:${e.hasColor ? "1" : ""}')
        .toList();
    final loginData = getLoginData();
    final response = await _networkSource.loadExcelResponseData(
      group: loginData.group,
      type: excelRequestData.placeData.type.name,
      idx: excelRequestData.placeData.idx,
      bts: bts,
      cmd: '',
    );

    return response.data;
  }

  void setMeasureMarkers(PlaceData placeData, List<Marker> markers) {
    _dataCacheSource.setMeasureMarkers(placeData.idx, markers);
  }

  List<Marker>? getMeasureMarkers(PlaceData placeData) {
    return _dataCacheSource.getMeasureMarkers(placeData.idx);
  }

  void setBaseMarkers(PlaceData placeData, List<Marker> markers) {
    _dataCacheSource.setBaseMarkers(placeData.idx, markers);
  }

  List<Marker>? getBaseMarkers(PlaceData placeData) {
    return _dataCacheSource.getBaseMarkers(placeData.idx);
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
    return _dataCacheSource.getLoginData() ?? LoginData(idx: 1, group: '부산');
  }

  Future<void> uploadMeasureData(MeasureUploadData measureUploadData) async {
    final data = MeasureUploadData(
      intf5GList: measureUploadData.intf5GList.sublist(0, 1),
      intfLteList: measureUploadData.intfLteList.sublist(0, 1),
      intfTTList: measureUploadData.intfTTList.sublist(0, 1),
    );
    data.group = measureUploadData.group;
    data.area = measureUploadData.area;
    data.password = measureUploadData.password;
    data.type = measureUploadData.type;

    final result = await _networkSource.uploadMeasureData(measureUploadData);
    print('uploadMeasureData>${result.toString()}');
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
}
