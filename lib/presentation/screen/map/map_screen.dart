import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemap/domain/bloc/bloc_event.dart';
import 'package:googlemap/presentation/screen/map/viewmodel/map_bloc.dart';
import 'package:googlemap/presentation/screen/map/viewmodel/map_state.dart';

import '../../../domain/bloc/bloc_layout.dart';
import '../../../domain/model/place_data.dart';
import 'viewmodel/map_event.dart';

class MapScreen extends StatelessWidget {
  final PlaceData? placeData;
  final bool isRemove;

  const MapScreen({
    required this.placeData,
    required this.isRemove,
    super.key,
  });

  // 35.16861, lng: 129.05091
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(35.16861, 129.05091),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    final Set<Polygon> polygon = HashSet<Polygon>()
      ..add(Polygon(
        // given polygonId
        polygonId: const PolygonId('1'),
        // initialize the list of points to display polygon
        points: const [
          LatLng(19.0759837, 72.8776559),
          LatLng(28.679079, 77.069710),
          LatLng(19.0759837, 72.8776559),
        ],
        // given color to polygon
        fillColor: Colors.green.withOpacity(0.3),
        // given border color to polygon
        strokeColor: Colors.green,
        geodesic: true,
        // given width of border
        strokeWidth: 4,
      ));
    return BlocLayout<MapBloc, MapState>(
      create: (context) {
        return MapBloc(context, MapState());
      },
      builder: (context, bloc, state) {
        if (placeData != null && placeData != state.placeData) {
          bloc.add(BlocEvent(MapEvent.onPlaceData, extra: placeData));
        }
        return Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: bloc.initCameraPosition(),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: state.markers.toSet(),
              onMapCreated: (GoogleMapController controller) {
                bloc.setGoogleMapController(controller);
                bloc.controller = controller;
              },
              onTap: (value) {
                bloc.add(BlocEvent(MapEvent.onTapMap, extra: value));
              },
              polygons: state.polygonSet ?? const <Polygon>{},
              onCameraMove: (value) {
                  bloc.setCameraPosition(value);
              },
            ),
            if (placeData != null)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  title: Text(placeData!.name),
                  actions: [
                    IconButton(
                      onPressed: () {
                        bloc.add(BlocEvent(MapEvent.onTapRectangle, extra: true));
                      },
                      isSelected: state.isRectangleMode,
                      selectedIcon: const Icon(
                        Icons.rectangle,
                      ),
                      icon: Icon(
                        state.isRectangleMode ? Icons.rectangle_outlined : Icons.rectangle,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}
