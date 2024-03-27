import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../domain/model/map/area_data.dart';
import '../../../../domain/model/enum/wireless_type.dart';
import '../../../../domain/model/login_data.dart';
import '../../../../domain/model/map/map_data.dart';
import '../../../../domain/model/map_cursor_state.dart';
import '../../../../domain/model/map/map_base_data.dart';
import '../../../../domain/model/place_data.dart';

class MapState {
  final Set<AreaData> areaDataSet;
  final Set<MapBaseData> mapBaseDataSet;
  final Set<PlaceData> markerSet;
  final bool isRectangleMode;
  final Set<Polygon> polygonSet;
  final List<Marker> baseMarkers;
  final Set<Marker> mapBaseMarkerSet;
  final Set<Marker> measureMarkerSet;

  final List<Marker> measureMarkers;
  final Set<Circle> circleSet;
  final double radius;
  final bool isLoading;
  final MapCursorState cursorState;
  final bool isMergeData;
  final LoginData? loginData;
  final Map<int, MapData> mapDataSet;
  final Map<WirelessType, LatLngBounds> latLngBoundsMap;
  final LatLngBounds? latLngBound;
  final WirelessType wirelessType;
  final String message;

  MapState({
    this.areaDataSet = const {},
    this.mapBaseDataSet = const {},
    this.markerSet = const {},
    this.isRectangleMode = false,
    this.polygonSet = const {},
    this.baseMarkers = const [],
    this.mapBaseMarkerSet = const {},
    this.measureMarkers = const [],
    this.circleSet = const {},
    this.radius = 20,
    this.isLoading = false,
    this.cursorState = MapCursorState.none,
    this.isMergeData = false,
    this.loginData,
    this.mapDataSet = const {},
    this.latLngBound,
    this.wirelessType = WirelessType.w5G,
    this.latLngBoundsMap = const {},
    this.measureMarkerSet = const {},
    this.message = '',
  });

  MapState copyWith({
    Set<AreaData>? areaDataSet,
    List<PlaceData>? placeDataList,
    Set<MapBaseData>? mapBaseDataSet,
    Set<PlaceData>? markerSet,
    bool? isRectangleMode,
    Set<Polygon>? polygonSet,
    List<Marker>? baseMarkers,
    Set<Marker>? mapBaseMarkerSet,
    List<Marker>? measureMarkers,
    Set<Circle>? circleSet,
    double? radius,
    MapCursorState? cursorState,
    bool? isLoading,
    bool? isMergeData,
    LoginData? loginData,
    List<MapData>? mapDataList,
    Map<int, MapData>? mapDataSet,
    LatLngBounds? latLngBound,
    WirelessType? wirelessType,
    Map<WirelessType, LatLngBounds>? latLngBoundsMap,
    Set<Marker>? measureMarkerSet,
    String? message,
  }) {
    return MapState(
      areaDataSet: areaDataSet ?? this.areaDataSet,
      mapBaseDataSet: mapBaseDataSet ?? this.mapBaseDataSet,
      markerSet: markerSet ?? this.markerSet,
      isRectangleMode: isRectangleMode ?? this.isRectangleMode,
      polygonSet: polygonSet ?? this.polygonSet,
      mapBaseMarkerSet: mapBaseMarkerSet ?? this.mapBaseMarkerSet,
      baseMarkers: baseMarkers ?? this.baseMarkers,
      measureMarkers: measureMarkers ?? this.measureMarkers,
      circleSet: circleSet ?? this.circleSet,
      radius: radius ?? this.radius,
      cursorState: cursorState ?? this.cursorState,
      isLoading: isLoading ?? this.isLoading,
      isMergeData: isMergeData ?? this.isMergeData,
      loginData: loginData ?? this.loginData,
      mapDataSet: mapDataSet ?? this.mapDataSet,
      latLngBound: latLngBound ?? this.latLngBound,
      wirelessType: wirelessType ?? this.wirelessType,
      latLngBoundsMap: latLngBoundsMap ?? this.latLngBoundsMap,
      measureMarkerSet: measureMarkerSet ?? this.measureMarkerSet,
      message: message ?? this.message,
    );
  }

}
