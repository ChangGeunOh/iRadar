import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemap/domain/bloc/bloc_event.dart';
import 'package:googlemap/domain/model/map_cursor_state.dart';
import 'package:googlemap/presentation/screen/map/viewmodel/map_bloc.dart';
import 'package:googlemap/presentation/screen/map/viewmodel/map_state.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import '../../../domain/bloc/bloc_layout.dart';
import '../../../domain/model/place_data.dart';
import 'component/statefull_slider.dart';
import 'viewmodel/map_event.dart';

class MapScreen extends StatelessWidget {
  final PlaceData? placeData;
  final bool isRemove;

  const MapScreen({
    required this.placeData,
    required this.isRemove,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var mapLeftMargin = 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox box = context.findRenderObject() as RenderBox;
      final screenSize = MediaQuery.of(context).size;
      print('box>${box.size.width} : ScreenSize>${screenSize.width}');
      print("point>${screenSize.width - box.size.width}");
      mapLeftMargin = screenSize.width.toInt() - box.size.width.toInt();
    });

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
            Listener(
              onPointerDown: (event) async {
                if (event.kind == PointerDeviceKind.mouse &&
                    event.buttons == kSecondaryMouseButton) {
                  print("Right Mouse Button Clicked....");
                  final RenderBox box = context.findRenderObject() as RenderBox;
                  final offset = box.localToGlobal(Offset.zero);
                  final relativeRect = RelativeRect.fromLTRB(
                    event.localPosition.dx + mapLeftMargin,
                    event.localPosition.dy,
                    offset.dx +
                        box.size.width -
                        event.localPosition.dx +
                        mapLeftMargin,
                    offset.dy + box.size.height - event.localPosition.dy,
                  );
                  await showContextMenu(
                    context,
                    relativeRect,
                    state.radius,
                    (value) => bloc.add(
                      BlocEvent(MapEvent.onChangeRadius, extra: value),
                    ),
                    (value) => bloc.add(
                      BlocEvent(MapEvent.onChangeCursorState, extra: value),
                    ),
                    state.cursorState,
                  );
                }
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                onHover: (event) async {
                  if (bloc.controller != null) {
                    final lagLng = await bloc.controller!.getLatLng(
                      ScreenCoordinate(
                        x: event.position.dx.toInt() - mapLeftMargin,
                        y: event.position.dy.toInt(),
                      ),
                    );
                    bloc.add(BlocEvent(MapEvent.onMoveCursor, extra: lagLng));
                  }
                },
                child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: bloc.initCameraPosition(),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  markers: (state.baseMarkers + state.measureMarkers).toSet(),
                  onMapCreated: (GoogleMapController controller) {
                    bloc.setGoogleMapController(controller);
                    bloc.controller = controller;
                  },
                  onTap: (value) {
                    print('google map> onTap');
                    bloc.add(BlocEvent(MapEvent.onTapMap, extra: value));
                  },
                  polygons: state.polygonSet ?? const <Polygon>{},
                  circles: state.circleSet ?? const <Circle>{},
                  onCameraMove: (value) {
                    bloc.setCameraPosition(value);
                  },
                ),
              ),
            ),
            if (placeData != null)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  centerTitle: true,
                  title: Text(placeData!.name),
                  actions: [
                    IconButton(
                      onPressed: () {
                        bloc.add(
                            BlocEvent(MapEvent.onTapRectangle, extra: true));
                      },
                      isSelected: state.isRectangleMode,
                      selectedIcon: const Icon(
                        Icons.rectangle,
                      ),
                      icon: Icon(
                        state.isRectangleMode
                            ? Icons.rectangle_outlined
                            : Icons.rectangle,
                      ),
                    ),
                    const SizedBox(width: 24),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  Future<void> showContextMenu(
    BuildContext context,
    RelativeRect relativeRect,
    double initValue,
    ValueChanged onValueChange,
    ValueChanged onTapMenuItem,
    MapCursorState cursorState,
  ) async {
    await showMenu(
      context: context,
      position: relativeRect,
      items: [
        PopupMenuItem(
          enabled: false,
          child: PointerInterceptor(
            child: StatefulSlider(
              initValue: initValue,
              onChangedValue: (value) => onValueChange(value),
            ),
          ),
        ),
        PopupMenuItem(
          onTap: () => onTapMenuItem(MapCursorState.remove),
          child: const Row(
            children: [
              Icon(
                Icons.remove_circle,
                color: Colors.red,
              ),
              SizedBox(
                width: 16,
              ),
              Text(
                '데이터 제거하기',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          enabled: true,
          onTap: () => onTapMenuItem(MapCursorState.add),
          child: const Row(
            children: [
              Icon(
                Icons.add_circle,
                color: Colors.blue,
              ),
              SizedBox(
                width: 16,
              ),
              Text(
                '데이터 추가하기',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          enabled: false,
          child: Column(
            children: [
              const SizedBox(height: 6),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.resolveWith((state) {
                      if (!state.contains(MaterialState.disabled)) {
                        return Colors.blue;
                      }
                      return Colors.grey.withAlpha(64);
                    }),
                  ),
                  onPressed: cursorState == MapCursorState.none
                      ? null
                      : () {
                          onTapMenuItem(MapCursorState.none);
                          Navigator.pop(context);
                        },
                  child: const Text(
                    '선택 완료',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Add more options here
      ],
    );
  }
}
