import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemap/domain/model/map/best_point_data.dart';

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
  final Set<Marker> respMarkerSet;
  final Set<Marker> dltpMarkerSet;

  final List<Marker> measureMarkers;
  final Set<Circle> circleSet;
  final double radius;
  final bool isLoading;
  final MapCursorState cursorState;
  final bool isMergeData;
  final LoginData? loginData;
  final Map<int, MapData> mapDataSet;
  final Map<WirelessType, LatLngBounds> latLngBoundsMap;
  final WirelessType wirelessType;
  final String message;
  final bool showingDialog;

  final bool isShowBase;
  final Set<Marker> otherBaseMarkerSet;
  final Set<Marker> noLabelBaseMarkerSet;
  final LatLngBounds? latLngBounds;

  final bool isShowCaption;
  final bool isShowBestPoint;
  final bool isShowSpeed;

  final List<BestPointData> bestPointList;
  final Set<Marker> bestPointMarkerSet;

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
    this.wirelessType = WirelessType.w5G,
    this.latLngBoundsMap = const {},
    this.measureMarkerSet = const {},
    this.message = '',
    this.showingDialog = false,
    this.isShowBase = false,
    this.otherBaseMarkerSet = const {},
    this.latLngBounds,
    this.isShowCaption = false,
    this.noLabelBaseMarkerSet = const {},
    this.isShowBestPoint = false,
    this.bestPointList = const [],
    this.bestPointMarkerSet = const {},
    this.isShowSpeed = false,
    this.respMarkerSet = const {},
    this.dltpMarkerSet = const {},
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
    WirelessType? wirelessType,
    Map<WirelessType, LatLngBounds>? latLngBoundsMap,
    Set<Marker>? measureMarkerSet,
    String? message,
    bool? showingDialog,
    bool? isShowBase,
    Set<Marker>? otherBaseMarkerSet,
    LatLngBounds? latLngBounds,
    bool? isShowCaption,
    Set<Marker>? noLabelBaseMarkerSet,
    bool? isShowBestPoint,
    List<BestPointData>? bestPointList,
    Set<Marker>? bestPointMarkerSet,
    bool? isShowSpeed,
    Set<Marker>? respMarkerSet,
    Set<Marker>? dltpMarkerSet,
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
      wirelessType: wirelessType ?? this.wirelessType,
      latLngBoundsMap: latLngBoundsMap ?? this.latLngBoundsMap,
      measureMarkerSet: measureMarkerSet ?? this.measureMarkerSet,
      message: message ?? this.message,
      showingDialog: showingDialog ?? this.showingDialog,
      isShowBase: isShowBase ?? this.isShowBase,
      otherBaseMarkerSet: otherBaseMarkerSet ?? this.otherBaseMarkerSet,
      latLngBounds: latLngBounds ?? this.latLngBounds,
      isShowCaption: isShowCaption ?? this.isShowCaption,
      noLabelBaseMarkerSet: noLabelBaseMarkerSet ?? this.noLabelBaseMarkerSet,
      isShowBestPoint: isShowBestPoint ?? this.isShowBestPoint,
      bestPointMarkerSet: bestPointMarkerSet ?? this.bestPointMarkerSet,
      isShowSpeed: isShowSpeed ?? this.isShowSpeed,
      respMarkerSet: respMarkerSet ?? this.respMarkerSet,
      dltpMarkerSet: dltpMarkerSet ?? this.dltpMarkerSet,
    );
  }

}
