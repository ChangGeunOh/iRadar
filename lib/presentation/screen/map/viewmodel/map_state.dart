import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../domain/model/login_data.dart';
import '../../../../domain/model/map_cursor_state.dart';
import '../../../../domain/model/map_base_data.dart';
import '../../../../domain/model/place_data.dart';

class MapState {
  final List<PlaceData> placeDataList;
  final Set<MapBaseData> mapBaseDataSet;
  final Set<PlaceData> markerSet;
  final bool isRectangleMode;
  final Set<Polygon> polygonSet;
  final List<Marker> baseMarkers;
  final List<Marker> measureMarkers;
  final Set<Circle> circleSet;
  final double radius;
  final bool isLoading;
  final MapCursorState cursorState;
  final bool isMergeData;
  final LoginData? loginData;

  MapState({
    this.placeDataList = const [],
    this.mapBaseDataSet = const {},
    this.markerSet = const {},
    this.isRectangleMode = false,
    this.polygonSet = const {},
    this.baseMarkers = const [],
    this.measureMarkers = const [],
    this.circleSet = const {},
    this.radius = 20,
    this.isLoading = false,
    this.cursorState = MapCursorState.none,
    this.isMergeData = false,
    this.loginData,
  });

  MapState copyWith({
    List<PlaceData>? placeDataList,
    Set<MapBaseData>? mapBaseDataSet,
    Set<PlaceData>? markerSet,
    bool? isRectangleMode,
    Set<Polygon>? polygonSet,
    List<Marker>? baseMarkers,
    List<Marker>? measureMarkers,
    Set<Circle>? circleSet,
    double? radius,
    MapCursorState? cursorState,
    bool? isLoading,
    bool? isMergeData,
    LoginData? loginData,
  }) {
    return MapState(
      placeDataList: placeDataList ?? this.placeDataList,
      mapBaseDataSet: mapBaseDataSet ?? this.mapBaseDataSet,
      markerSet: markerSet ?? this.markerSet,
      isRectangleMode: isRectangleMode ?? this.isRectangleMode,
      polygonSet: polygonSet ?? this.polygonSet,
      baseMarkers: baseMarkers ?? this.baseMarkers,
      measureMarkers: measureMarkers ?? this.measureMarkers,
      circleSet: circleSet ?? this.circleSet,
      radius: radius ?? this.radius,
      cursorState: cursorState ?? this.cursorState,
      isLoading: isLoading ?? this.isLoading,
      isMergeData: isMergeData ?? this.isMergeData,
      loginData: loginData ?? this.loginData,
    );
  }
}
