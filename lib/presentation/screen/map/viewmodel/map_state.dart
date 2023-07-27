import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../domain/model/map_data.dart';
import '../../../../domain/model/place_data.dart';

class MapState {
  final PlaceData? placeData;
  final MapData? mapData;
  final List<Marker> markers;
  final bool isRectangleMode; // onTapRectangle
  final Set<Polygon>? polygonSet;

  MapState({
    this.mapData,
    this.placeData,
    bool? isRectangleMode,
    this.polygonSet,
    List<Marker>? markers,
  })  : markers = markers ?? List.empty(),
        isRectangleMode = isRectangleMode ?? false;

  MapState copyWith({
    MapData? mapData,
    PlaceData? placeData,
    bool? isRectangleMode,
    Set<Polygon>? polygonSet,
    List<Marker>? markers,
  }) {
    return MapState(
      mapData: mapData ?? this.mapData,
      placeData: placeData ?? this.placeData,
      isRectangleMode: isRectangleMode ?? this.isRectangleMode,
      polygonSet: polygonSet ?? this.polygonSet,
      markers: markers ?? this.markers,
    );
  }

}
