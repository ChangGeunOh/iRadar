import 'dart:convert';
import 'dart:typed_data';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemap/common/const/constants.dart';
import 'package:googlemap/common/utils/utils.dart';
import 'package:googlemap/domain/model/base/base_data.dart';
import 'package:googlemap/domain/model/chart/measure_data.dart';
import 'package:googlemap/domain/model/chart_table_data.dart';
import 'package:googlemap/domain/model/enum/wireless_type.dart';
import 'package:googlemap/domain/model/excel_request_data.dart';
import 'package:googlemap/domain/model/login_data.dart';
import 'package:googlemap/domain/model/map/best_point_data.dart';
import 'package:googlemap/domain/model/map/map_base_data.dart';
import 'package:googlemap/domain/model/map/map_data.dart';
import 'package:googlemap/domain/model/map/merge_data.dart';
import 'package:googlemap/domain/model/notice/notice_data.dart';
import 'package:googlemap/domain/model/notice/notice_list_data.dart';
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
    final basicAuth = 'Basic ${base64Encode(utf8.encode('$userid:$password'))}';
    final response = await _networkSource.loadLogin(basicAuth);
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

  // Future<MapBaseData?> loadMapBaseData(PlaceData placeData) async {
  //   var mapBaseData = _dataCacheSource.getMapBaseData(placeData.idx);
  //
  //   if (mapBaseData == null) {
  //     final responseData = await _networkSource.loadMapBaseData(
  //       group: placeData.group,
  //       idx: placeData.idx,
  //     );
  //     if (responseData.data != null) {
  //       mapBaseData = responseData.data!;
  //       _dataCacheSource.setMapBaseData(placeData.idx, mapBaseData);
  //     }
  //   }
  //   return mapBaseData;
  // }

  Future<ResponseData> loadMeasureList(
    AreaData areaData,
    bool isRemove,
  ) async {
    final response = await _networkSource.getMeasureList(
      idx: areaData.idx,
      type: areaData.type!.name,
      isRemove: isRemove,
    );
    // if (response.meta.code == 200) {
    //   await _dataStoreSource.setMeasureList(
    //     areaData.idx,
    //     areaData.type!,
    //     response.data!,
    //   );
    // }
    return response;
  }

  // Future<ChartTableData?> loadChartTableData(PlaceData placeData) async {
  //   var chartTableData = _dataCacheSource.getChartTableData(placeData.idx);
  //   chartTableData = null;
  //   if (chartTableData == null) {
  //     final responseData = await _networkSource.loadChartTableData(
  //       group: placeData.group,
  //       idx: placeData.idx,
  //     );
  //     if (responseData.data != null) {
  //       chartTableData = responseData.data!;
  //       _dataCacheSource.setChartTableData(placeData.idx, chartTableData);
  //     }
  //   }
  //   return chartTableData;
  // }

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
    return null;

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

  void setMeasureMarkers(
      PlaceData placeData, Set<Marker> markers, WirelessType wirelessType) {
    _dataCacheSource.setMeasureMarkers(placeData.idx, markers, wirelessType);
  }

  Set<Marker>? getMeasureMarkers(int idx, WirelessType wirelessType) {
    return _dataCacheSource.getMeasureMarkers(idx, wirelessType);
  }

  void setBaseMarkers(int idx, Set<Marker> markers, WirelessType wirelessType) {
    _dataCacheSource.setBaseMarkers(idx, markers, wirelessType);
  }

  Set<Marker>? getBaseMarkers(int idx, WirelessType wirelessType) {
    return _dataCacheSource.getBaseMarkers(idx, wirelessType)?.toSet();
  }

  Set<Marker>? getNoLabelBaseMarkers(int idx, WirelessType type) {
    return _dataCacheSource.getNoLabelBaseMarkers(idx, type)?.toSet();
  }

  void setNoLabelBaseMarkers(
      int idx, Set<Marker> markers, WirelessType wirelessType) {
    _dataCacheSource.setNoLabelBaseMarkers(idx, markers, wirelessType);
  }

  // Future<List<TableData>?> loadNpciTableList(
  //   String link,
  //   String nPci,
  // ) async {
  //   final response = await _networkSource.loadNpciTableList(link, nPci);
  //   return response.data;
  // }

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

  // Future<int> getCountArea({
  //   required String group,
  //   required String area,
  // }) async {
  //   final response = await _networkSource.getCountArea(
  //     group: group,
  //     area: area,
  //   );
  //   if (response.data != null) {
  //     return int.parse(response.data!);
  //   }
  //   return 0;
  // }

  Future<void> loadUserData() async {
    final response = await _networkSource.getUserData();
    if (response.meta.code == 200) {
      // _dataCacheSource.setUserData(response.data!);
      _dataStoreSource.setUserData(response.data!);
    }
  }

  Future<UserData?> getUserData() {
    return _dataStoreSource.getUserData();
  }

  Future<ResponseData<List<AreaData>>> getAreaList() async {
    return await _networkSource.getAreaList('test');
  }

  Future<ResponseData<MapData>> getMapData(
    WirelessType type,
    int areaCode,
  ) async {
    final mapData = await _dataStoreSource.loadMapData(type, areaCode);
    if (mapData == null) {
      final responseData = await _networkSource.getMapDataList(
        type: type.name,
        idx: areaCode,
      );
      if (responseData.meta.code == 200) {
        _dataStoreSource.saveMapData(type, areaCode, responseData.data!);
        return responseData;
      } else {
        return responseData;
      }
    } else {
      return ResponseData<MapData>(data: mapData);
      ;
    }
  }

  Future<ResponseData> postMergeData(MergeData mergeData) async {
    return await _networkSource.postMergeData(mergeData);
  }

  Future<ResponseData> getNoticeList(int page) async {
    return _networkSource.getNoticeList(page);
  }

  Future<ResponseData> getNoticeData(int id) async {
    return await _networkSource.getNoticeDetail(id);
  }

  Future<ResponseData> uploadBaseData(List<BaseData> uploadData) {
    final updateList = uploadData.map((e) {
      return e.clearIdx();
    }).toList();
    return _networkSource.uploadBaseData(updateList);
  }

  Future<ResponseData> loadPasswordChange(
    String oldPassword,
    String newPassword,
  ) async {
    return _networkSource.postPassword(
      hashPassword(oldPassword, kSecreteKey),
      hashPassword(newPassword, kSecreteKey),
    );
  }

  Future<ResponseData> deleteAreaData(AreaData areaData) {
    final data = AreaData(idx: areaData.idx, name: '');
    return _networkSource.postAreaData(data);
  }

  Future<void> logout() async {
    await _dataStoreSource.removeTokenData();
    await _dataStoreSource.removeUserData();
  }

  Future<TokenData?> getTokenData() async {
    return _dataStoreSource.getTokenData();
  }

  Future<ResponseData> loadPciData({
    required String type,
    required int idx,
    required String spci,
  }) {
    return _networkSource.loadPciData(
      type: type,
      idx: idx,
      spci: spci,
    );
  }

  Future<ResponseData> loadNpciList({
    required String type,
    required int idx,
    required String spci,
  }) {
    return _networkSource.loadNpciList(
      type: type,
      idx: idx,
      spci: spci,
    );
  }

  Future<ResponseData> getBaseList(
    WirelessType type,
    LatLngBounds latLngBounds,
  ) async {
    return _networkSource.getBaseList(
      type: type.name,
      northEastLatitude: latLngBounds.northeast.latitude,
      northEastLongitude: latLngBounds.northeast.longitude,
      southWestLatitude: latLngBounds.southwest.latitude,
      southWestLongitude: latLngBounds.southwest.longitude,
    );
  }

  Future<ResponseData> getSearchArea() {
    return _networkSource.getSearchAreaList();
  }

  Future<void> clearCacheData() async {
    _dataStoreSource.clearMapData();
  }

  Future<ResponseData> getBaseDataList() async {
    return _networkSource.getBaseDataList();
  }

  void setCustomMeasureMarker(
    String pci,
    String iconPath,
    BitmapDescriptor bitmapDescriptor,
  ) {
    _dataCacheSource.setCustomMeasureMarker(pci, iconPath, bitmapDescriptor);
  }

  BitmapDescriptor? getCustomMeasureMarker(String pci, String iconPath) {
    return _dataCacheSource.getCustomMeasureMarker(pci, iconPath);
  }

  Future<String> getBaseLastDate() async {
    final response = await _networkSource.getBaseLastDate();
    return response.data ?? '';
  }

  Future<List<BestPointData>> getBestPointList(
      WirelessType wirelessType, List<String> idxList) async {
    final idxs = idxList.join(',');
    final response = await _networkSource.getBestPointList(
      type: wirelessType.name,
      idxList: idxs,
    );
    return response.data ?? [];
  }
}
