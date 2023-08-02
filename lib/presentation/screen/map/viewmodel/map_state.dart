import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../domain/model/map_cursor_state.dart';
import '../../../../domain/model/map_data.dart';
import '../../../../domain/model/place_data.dart';

class MapState {
  final PlaceData? placeData;
  final MapData? mapData;
  final List<Marker> baseMarkers;
  final List<Marker> measureMarkers;
  final bool isRectangleMode; // onTapRectangle
  final Set<Polygon>? polygonSet;
  final Set<Circle>? circleSet;
  final double radius;
  final MapCursorState cursorState;

  MapState({
    this.mapData,
    this.placeData,
    bool? isRectangleMode,
    this.polygonSet,
    List<Marker>? baseMarkers,
    List<Marker>? measureMarkers,
    this.circleSet,
    double? radius,
    MapCursorState? cursorState,
  })  : baseMarkers = baseMarkers ?? List.empty(),
        measureMarkers = measureMarkers ?? List.empty(),
        radius = radius ?? 20,
        cursorState = cursorState ?? MapCursorState.none,
        isRectangleMode = isRectangleMode ?? false;

  MapState copyWith({
    MapData? mapData,
    PlaceData? placeData,
    bool? isRectangleMode,
    Set<Polygon>? polygonSet,
    List<Marker>? baseMarkers,
    List<Marker>? measureMarkers,
    Set<Circle>? circleSet,
    double? radius,
    MapCursorState? cursorState,
  }) {
    return MapState(
      mapData: mapData ?? this.mapData,
      placeData: placeData ?? this.placeData,
      isRectangleMode: isRectangleMode ?? this.isRectangleMode,
      polygonSet: polygonSet ?? this.polygonSet,
      baseMarkers: baseMarkers ?? this.baseMarkers,
      measureMarkers: measureMarkers ?? this.measureMarkers,
      circleSet: circleSet ?? this.circleSet,
      radius: radius ?? this.radius,
      cursorState: cursorState ?? this.cursorState,
    );
  }
}
