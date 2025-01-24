import 'dart:async';
import 'dart:collection';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemap/common/utils/extension.dart';
import 'package:googlemap/domain/bloc/bloc_bloc.dart';
import 'package:googlemap/domain/model/enum/location_type.dart';
import 'package:googlemap/domain/model/enum/wireless_type.dart';
import 'package:googlemap/domain/model/map/map_measured_data.dart';
import 'package:googlemap/domain/model/map/merge_data.dart';
import 'package:googlemap/domain/model/map_cursor_state.dart';
import 'package:googlemap/presentation/screen/map/viewmodel/map_event.dart';
import 'dart:ui' as ui;

import '../../../../domain/bloc/bloc_event.dart';
import '../../../../domain/model/base/base_data.dart';
import '../../../../domain/model/map/area_data.dart';
import '../../../../domain/model/map/map_base_data.dart';

import 'map_state.dart';

class MapBloc extends BlocBloc<BlocEvent<MapEvent>, MapState> {
  GoogleMapController? controller;
  List<BitmapDescriptor>? mapPins;
  BitmapDescriptor? basePinLTE;
  BitmapDescriptor? basePin5G;
  BitmapDescriptor? baseRelay;

  Set<Circle> circleSet = <Circle>{};

  final List<double> rsrpThresholds = [-120, -110, -100, -90, -80, -70];
  final List<int> pinIndices = [0, 1, 2, 4, 7, 8, 10];
  final filenames = List.generate(
    12,
    (index) => 'assets/icons/pin$index.jpg',
    growable: false,
  );

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
        await _changedAreaData(
          emit,
          state.areaDataSet,
          state.wirelessType,
        );
        break;
      case MapEvent.onMergeData:
        Map<String, dynamic> data = event.extra as Map<String, dynamic>;
        final name = data['name'] as String;
        final locationType = data['locationType'] as LocationType;
        final measuredAt = data['measuredAt'];
        showLoadingDialog();
        await _onMergeData(
          emit,
          wirelessType: state.wirelessType,
          name: name,
          measuredAt: measuredAt,
          locationType: locationType,
        );
        if (context.mounted) {
          context.pop();
        }
        break;
      case MapEvent.onTapMap:
        if (state.isRectangleMode) {
          final latLng = event.extra as LatLng;
          var points = state.polygonSet.first.points;
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
        _onChangeCursorState(event, emit);
        break;
      case MapEvent.onCameraIdle:
        if (!state.isShowBase) return;
        final movedBounds = await controller!.getVisibleRegion();
        final newBounds = _getLatLngBounds(state.latLngBounds, movedBounds);
        if (newBounds != state.latLngBounds) {
          final otherBaseMarkets = await _loadBaseList(movedBounds);
          emit(state.copyWith(
            otherBaseMarkerSet: otherBaseMarkets,
            latLngBounds: newBounds,
          ));
        }
        break;
      case MapEvent.onChangeWirelessType:
        emit(state.copyWith(
          wirelessType: event.extra,
          latLngBounds: LatLngBounds(
            southwest: const LatLng(0, 0),
            northeast: const LatLng(0, 0),
          ),
          otherBaseMarkerSet: const {},
        ));
        break;
      case MapEvent.onChangeAreaDataSet:
        emit(state.copyWith(areaDataSet: event.extra));
        await _changedAreaData(
          emit,
          event.extra,
          state.wirelessType,
        );
        break;
      case MapEvent.onMessage:
        emit(state.copyWith(message: event.extra));
        break;
      case MapEvent.onShowDialog:
        emit(state.copyWith(showingDialog: event.extra));
        break;
      case MapEvent.onShowBase:
        emit(state.copyWith(isLoading: true));
        final isShowBase = !state.isShowBase;
        Set<Marker> otherBaseMarkerSet = state.otherBaseMarkerSet;

        final movedBounds = await controller!.getVisibleRegion();
        final latLngBounds = _getLatLngBounds(
          state.latLngBounds,
          movedBounds,
        );
        if (latLngBounds != state.latLngBounds) {
          otherBaseMarkerSet =
              await _loadBaseList(latLngBounds) ?? otherBaseMarkerSet;
        }
        final toggleOtherBaseMarkerSet = otherBaseMarkerSet.map((e) {
          return e.copyWith(visibleParam: isShowBase);
        }).toSet();

        emit(state.copyWith(
          isShowBase: isShowBase,
          latLngBounds: latLngBounds,
          otherBaseMarkerSet: toggleOtherBaseMarkerSet,
          isLoading: false,
        ));
        break;
      case MapEvent.onShowCaption:
        final isShowCaption = !state.isShowCaption;
        emit(state.copyWith(isLoading: true));
        Set<Marker> mapBaseMarkerSet = {};
        for (var areaData in state.areaDataSet) {
          final responseData = await repository.getMapData(
            state.wirelessType,
            areaData.idx,
          );
          if (responseData.data != null) {
            final data = responseData.data!;
            mapBaseMarkerSet = await _getBaseMarkers(
              idx: areaData.idx,
              mapBaseDataSet: data.baseData,
              type: state.wirelessType,
              isLabelEnabled: isShowCaption,
            );
            // if (isShowCaption) {
            //   // mapBaseMarkerSet = await _getMapBaseMarkers(
            //   //   areaData.idx,
            //   //   data.baseData,
            //   //   state.wirelessType,
            //   // );
            //   mapBaseMarkerSet = await _getBaseMarkers(
            //     idx: areaData.idx,
            //     mapBaseDataSet: data.baseData,
            //     type: state.wirelessType,
            //     isLabelEnabled: true,
            //   );
            // } else {
            //   // mapBaseMarkerSet = await _getNoLabelMapBaseMarkers(
            //   //   areaData.idx,
            //   //   data.baseData,
            //   //   state.wirelessType,
            //   // );
            //   mapBaseMarkerSet = await _getBaseMarkers(
            //     idx: areaData.idx,
            //     mapBaseDataSet: data.baseData,
            //     type: state.wirelessType,
            //     isLabelEnabled: false,
            //   );
            // }
          }
          emit(state.copyWith(
            isLoading: false,
            mapBaseMarkerSet: mapBaseMarkerSet,
            isShowCaption: isShowCaption,
          ));
          break;
        }
    }
  }

  LatLngBounds _getLatLngBounds(
    LatLngBounds? currentBounds,
    LatLngBounds movedBounds,
  ) {
    if (currentBounds == null) {
      return movedBounds;
    } else {
      final newSouthWestLongitude =
          currentBounds.southwest.longitude < movedBounds.southwest.longitude
              ? currentBounds.southwest.longitude
              : movedBounds.southwest.longitude;
      final newSouthWestLatitude =
          currentBounds.southwest.latitude < movedBounds.southwest.latitude
              ? currentBounds.southwest.latitude
              : movedBounds.southwest.latitude;
      final newNorthEastLongitude =
          currentBounds.northeast.longitude > movedBounds.northeast.longitude
              ? currentBounds.northeast.longitude
              : movedBounds.northeast.longitude;
      final newNorthEastLatitude =
          currentBounds.northeast.latitude > movedBounds.northeast.latitude
              ? currentBounds.northeast.latitude
              : movedBounds.northeast.latitude;
      final newBounds = LatLngBounds(
        southwest: LatLng(newSouthWestLatitude, newSouthWestLongitude),
        northeast: LatLng(newNorthEastLatitude, newNorthEastLongitude),
      );
      return newBounds;
    }
  }

  Future<Set<Marker>?> _loadBaseList(
    LatLngBounds latLngBounds,
  ) async {
    final response = await repository.getBaseList(
      state.wirelessType,
      latLngBounds,
    );
    if (response.data == null) return null;
    final baseList = response.data! as List<BaseData>;
    final Set<Marker> markers = {};

    for (int index = 0; index < baseList.length; index++) {
      final e = baseList[index];
      final iconImage = e.type == '5G'
          ? basePin5G!
          : e.isRelay
          ? baseRelay!
          : basePinLTE!;

      markers.add(
        Marker(
          markerId: MarkerId('OTHER_BASE${e.code}'),
          position: LatLng(e.latitude, e.longitude),
          icon: iconImage,
          infoWindow: InfoWindow(
            title: "${e.code} (${e.pci})",
            snippet: e.rnm,
          ),
        ),
      );
    }
    return markers;
  }

  void _onChangeCursorState(BlocEvent<MapEvent> event, Emitter<MapState> emit) {
    switch (event.extra) {
      case MapCursorState.add:
        emit(state.copyWith(
          cursorState: MapCursorState.add,
          circleSet: _getCircle(MapCursorState.add),
        ));
      case MapCursorState.remove:
        emit(state.copyWith(
          cursorState: MapCursorState.remove,
          circleSet: _getCircle(MapCursorState.remove),
        ));
        break;
      case MapCursorState.removeAll:
        final mapPinSet = state.measureMarkerSet.map((e) {
          return e.copyWith(iconParam: mapPins![11]);
        }).toSet();
        emit(state.copyWith(
          measureMarkerSet: mapPinSet,
        ));
      case MapCursorState.addAll:
        final mapPinSet = state.measureMarkerSet.map((e) {
          return e.copyWith(
            iconParam: getRsrpMarker(
              double.parse(e.infoWindow.snippet!.split("/").last),
            ),
          );
        }).toSet();
        emit(state.copyWith(
          measureMarkerSet: mapPinSet,
        ));
      default:
        emit(state.copyWith(
          circleSet: _getCircle(MapCursorState.none),
          cursorState: MapCursorState.none,
        ));
        break;
    }
  }

  Set<Circle> _getCircle(
    MapCursorState mapCursorState,
  ) {
    final fillColor = mapCursorState == MapCursorState.remove
        ? Colors.red.withOpacity(0.5)
        : Colors.blue.withOpacity(0.5);

    final circle = circleSet.first.copyWith(
      fillColorParam: fillColor,
      visibleParam: mapCursorState != MapCursorState.none,
    );
    circleSet.clear();
    circleSet.add(circle);
    return circleSet;
  }

  void _onMoveCursor(
    BlocEvent<MapEvent> event,
    Emitter<MapState> emit,
  ) {
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
                iconParam: getRsrpMarker(
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

  Future<void> showLoadingDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Dialog(
          backgroundColor: Colors.transparent,
          child: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Future<void> _changedAreaData(
    Emitter<MapState> emit,
    Set<AreaData> areaDataSet,
    WirelessType type,
  ) async {
    await _moveCameraToAreaCenter(areaDataSet);
    if (areaDataSet.isEmpty) {
      return;
    }
    Set<Marker> mapBaseMarkerSet = {};
    Set<Marker> measureMarkerSet = {};
    String message = '';
    emit(state.copyWith(isLoading: true));

    for (var areaData in areaDataSet) {
      final responseData = await repository.getMapData(type, areaData.idx);

      if (responseData.data != null) {
        final data = responseData.data!;
        // final mapBaseMarkers = await _getMapBaseMarkers(
        //   areaData.idx,
        //   data.baseData,
        //   state.wirelessType,
        // );
        final mapBaseMarkers = await _getBaseMarkers(
          idx: areaData.idx,
          mapBaseDataSet: data.baseData,
          type: state.wirelessType,
          isLabelEnabled: state.isShowCaption,
        );
        mapBaseMarkerSet.addAll(mapBaseMarkers);
        final measureMarkers = await _getMeasureMarkers(
          state.wirelessType,
          areaData.idx,
          data.measuredData,
        );
        measureMarkerSet.addAll(measureMarkers);
      }
    }
    emit(state.copyWith(
      isLoading: false,
      areaDataSet: areaDataSet,
      mapBaseMarkerSet: mapBaseMarkerSet,
      measureMarkerSet: measureMarkerSet,
      message: message,
    ));
  }

  Future<void> _moveCameraToAreaCenter(Set<AreaData> areaDataSet) async {
    if (areaDataSet.isEmpty) return;
    var latitude = areaDataSet.fold(0.0,
            (previousValue, element) => previousValue + element.latitude!) /
        areaDataSet.length;
    var longitude = areaDataSet.fold(0.0,
            (previousValue, element) => previousValue + element.longitude!) /
        areaDataSet.length;
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

  BitmapDescriptor getRsrpMarker(double rsrp) {
    for (int i = 0; i < rsrpThresholds.length; i++) {
      if (rsrp <= rsrpThresholds[i]) {
        return mapPins![pinIndices[i]];
      }
    }
    return mapPins![pinIndices.last];
  }

  void setCameraPosition(CameraPosition value) {
    repository.setCameraPosition(value);
  }

  Future<Set<Marker>> _getMeasureMarkers(
    WirelessType type,
    int idx,
    List<MapMeasuredData> measureList,
  ) async {
    var markers = repository.getMeasureMarkers(idx, type);
    if (markers != null) {
      return markers;
    }
    markers = {};
    for (var measure in measureList) {
      final icon = await makeMeasureMarkerWithPCI(
        measure.pci.toString(),
        createMeasureImagePath(measure.rsrp),
      );
      markers.add(
        Marker(
          markerId: MarkerId('M${measure.idx}'),
          icon: icon,
          position: LatLng(measure.latitude, measure.longitude),
          infoWindow: InfoWindow(
            title: measure.idx.toString(),
            snippet: "${measure.pci}/${measure.rsrp}",
          ),
        ),
      );
    }
    // markers = measureList.map(
    //   (e) async {
    //     final icon = await makeMeasureMarkerWithPCI(e.pci.toString(), e.rsrp);
    //     return Marker(
    //       markerId: MarkerId('M${e.idx}'),
    //       // icon: getRsrpMarker(e.rsrp),
    //       icon: icon,
    //       position: LatLng(e.latitude, e.longitude),
    //       infoWindow: InfoWindow(snippet: "${e.pci}/${e.rsrp}"),
    //     );
    //   },
    // ).toSet();

    return markers;
  }

  Future<Set<Marker>> _getBaseMarkers({
    required int idx,
    required List<MapBaseData> mapBaseDataSet,
    required WirelessType type,
    bool isLabelEnabled = true,
  }) async {
    Set<Marker>? markers = isLabelEnabled
        ? repository.getBaseMarkers(idx, type)
        : repository.getNoLabelBaseMarkers(idx, type);

    if (markers != null) {
      return markers;
    }

    markers = {};
    Map<double, MapBaseData> latBaseMap = {};

    if (isLabelEnabled) {
      for (var mapBaseData in mapBaseDataSet) {
        if (latBaseMap.containsKey(mapBaseData.latitude)) {
          var baseData = latBaseMap[mapBaseData.latitude];
          baseData = baseData!.copyWith(
              name:
                  '${baseData.name}\n(${mapBaseData.pci}) ${mapBaseData.name}');
          latBaseMap[mapBaseData.latitude] = baseData;
        } else {
          latBaseMap[mapBaseData.latitude] = mapBaseData.copyWith(
              name: "(${mapBaseData.pci}) ${mapBaseData.name}");
        }
      }
    } else {
      for (var mapBaseData in mapBaseDataSet) {
        latBaseMap[mapBaseData.latitude] = mapBaseData;
      }
    }

    for (var mapBaseData in latBaseMap.values) {
      var markerIcon = await _createCustomMarker(
        mapBaseData.iconPath(type),
        mapBaseData.name,
        isCaption: isLabelEnabled,
      );

      markers.add(Marker(
        markerId: MarkerId('BASE${mapBaseData.code}'),
        position: LatLng(mapBaseData.latitude, mapBaseData.longitude),
        icon: markerIcon,
        infoWindow: InfoWindow(
          title: "${mapBaseData.code} (${mapBaseData.pci})",
          snippet: mapBaseData.name,
        ),
      ));
    }

    // 중계기기 RS/RB/RE 앞 2자리로 주로 구분됨

    if (isLabelEnabled) {
      repository.setBaseMarkers(idx, markers, type);
    } else {
      repository.setNoLabelBaseMarkers(idx, markers, type);
    }

    return markers;
  }

  Future<Set<Marker>> _getMapBaseMarkers(
    int idx,
    List<MapBaseData> mapBaseDataSet,
    WirelessType type,
  ) {
    return _getBaseMarkers(
      idx: idx,
      mapBaseDataSet: mapBaseDataSet,
      type: type,
      isLabelEnabled: true,
    );
  }

  Future<Set<Marker>> _getNoLabelMapBaseMarkers(
    int idx,
    List<MapBaseData> mapBaseDataSet,
    WirelessType type,
  ) {
    return _getBaseMarkers(
      idx: idx,
      mapBaseDataSet: mapBaseDataSet,
      type: type,
      isLabelEnabled: false,
    );
  }

  Future<void> _makeMapPins() async {
    final filenames = List.generate(12, (index) => 'assets/icons/pin$index.jpg',
        growable: false);
    mapPins = await Future.wait(filenames.map((e) async {
      final image = await rootBundle.load(e);
      final bytes = image.buffer.asUint8List();
      return BitmapDescriptor.bytes(bytes);
    }).toList());

    var image = await rootBundle.load('assets/icons/pin_base_lte.png');
    basePinLTE = BitmapDescriptor.bytes(image.buffer.asUint8List());
    image = await rootBundle.load('assets/icons/pin_base_5g.png');
    basePin5G = BitmapDescriptor.bytes(image.buffer.asUint8List());
    image = await rootBundle.load('assets/icons/pin_base_relay.png');
    baseRelay = BitmapDescriptor.bytes(image.buffer.asUint8List());

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

  String createMeasureImagePath(double rsrp) {
    final index = rsrpThresholds.indexWhere((threshold) => rsrp <= threshold);
    final pinIndex = (index != -1) ? pinIndices[index] : pinIndices.last;
    return filenames[pinIndex];
  }

  Future<BitmapDescriptor> makeMeasureMarkerWithPCI(
    String pci,
    String iconPath,
  ) async {
    if (repository.getCustomMeasureMarker(pci, iconPath) != null) {
      return repository.getCustomMeasureMarker(pci, iconPath)!;
    }

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const size = Size(30, 30); // 마커 크기 설정

    // 로컬 이미지 불러오기
    final ByteData data = await rootBundle.load(iconPath);
    final Uint8List bytes = data.buffer.asUint8List();
    final ui.Codec codec =
        await ui.instantiateImageCodec(bytes, targetWidth: 10);
    final ui.FrameInfo frameInfo = await codec.getNextFrame();

    // 캔버스에 이미지 그리기
    final paint = Paint();
    canvas.drawImage(frameInfo.image, Offset(size.width / 2 - 5, 0), paint);

    // PCI 텍스트 추가
    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: 12,
      fontWeight: FontWeight.w500,
    );
    final textPainter = TextPainter(
      text: TextSpan(text: pci, style: textStyle),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset((size.width - textPainter.width) / 2, size.height - 13),
    );

    // 캔버스 내용을 Bitmap으로 변환
    final picture = recorder.endRecording();
    final img = await picture.toImage(size.width.toInt(), size.height.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List markerBytes = byteData!.buffer.asUint8List();

    final bitmapDescriptor = BitmapDescriptor.bytes(markerBytes);
    repository.setCustomMeasureMarker(pci, iconPath, bitmapDescriptor);
    return bitmapDescriptor;
  }

  Future<void> _onMergeData(
    Emitter<MapState> emit, {
    required WirelessType wirelessType,
    required String name,
    required DateTime measuredAt,
    required LocationType locationType,
  }) async {
    final selectedMarkers = state.measureMarkerSet
        .where((element) => element.icon != mapPins![11])
        .toList();

    double sumLat = 0.0;
    double sumLong = 0.0;
    List<int> data = [];
    for (var marker in selectedMarkers) {
      sumLat += marker.position.latitude;
      sumLong += marker.position.longitude;
      data.add(int.parse(marker.markerId.value.split('M').last));
    }

    final latitude = sumLat / selectedMarkers.length;
    final longitude = sumLong / selectedMarkers.length;

    final mergeData = MergeData(
      name: name,
      wirelessType: wirelessType,
      locationType: locationType,
      latitude: latitude,
      longitude: longitude,
      data: data,
      measuredAt: measuredAt,
    );

    emit(state.copyWith(isLoading: true));
    final response = await repository.postMergeData(mergeData);
    emit(state.copyWith(isLoading: false, message: response.meta.message));
  }

  Future<BitmapDescriptor> _createCustomMarker(
    String? markerPath,
    String caption, {
    bool isCaption = true,
  }) async {
    final lines = caption.split('\n').length;
    const int width = 400;
    const int imageSize = 14;
    final int height = 24 * (lines + 1);

    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final Paint paint = Paint()..color = Colors.transparent;
    canvas.drawRect(
      Rect.fromLTWH(0.0, 0.0, width.toDouble(), height.toDouble()),
      paint,
    );

    if (markerPath != null) {
      final ByteData data = await rootBundle.load(markerPath);
      final ui.Codec codec = await ui.instantiateImageCodec(
        data.buffer.asUint8List(),
        // targetWidth: imageSize,
      );
      final ui.FrameInfo fi = await codec.getNextFrame();
      final ui.Image image = fi.image;

      // 상단 가운데에 이미지를 배치
      const double imageOffsetX = (width - imageSize) / 2;
      const double imageOffsetY = 0;
      canvas.drawImage(
        image,
        const Offset(imageOffsetX, imageOffsetY),
        Paint(),
      );
    }

    // 텍스트 추가
    final TextPainter textPainter = TextPainter(
      textDirection: ui.TextDirection.ltr,
    );
    textPainter.text = TextSpan(
      text: caption,
      style: TextStyle(
        fontSize: 14,
        color: isCaption ? Colors.black : Colors.transparent,
        fontWeight: FontWeight.w500,
        fontFamily: 'NotoSansKR',
      ),
    );
    textPainter.layout();

    // 텍스트를 이미지 하단에 중앙에 배치
    final double textOffsetX = (width - textPainter.width) / 2;
    final double textOffsetY = imageSize.toDouble() + 14; // 이미지 바로 아래
    textPainter.paint(canvas, Offset(textOffsetX, textOffsetY));

    // 이미지와 텍스트가 그려진 캔버스를 BitmapDescriptor로 변환
    final ui.Image markerImage =
        await pictureRecorder.endRecording().toImage(width, height);
    final ByteData? byteData =
        await markerImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List uint8List = byteData!.buffer.asUint8List();

    return BitmapDescriptor.bytes(uint8List);
  }
}
