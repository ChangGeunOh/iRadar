import 'dart:typed_data';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemap/domain/model/chart_table_data.dart';
import 'package:googlemap/domain/model/excel_response_data.dart';
import 'package:googlemap/domain/model/login_data.dart';
import 'package:googlemap/domain/model/user_data.dart';

import '../model/map/map_base_data.dart';
import '../model/response/meta_data.dart';
import '../model/enum/wireless_type.dart';

abstract class DataCacheSource {
  void setGoogleMapController(GoogleMapController controller);

  GoogleMapController? getGoogleMapController();

  void setCameraPosition(CameraPosition cameraPosition);

  CameraPosition? getCameraPosition();

  MapBaseData? getMapBaseData(int idx);

  void setMapBaseData(int idx, MapBaseData mapData);

  ChartTableData? getChartTableData(int idx);

  void setChartTableData(int idx, ChartTableData chartTableData);

  void setBaseMarkers(int idx, Set<Marker> markers, WirelessType wirelessType);

  Set<Marker>? getBaseMarkers(int idx, WirelessType wirelessType);

  void setNoLabelBaseMarkers(
      int idx, Set<Marker> markers, WirelessType wirelessType);

  Set<Marker>? getNoLabelBaseMarkers(int idx, WirelessType wirelessType);

  void setMeasureMarkers(
      int idx, Set<Marker> markers, WirelessType wirelessType);

  Set<Marker>? getMeasureMarkers(int idx, WirelessType wirelessType);

  void setMetaData(WirelessType type, MetaData metaData);

  MetaData getMetaData(WirelessType type);

  void setLoginData(LoginData loginData);

  LoginData? getLoginData();

  void setExcelResponseDataList(
      int idx, List<ExcelResponseData> excelResponseDataList);

  List<ExcelResponseData>? getExcelResponseDataList(int idx);

  void setUserData(UserData userData);

  UserData? getUserData();

  void setCustomMeasureMarker(
    String pci,
    String iconPath,
    BitmapDescriptor bitmapDescriptor,
  );

  BitmapDescriptor? getCustomMeasureMarker(String pci, String iconPath);
}
