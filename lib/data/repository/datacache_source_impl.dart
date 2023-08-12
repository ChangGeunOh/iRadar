import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemap/domain/model/chart_table_data.dart';
import 'package:googlemap/domain/model/login_data.dart';
import 'package:googlemap/domain/model/map_data.dart';
import 'package:googlemap/domain/model/meta_data.dart';
import 'package:googlemap/domain/repository/datacache_source.dart';

import '../../domain/model/wireless_type.dart';
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
  MapData? getMapData(String link) {
    return _dataCache.cacheMapData[link];
  }

  @override
  void setMapData(String link, MapData mapData) {
    _dataCache.cacheMapData[link] = mapData;
  }

  @override
  void setChartTableData(String link, ChartTableData chartTableData) {
    _dataCache.cacheChartTableData[link] = chartTableData;
  }

  @override
  ChartTableData? getChartTableData(String link) {
    return _dataCache.cacheChartTableData[link];
  }

  @override
  void setBaseMarkers(String link, List<Marker> markers) {
    _dataCache.cacheBaseMarkers[link] = markers;
  }

  @override
  List<Marker>? getBaseMarkers(String link) {
    return _dataCache.cacheBaseMarkers[link];
  }

  @override
  void setMeasureMarkers(String link, List<Marker> markers) {
    _dataCache.cacheMeasureMarkers[link] = markers;
  }

  @override
  List<Marker>? getMeasureMarkers(String link) {
    return _dataCache.cacheMeasureMarkers[link];
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
}
