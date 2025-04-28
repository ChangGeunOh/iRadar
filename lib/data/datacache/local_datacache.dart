import 'dart:typed_data';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemap/domain/model/chart_table_data.dart';
import 'package:googlemap/domain/model/excel_response_data.dart';
import 'package:googlemap/domain/model/login_data.dart';
import 'package:googlemap/domain/model/map/map_base_data.dart';
import 'package:googlemap/domain/model/response/meta_data.dart';
import 'package:googlemap/domain/model/user_data.dart';
import 'package:googlemap/domain/model/enum/wireless_type.dart';

class LocalDataCache {
  final Map<int, MapBaseData> cacheMapData = {};
  final Map<int, Set<Marker>> cache5GBaseMarkers = {};
  final Map<int, Set<Marker>> cacheLTEBaseMarkers = {};
  final Map<int, ChartTableData> cacheChartTableData = {};
  final Map<WirelessType, MetaData> cacheMetaData = {};
  final Map<int, List<ExcelResponseData>> cacheExcelResponseDataList = {};
  final Map<int, Set<Marker>> cache5GNoLabelMeasureMarkers = {};
  final Map<int, Set<Marker>> cacheLTENoLabelMeasureMarkers = {};
  final Map<String, BitmapDescriptor> cacheMeasureMarkerIcon = {};

  final Map<String, Set<Marker>> cacheMeasureMarkers = {};

  CameraPosition? cameraPosition;
  GoogleMapController? googleMapController;

  LoginData? loginData;
  UserData? userData;
}