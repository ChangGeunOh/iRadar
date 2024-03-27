import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemap/common/utils/extension.dart';
import 'package:googlemap/domain/bloc/bloc_bloc.dart';
import 'package:googlemap/domain/model/enum/wireless_type.dart';
import 'package:googlemap/domain/model/map/map_measured_data.dart';
import 'package:googlemap/domain/model/map_cursor_state.dart';
import 'package:googlemap/presentation/screen/map/viewmodel/map_event.dart';

import '../../../../domain/bloc/bloc_event.dart';
import '../../../../domain/model/map/area_data.dart';
import '../../../../domain/model/map/map_base_data.dart';
import '../../../../domain/model/map/map_data.dart';
import 'map_state.dart';

class MapBloc extends BlocBloc<BlocEvent<MapEvent>, MapState> {
  GoogleMapController? controller;
  List<BitmapDescriptor>? mapPins;
  BitmapDescriptor? basePinLTE;
  BitmapDescriptor? basePin5G;

  Set<Circle> circleSet = <Circle>{};

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
    await _makeMapPins();
    add(BlocEvent(MapEvent.onInit));
  }

  @override
  FutureOr<void> onBlocEvent(
    BlocEvent<MapEvent> event,
    Emitter<MapState> emit,
  ) async {
    switch (event.type) {
      case MapEvent.onInit:
        await _changedAreaData(emit, state.areaDataSet);
        break;
      case MapEvent.onMergeData:
        // final placeDataList = state.placeDataList;
        // final mergedPlaceData = event.extra as AreaData;
        //
        // // Transfer Data to Merged Data
        // emit(state.copyWith(isLoading: true));
        // await repository.saveMergedData(mergedPlaceData, placeDataList);
        // emit(state.copyWith(isLoading: false));
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
              polygonId: const PolygonId('1'),
              points: points,
              fillColor: Colors.green.withOpacity(0.3),
              strokeColor: Colors.green,
              geodesic: true,
              strokeWidth: 4,
            ));
          emit(state.copyWith(polygonSet: polygon));
        }
        break;
      case MapEvent.onMoveCursor:
        _onMoveCursor(event, emit);
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
      case MapEvent.onCameraIdle:
        // await _loadBaseData(emit, state);
        break;
      case MapEvent.onChangeWirelessType:
        emit(state.copyWith(wirelessType: event.extra));
        break;
      case MapEvent.onChangeAreaDataSet:
        emit(state.copyWith(areaDataSet: event.extra));
        await _changedAreaData(emit, event.extra);
        break;
    }
  }

  void _onMoveCursor(BlocEvent<MapEvent> event, Emitter<MapState> emit) {
    if (state.cursorState != MapCursorState.none) {
      final latLng = event.extra as LatLng;
      circleSet = {circleSet.first.copyWith(centerParam: latLng)};
      final double thresholdDistance = state.radius / 1000.0;
      final removePin = mapPins![11];
      final measureMarkerSet = state.measureMarkerSet.map((e) {
        final isWithinRadius =
            e.position.distanceTo(latLng) <= thresholdDistance;
        if (!isWithinRadius) return e;
        switch (state.cursorState) {
          case MapCursorState.remove:
            if (e.icon != removePin) return e.copyWith(iconParam: removePin);
            break;
          case MapCursorState.add:
            if (e.icon == removePin) {
              return e.copyWith(
                iconParam: getRsrp5Marker(
                  double.parse(e.infoWindow.snippet!.split("/").last),
                ),
              );
            }
            break;
          default:
            break;
        }
        return e;
      }).toSet();

      emit(
        state.copyWith(
          circleSet: circleSet,
          measureMarkerSet: measureMarkerSet,
        ),
      );
    }
  }

  Future<void> _changedAreaData(
    Emitter<MapState> emit,
    Set<AreaData> areaDataSet,
  ) async {
    await _moveCameraToAreaCenter(areaDataSet);
    if (areaDataSet.isEmpty) {
      return;
    }
    final Map<int, MapData> mapDataSet = {};
    final Set<Marker> mapBaseMarkerSet = {};
    final Set<Marker> measureMarkerSet = {};
    String? message;

    emit(state.copyWith(isLoading: true));
    for (var areaData in areaDataSet) {
      final responseData = await repository.getMapDataList(areaData.idx);
      if (responseData.data != null) {
        final data = responseData.data!;
        mapDataSet[areaData.idx] = data;
        final mapBaseMarkers = _getMapBaseMarkers(
          areaData.idx,
          data.baseData,
        );
        mapBaseMarkerSet.addAll(mapBaseMarkers);
        final measureMarkers = _getMeasureMarkers(
          areaData.idx,
          data.measuredData,
        );
        measureMarkerSet.addAll(measureMarkers);
      }
      message = responseData.meta.message.isNotEmpty
          ? responseData.meta.message
          : message;
    }
    emit(state.copyWith(
      isLoading: false,
      areaDataSet: areaDataSet,
      mapDataSet: mapDataSet,
      mapBaseMarkerSet: mapBaseMarkerSet,
      measureMarkerSet: measureMarkerSet,
      message: message,
    ));
  }

  Future<void> _moveCameraToAreaCenter(Set<AreaData> areaDataSet) async {
    var latitude = areaDataSet.fold(
            0.0, (previousValue, element) => previousValue + element.latitude) /
        areaDataSet.length;
    var longitude = areaDataSet.fold(0.0,
            (previousValue, element) => previousValue + element.longitude) /
        areaDataSet.length;
    // Move Camera
    if (controller == null && repository.getGoogleMapController() != null) {
      controller = repository.getGoogleMapController();
      await Future.delayed(const Duration(milliseconds: 300));
    }
    controller?.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(
          latitude,
          longitude,
        ),
      ),
    );
  }

  BitmapDescriptor getRsrp5Marker(double rsrp5) {
    List<double> rsrpThresholds = [-120, -110, -100, -90, -80, -70];
    List<int> pinIndices = [0, 1, 2, 4, 7, 8, 10];

    for (int i = 0; i < rsrpThresholds.length; i++) {
      if (rsrp5 >= rsrpThresholds[i]) {
        return mapPins![pinIndices[i]];
      }
    }

    return mapPins![pinIndices.last];
  }

  void setCameraPosition(CameraPosition value) {
    repository.setCameraPosition(value);
  }

  Set<Marker> _getMeasureMarkers(
    int idx,
    List<MapMeasuredData> measureList,
  ) {
    var markers = repository.getMeasureMarkers(idx);
    markers = measureList
        .map(
          (e) => Marker(
            markerId: MarkerId('M${e.idx}'),
            icon: getRsrp5Marker(e.rsrp5),
            position: LatLng(e.latitude, e.longitude),
            infoWindow: InfoWindow(snippet: "${e.pci5}/${e.rsrp5}"),
          ),
        )
        .toSet();

    return markers;
  }

  Set<Marker> _getMapBaseMarkers(int idx, List<MapBaseData> mapBaseDataSet) {
    var markers = repository.getBaseMarkers(idx);
    if (markers == null) {
      markers = mapBaseDataSet
          .map(
            (e) => Marker(
              markerId: MarkerId('BASE${e.idx}'),
              position: LatLng(e.latitude, e.longitude),
              icon: e.type == WirelessType.wLte ? basePinLTE! : basePin5G!,
              infoWindow: InfoWindow(snippet: e.name),
            ),
          )
          .toSet();
      repository.setBaseMarkers(idx, markers);
    }
    return markers.toSet();
  }

  Future<void> _makeMapPins() async {
    final filenames = List.generate(
        12, (index) => 'assets/icons/pin$index.${index < 2 ? 'png' : 'jpg'}');
    mapPins = await Future.wait(filenames.map((e) async {
      final image = await rootBundle.load(e);
      final bytes = image.buffer.asUint8List();
      return BitmapDescriptor.fromBytes(bytes);
    }).toList());

    var image = await rootBundle.load('assets/icons/pin_base_lte.png');
    basePinLTE = BitmapDescriptor.fromBytes(image.buffer.asUint8List());
    image = await rootBundle.load('assets/icons/pin_base_5g.png');
    basePin5G = BitmapDescriptor.fromBytes(image.buffer.asUint8List());

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
}
