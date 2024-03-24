import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemap/domain/model/chart_table_data.dart';
import 'package:googlemap/domain/model/excel_response_data.dart';
import 'package:googlemap/domain/model/login_data.dart';
import 'package:googlemap/domain/model/map_base_data.dart';
import 'package:googlemap/domain/model/response/meta_data.dart';
import 'package:googlemap/domain/repository/datacache_source.dart';

import '../../domain/model/user_data.dart';
import '../../domain/model/enum/wireless_type.dart';
import '../datacache/local_datacache.dart';

class DataCacheSourceImpl extends DataCacheSource {
  final LocalDataCache _dataCache;

  DataCacheSourceImpl({
    required LocalDataCache dataCache,
  }) : _dataCache = dataCache;

  @override
  CameraPosition? getCameraPosition() {
    return _dataCache.cameraPosition;
  }

  @override
  GoogleMapController? getGoogleMapController() {
    return _dataCache.googleMapController;
  }

  @override
  void setCameraPosition(CameraPosition cameraPosition) {
    _dataCache.cameraPosition = cameraPosition;
  }

  @override
  void setGoogleMapController(GoogleMapController controller) {
    _dataCache.googleMapController = controller;
  }

  @override
  MapBaseData? getMapBaseData(int idx) {
    return _dataCache.cacheMapData[idx];
  }

  @override
  void setMapBaseData(int idx, MapBaseData mapData) {
    _dataCache.cacheMapData[idx] = mapData;
  }

  @override
  void setChartTableData(int idx, ChartTableData chartTableData) {
    _dataCache.cacheChartTableData[idx] = chartTableData;
  }

  @override
  ChartTableData? getChartTableData(int idx) {
    return _dataCache.cacheChartTableData[idx];
  }

  @override
  void setBaseMarkers(int idx, List<Marker> markers) {
    _dataCache.cacheBaseMarkers[idx] = markers;
  }

  @override
  List<Marker>? getBaseMarkers(int idx) {
    return _dataCache.cacheBaseMarkers[idx];
  }

  @override
  void setMeasureMarkers(int idx, List<Marker> markers) {
    _dataCache.cacheMeasureMarkers[idx] = markers;
  }

  @override
  List<Marker>? getMeasureMarkers(int idx) {
    return _dataCache.cacheMeasureMarkers[idx];
  }

  @override
  MetaData getMetaData(WirelessType type) {
    return _dataCache.cacheMetaData[type] ?? MetaData(code: 0, message: '');
  }

  @override
  void setMetaData(WirelessType type, MetaData metaData) {
    _dataCache.cacheMetaData[type] = metaData;
  }

  @override
  LoginData? getLoginData() {
    return _dataCache.loginData;
  }

  @override
  void setLoginData(LoginData loginData) {
    _dataCache.loginData = loginData;
  }

  @override
  List<ExcelResponseData>? getExcelResponseDataList(int idx) {
    return _dataCache.cacheExcelResponseDataList[idx];
  }

  @override
  void setExcelResponseDataList(int idx, List<ExcelResponseData> excelResponseDataList) {
    _dataCache.cacheExcelResponseDataList[idx] = excelResponseDataList;
  }

  @override
  void setUserData(UserData userData) {
    _dataCache.userData = userData;
  }

  @override
  UserData? getUserData() {
    return _dataCache.userData;
  }
}
