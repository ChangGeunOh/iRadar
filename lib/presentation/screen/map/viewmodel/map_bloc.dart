import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemap/domain/bloc/bloc_bloc.dart';
import 'package:googlemap/domain/model/place_data.dart';
import 'package:googlemap/presentation/screen/map/viewmodel/map_event.dart';

import '../../../../domain/bloc/bloc_event.dart';
import '../../../../domain/model/map_data.dart';
import 'map_state.dart';

class MapBloc extends BlocBloc<BlocEvent<MapEvent>, MapState> {
  GoogleMapController? controller;
  List<BitmapDescriptor>? mapPins;
  BitmapDescriptor? basePin;

  CameraPosition initCameraPosition() {
    return repository.getCameraPosition();
  }

  MapBloc(super.context, super.initialState) {
    _init();
  }

  void setGoogleMapController(GoogleMapController controller) {
    this.controller = controller;
    repository.setGoogleMapController(controller);
  }

  Future<void> _init() async {
    final filenames = List.generate(
        11, (index) => 'icons/pin$index.${index < 2 ? 'png' : 'jpg'}');
    mapPins = await Future.wait(filenames.map((e) async {
      final image = await rootBundle.load(e);
      final bytes = image.buffer.asUint8List();
      return BitmapDescriptor.fromBytes(bytes);
    }).toList());

    final image = await rootBundle.load('icons/pin_base.png');
    final bytes = image.buffer.asUint8List();
    basePin = BitmapDescriptor.fromBytes(bytes);
  }

  @override
  FutureOr<void> onBlocEvent(
    BlocEvent<MapEvent> event,
    Emitter<MapState> emit,
  ) async {
    switch (event.type) {
      case MapEvent.init:
        break;
      case MapEvent.onPlaceData:
        emit(state.copyWith(placeData: event.extra));

        final mapData = await repository.loadMapData(event.extra);
        emit(state.copyWith(mapData: mapData));

        if (mapData != null) {
          // 지도 이동
          final measureData = mapData.measureList.first;
          if (controller == null &&
              repository.getGoogleMapController() != null) {
            controller = repository.getGoogleMapController();
            await Future.delayed(const Duration(milliseconds: 300));
          }

          controller?.animateCamera(
            CameraUpdate.newLatLng(
              LatLng(
                measureData.latitude,
                measureData.longitude,
              ),
            ),
          );

          final markers = _getMarkers(event.extra, mapData);
          emit(state.copyWith(markers: markers));
        }
        break;
      case MapEvent.onTapRectangle:
        if (event.extra) {
          await Future.delayed(const Duration(milliseconds: 200));
          emit(state.copyWith(isRectangleMode: !state.isRectangleMode));
        } else {
          emit(state.copyWith(polygonSet: null));
        }
        print(state.isRectangleMode);
        break;
      case MapEvent.onTapMap:
        if (state.isRectangleMode) {
          final latLng = event.extra as LatLng;
          var points = state.polygonSet?.first.points ??
              List<LatLng>.empty(growable: true);
          points =
              points.length > 2 ? List<LatLng>.empty(growable: true) : points;
          if (points.isEmpty) {
            points.add(latLng);
            points.add(latLng);
          } else {
            final firstLatLng = points.first;
            points.add(LatLng(latLng.latitude, firstLatLng.longitude));
            points.add(latLng);
            points.add(LatLng(firstLatLng.latitude, latLng.longitude));
          }
          final Set<Polygon> polygon = HashSet<Polygon>()
            ..add(Polygon(
              // given polygonId
              polygonId: const PolygonId('1'),
              // initialize the list of points to display polygon
              points: points,
              // given color to polygon
              fillColor: Colors.green.withOpacity(0.3),
              // given border color to polygon
              strokeColor: Colors.green,
              geodesic: true,
              // given width of border
              strokeWidth: 4,
            ));
          emit(state.copyWith(polygonSet: polygon));
        }
        break;
    }
  }

  // final rsrpList = [-999999, -120, -110, -100, -90, -80, -70, -60];
  BitmapDescriptor getRsrp5Marker(double rsrp5) {
    print('MapPin>$rsrp5');
    // final index = rsrpList.lastIndexWhere((element) => rsrp5 > element);
    final index = rsrp5 < -120
        ? 0
        : rsrp5 < -110
            ? 1
            : rsrp5 < -100
                ? 2
                : rsrp5 < -90
                    ? 4
                    : rsrp5 < -80
                        ? 7
                        : rsrp5 < -70
                            ? 8
                            : 10;
    print('MapPin>$rsrp5 :: $index');
    return mapPins![index];
  }

  void setCameraPosition(CameraPosition value) {
    repository.setCameraPosition(value);
  }

  List<Marker> _getMarkers(PlaceData placeData, MapData mapData) {
    var markers = repository.getMakers(placeData);
    if (markers == null) {
      markers = List<Marker>.empty(growable: true);
      markers += mapData.measureList
          .map(
            (e) => Marker(
              markerId: MarkerId('M${e.idx}'),
              icon: getRsrp5Marker(e.rsrp5),
              position: LatLng(e.latitude, e.longitude),
              infoWindow: InfoWindow(snippet: "${e.pci5}/${e.rsrp5}"),
            ),
          )
          .toList();

      markers += mapData.baseList
          .map(
            (e) => Marker(
              markerId: MarkerId('B${e.idx}'),
              position: LatLng(e.latitude, e.longitude),
              icon: basePin!,
              infoWindow: InfoWindow(snippet: e.rnm),
            ),
          )
          .toList();
      repository.setMarkers(placeData, markers);
    }
    return markers;
  }
}

/*

if(-120 > $RD[rp5]) {
	$imgD = "../img/p120.png";
} elseif(-120 <= $RD[rp5] && -110 > $RD[rp5]) {
	$imgD = "../img/p110.png";
} elseif(-110 <= $RD[rp5] && -100 > $RD[rp5]) {
	$imgD = "../img/sp1.jpg";
} elseif(-100 <= $RD[rp5] && -90 > $RD[rp5]) {
	$imgD = "../img/sp3.jpg";
} elseif(-90 <= $RD[rp5] && -80 > $RD[rp5]) {
	$imgD = "../img/sp6.jpg";
} elseif(-80 <= $RD[rp5] && -70 > $RD[rp5]) {
	$imgD = "../img/sp7.jpg";
} else {
	$imgD = "../img/sp9.jpg";
}



 */
