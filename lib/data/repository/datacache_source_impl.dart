import 'dart:math';
import 'dart:typed_data';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemap/domain/model/chart_table_data.dart';
import 'package:googlemap/domain/model/excel_response_data.dart';
import 'package:googlemap/domain/model/login_data.dart';
import 'package:googlemap/domain/model/map/map_base_data.dart';
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
  void setBaseMarkers(int idx, Set<Marker> markers, WirelessType wirelessType) {
    if (wirelessType == WirelessType.w5G) {
      _dataCache.cache5GBaseMarkers[idx] = markers;
    } else {
      _dataCache.cacheLTEBaseMarkers[idx] = markers;
    }
  }

  @override
  Set<Marker>? getBaseMarkers(int idx, WirelessType wirelessType) {
    if (wirelessType == WirelessType.w5G) {
      return _dataCache.cache5GBaseMarkers[idx];
    } else {
      return _dataCache.cacheLTEBaseMarkers[idx];
    }
  }

  @override
  void setMeasureMarkers(
      int idx, Set<Marker> markers, WirelessType wirelessType) {
    if (wirelessType == WirelessType.w5G) {
      _dataCache.cache5GMeasureMarkers[idx] = markers;
    } else {
      _dataCache.cacheLTEMeasureMarkers[idx] = markers;
    }
  }

  @override
  void setNoLabelBaseMarkers(
      int idx, Set<Marker> markers, WirelessType wirelessType) {
    if (wirelessType == WirelessType.w5G) {
      _dataCache.cache5GNoLabelMeasureMarkers[idx] = markers;
    } else {
      _dataCache.cacheLTENoLabelMeasureMarkers[idx] = markers;
    }
  }

  @override
  Set<Marker>? getNoLabelBaseMarkers(int idx, WirelessType wirelessType) {
    if (wirelessType == WirelessType.w5G) {
      return _dataCache.cache5GNoLabelMeasureMarkers[idx];
    } else {
      return _dataCache.cacheLTENoLabelMeasureMarkers[idx];
    }
  }

  @override
  Set<Marker>? getMeasureMarkers(int idx, WirelessType wirelessType) {
    if (wirelessType == WirelessType.w5G) {
      return _dataCache.cache5GMeasureMarkers[idx];
    } else {
      return _dataCache.cacheLTEMeasureMarkers[idx];
    }
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
  void setExcelResponseDataList(
      int idx, List<ExcelResponseData> excelResponseDataList) {
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

  @override
  void setCustomMeasureMarker(
    String pci,
    String iconPath,
    BitmapDescriptor bitmapDescriptor,
  ) {
    _dataCache.cacheMeasureMarkerIcon['pci:$iconPath'] = bitmapDescriptor;
  }

  @override
  BitmapDescriptor? getCustomMeasureMarker(String pci, String iconPath) {
    return _dataCache.cacheMeasureMarkerIcon['pci:$iconPath'];
  }
}
