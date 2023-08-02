import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemap/domain/model/chart_table_data.dart';

import '../model/map_data.dart';

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

}
