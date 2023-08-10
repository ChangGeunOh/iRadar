import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemap/common/utils/extension.dart';
import 'package:googlemap/domain/bloc/bloc_bloc.dart';
import 'package:googlemap/domain/model/map_cursor_state.dart';
import 'package:googlemap/domain/model/measure_data.dart';
import 'package:googlemap/domain/model/place_data.dart';
import 'package:googlemap/presentation/screen/map/viewmodel/map_event.dart';

import '../../../../domain/bloc/bloc_event.dart';
import '../../../../domain/model/base_data.dart';
import '../../../../domain/model/map_data.dart';
import 'map_state.dart';

class MapBloc extends BlocBloc<BlocEvent<MapEvent>, MapState> {
  GoogleMapController? controller;
  List<BitmapDescriptor>? mapPins;
  BitmapDescriptor? basePin;
  final Set<Circle> circleSet = HashSet<Circle>();

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
        12, (index) => 'assets/icons/pin$index.${index < 2 ? 'png' : 'jpg'}');
    mapPins = await Future.wait(filenames.map((e) async {
      final image = await rootBundle.load(e);
      final bytes = image.buffer.asUint8List();
      return BitmapDescriptor.fromBytes(bytes);
    }).toList());

    final image = await rootBundle.load('assets/icons/pin_base.png');
    final bytes = image.buffer.asUint8List();
    basePin = BitmapDescriptor.fromBytes(bytes);

    circleSet.add(
      Circle(
        visible: false,
        circleId: const CircleId('mouse_point'),
        radius: state.radius,
        strokeWidth: 0,
        fillColor: const Color(0x80ff0000),
      ),
    );
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
          if (basePin == null) {
            await Future.delayed(const Duration(milliseconds: 100));
          }
          final baseMarkers = _getBaseMarkers(event.extra, mapData.baseList);
          final measureMarkers =
              _getMeasureMarkers(event.extra, mapData.measureList);

          emit(
            state.copyWith(
              baseMarkers: baseMarkers,
              measureMarkers: measureMarkers,
            ),
          );
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
      case MapEvent.onMoveCursor:
        if (state.cursorState != MapCursorState.none) {
          final latLng = event.extra as LatLng;
          final circle = circleSet.first.copyWith(
            centerParam: latLng,
          );
          circleSet.clear();
          circleSet.add(circle);

          final markerList = state.measureMarkers.map((e) {
            if (e.position.distanceTo(latLng) <= state.radius / 1000.0) {
              if ((state.cursorState == MapCursorState.remove) &&
                  e.icon != mapPins![11]) {
                return e.copyWith(iconParam: mapPins![11]);
              }
              if ((state.cursorState == MapCursorState.add) &&
                  e.icon == mapPins![11]) {
                return e.copyWith(
                    iconParam: getRsrp5Marker(
                        double.parse(e.infoWindow.snippet!.split("/").last)));
              }
            }
            return e;
          });

          emit(
            state.copyWith(
              circleSet: circleSet,
              measureMarkers: markerList.toList(),
            ),
          );
        }
        break;
      case MapEvent.onChangeRadius:
        final circle = circleSet.first.copyWith(
          radiusParam: event.extra,
        );
        circleSet.clear();
        circleSet.add(circle);

        emit(
          state.copyWith(
            radius: event.extra,
            circleSet: circleSet,
          ),
        );

        break;
      case MapEvent.onChangeCursorState:
        final fillColor = event.extra == MapCursorState.remove
            ? Colors.red.withOpacity(0.5)
            : Colors.blue.withOpacity(0.5);

        final circle = circleSet.first.copyWith(
          fillColorParam: fillColor,
          visibleParam: event.extra != MapCursorState.none,
        );
        circleSet.clear();
        circleSet.add(circle);

        emit(state.copyWith(cursorState: event.extra, circleSet: circleSet));
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

  List<Marker> _getMeasureMarkers(
    PlaceData placeData,
    List<MeasureData> measureList,
  ) {
    var markers = repository.getMeasureMarkers(placeData);
    if (markers == null) {
      markers = List<Marker>.empty(growable: true);
      markers += measureList
          .map(
            (e) => Marker(
              markerId: MarkerId('M${e.idx}'),
              icon: getRsrp5Marker(e.rsrp5),
              position: LatLng(e.latitude, e.longitude),
              infoWindow: InfoWindow(snippet: "${e.pci5}/${e.rsrp5}"),
            ),
          )
          .toList();

      repository.setMeasureMarkers(placeData, markers);
    }
    return markers;
  }

  List<Marker> _getBaseMarkers(
    PlaceData placeData,
    List<BaseData> baseList,
  ) {
    var markers = repository.getBaseMarkers(placeData);
    if (markers == null) {
      markers = List<Marker>.empty(growable: true);
      markers += baseList
          .map(
            (e) => Marker(
              markerId: MarkerId('B${e.idx}'),
              position: LatLng(e.latitude, e.longitude),
              icon: basePin!,
              infoWindow: InfoWindow(snippet: e.rnm),
            ),
          )
          .toList();

      repository.setBaseMarkers(placeData, markers);
    }
    return markers;
  }
}
