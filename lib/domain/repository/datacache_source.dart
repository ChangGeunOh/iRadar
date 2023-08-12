import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemap/domain/model/chart_table_data.dart';
import 'package:googlemap/domain/model/login_data.dart';

import '../model/map_data.dart';
import '../model/meta_data.dart';
import '../model/wireless_type.dart';

abstract class DataCacheSource {

  void setGoogleMapController(GoogleMapController controller);

  GoogleMapController? getGoogleMapController();

  void setCameraPosition(CameraPosition cameraPosition);

  CameraPosition? getCameraPosition();

  MapData? getMapData(String link);
  void setMapData(String link, MapData mapData);

  ChartTableData? getChartTableData(String link);
  void setChartTableData(String link, ChartTableData chartTableData);

  void setBaseMarkers(String link, List<Marker> markers);
  List<Marker>? getBaseMarkers(String link);

  void setMeasureMarkers(String link, List<Marker> markers);
  List<Marker>? getMeasureMarkers(String link);

  void setMetaData(WirelessType type, MetaData metaData);
  MetaData getMetaData(WirelessType type);

  void setLoginData(LoginData loginData);
  LoginData? getLoginData();

}
