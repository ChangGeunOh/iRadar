import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemap/domain/model/chart_table_data.dart';
import 'package:googlemap/domain/model/map_data.dart';
import 'package:googlemap/domain/repository/datacache_source.dart';

import '../datacache/local_datacache.dart';


class DataCacheSourceImpl extends DataCacheSource {
  final LocalDataCache _dataCache;

  DataCacheSourceImpl({
    required LocalDataCache dataCache,
  }) : _dataCache = dataCache;

  @override
  void setMarkers(String link, List<Marker> markers) {
    _dataCache.cacheMarkers[link] = markers;
  }

  @override
  List<Marker>? getMarkers(String link) {
    return _dataCache.cacheMarkers[link];
  }

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



}