import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemap/common/const/constants.dart';
import 'package:googlemap/domain/model/chart_table_data.dart';
import 'package:googlemap/domain/model/map_data.dart';
import 'package:googlemap/domain/model/place_data.dart';
import 'package:googlemap/domain/model/wireless_type.dart';

import '../../domain/model/excel_response_data.dart';
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
    print('retrofit response>${responseData.toString()}');
    print('retrofit response>${responseData.data?.toJson()}');
    return responseData.meta.code == 200;
  }

  Future<List<PlaceData>> loadPlaceList(WirelessType type) async {
    var placeList = await _dataStoreSource.loadPlaceList(type);
    if (placeList.isEmpty) {
      final response = await _networkSource.loadPlaceList(type.name);
      if (response.meta.code == 200) {
        placeList = response.data!.map((e) {
          return PlaceData.fromAreaData(e);
        }).toList();
      }
      _dataStoreSource.savePlaceList(type, placeList);
    }
    return placeList;
  }

  Future<void> remove() async {
    await _dataStoreSource.remove();
  }

  Future<MapData?> loadMapData(PlaceData placeData) async {
    if (_dataCacheSource.getMapData(placeData.link) == null) {
      final responseData = await _networkSource.loadMapData(placeData.link);
      if (responseData.data != null) {
        _dataCacheSource.setMapData(placeData.link, responseData.data!);
      }
    }
    return _dataCacheSource.getMapData(placeData.link);
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

  Future<ChartTableData?> loadChartTableData(PlaceData placeData) async {

    if (_dataCacheSource.getChartTableData(placeData.link) == null) {
      final responseData  = await _networkSource.loadChartTableData(placeData.link);
      if (responseData.data != null) {
        _dataCacheSource.setChartTableData(placeData.link, responseData.data!);
      }
    }
    return _dataCacheSource.getChartTableData(placeData.link);
  }

  Future<ExcelResponseData?> loadExcelResponseData(excelRequestData) async {
    return null;
  }

  void setMeasureMarkers(PlaceData placeData, List<Marker> markers) {
    _dataCacheSource.setMeasureMarkers(placeData.link, markers);
  }

  List<Marker>? getMeasureMarkers(PlaceData placeData) {
    return _dataCacheSource.getMeasureMarkers(placeData.link);
  }

  void setBaseMarkers(PlaceData placeData, List<Marker> markers) {
    _dataCacheSource.setBaseMarkers(placeData.link, markers);
  }

  List<Marker>? getBaseMarkers(PlaceData placeData) {
    return _dataCacheSource.getBaseMarkers(placeData.link);
  }

}
