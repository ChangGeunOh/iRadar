import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemap/domain/model/chart_table_data.dart';
import 'package:googlemap/domain/model/login_data.dart';
import 'package:googlemap/domain/model/map_data.dart';
import 'package:googlemap/domain/model/meta_data.dart';
import 'package:googlemap/domain/model/wireless_type.dart';

class LocalDataCache {
  final Map<String, MapData> cacheMapData = {};
  final Map<String, List<Marker>> cacheMeasureMarkers = {};
  final Map<String, List<Marker>> cacheBaseMarkers = {};
  final Map<String, ChartTableData> cacheChartTableData = {};
  final Map<WirelessType, MetaData> cacheMetaData = {};

  CameraPosition? cameraPosition;
  GoogleMapController? googleMapController;

  LoginData? loginData;
}