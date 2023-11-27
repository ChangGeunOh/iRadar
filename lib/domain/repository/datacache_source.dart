import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemap/domain/model/chart_table_data.dart';
import 'package:googlemap/domain/model/login_data.dart';

import '../model/map_base_data.dart';
import '../model/meta_data.dart';
import '../model/wireless_type.dart';

abstract class DataCacheSource {

  void setGoogleMapController(GoogleMapController controller);

  GoogleMapController? getGoogleMapController();

  void setCameraPosition(CameraPosition cameraPosition);

  CameraPosition? getCameraPosition();

  MapBaseData? getMapBaseData(int idx);
  void setMapBaseData(int idx, MapBaseData mapData);

  ChartTableData? getChartTableData(int idx);
  void setChartTableData(int idx, ChartTableData chartTableData);

  void setBaseMarkers(int idx, List<Marker> markers);
  List<Marker>? getBaseMarkers(int idx);

  void setMeasureMarkers(int idx, List<Marker> markers);
  List<Marker>? getMeasureMarkers(int idx);

  void setMetaData(WirelessType type, MetaData metaData);
  MetaData getMetaData(WirelessType type);

  void setLoginData(LoginData loginData);
  LoginData? getLoginData();

}
