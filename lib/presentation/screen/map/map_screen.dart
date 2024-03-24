import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemap/common/const/color.dart';
import 'package:googlemap/domain/bloc/bloc_event.dart';
import 'package:googlemap/domain/model/map_cursor_state.dart';
import 'package:googlemap/presentation/screen/map/viewmodel/map_bloc.dart';
import 'package:googlemap/presentation/screen/map/viewmodel/map_state.dart';
import 'package:intl/intl.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import '../../../common/const/constants.dart';
import '../../../domain/bloc/bloc_layout.dart';
import '../../../domain/model/enum/location_type.dart';
import '../../../domain/model/place_data.dart';
import '../../component/dropdown_box.dart';
import '../../component/edit_text.dart';
import '../../component/password_field.dart';
import 'component/statefull_slider.dart';
import 'viewmodel/map_event.dart';

class MapScreen extends StatelessWidget {
  final Set<PlaceData> placeDataSet;
  final bool isRemove;

  const MapScreen({
    required this.placeDataSet,
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
        return MapBloc(
          context,
          MapState(),
        );
      },
      builder: (context, bloc, state) {
        print(
            'MapScreen::: ${state.placeDataList.length} : ${placeDataSet.length}');
        if (placeDataSet.difference(state.placeDataList.toSet()).isNotEmpty ||
            state.placeDataList.toSet().difference(placeDataSet).isNotEmpty) {
          print('MapScreen::: ${placeDataSet != state.placeDataList.toSet()}');
          bloc.add(BlocEvent(MapEvent.onInit, extra: placeDataSet));
        }
        if (state.isLoading) {
          bloc.add(BlocEvent(MapEvent.onDataLoading));
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
                  polygons: state.polygonSet,
                  circles: state.circleSet,
                  onCameraMove: (value) {
                    bloc.setCameraPosition(value);
                  },
                ),
              ),
            ),
            if (placeDataSet.isNotEmpty)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: AppBar(
                  backgroundColor: Colors.transparent,
                  centerTitle: true,
                  title: Text(
                    placeDataSet.map((e) => e.name).join(', '),
                  ),
                ),
              ),
            if (placeDataSet.length > 1)
              Positioned(
                right: 24,
                bottom: 130,
                child: FloatingActionButton(
                  backgroundColor: Colors.red,
                  onPressed: () {
                    _showMergeDialog(
                      context: context,
                      placeDataList: state.placeDataList,
                      onMergeData: (PlaceData placeData) {
                        bloc.add(
                          BlocEvent(
                            MapEvent.onMergeData,
                            extra: placeData,
                          ),
                        );
                      },
                    );
                  },
                  child: const Icon(
                    Icons.merge_rounded,
                  ),
                ),
              ),
            if (state.isLoading)
              Positioned.fill(
                child: Container(
                  color: const Color(0x40000000),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  ),
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
                  child: const Text('선택 완료',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      )),
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

void _showMergeDialog({
  required BuildContext context,
  required List<PlaceData> placeDataList,
  required Function(PlaceData) onMergeData,
}) {
  var name = '[Merge] ${placeDataList.map((e) => e.name).join(', ')}';
  var locationType = placeDataList.first.division;
  var password = '';

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("병합하기"),
        content: SizedBox(
          height: 200,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 150,
                    child: EditText(
                      onChanged: (value) {},
                      label: '지역',
                      value: placeDataList.first.group,
                      enabled: false,
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 200,
                    child: DropdownBox(
                      value: locationType.name,
                      onChanged: (value) {
                        locationType = LocationType.values
                            .firstWhere((element) => element.name == value);
                      },
                      hint: '구분선택',
                      label: '구분',
                      items: divisionList,
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 200,
                    child: PasswordField(
                      onChanged: (value) {
                        password = value;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: EditText(
                  onChanged: (value) {
                    name = value;
                  },
                  label: '측정장소',
                  value: name,
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              print('병합하기 :: ${locationType.name} : $name} : $password');
              if (name.isEmpty || name.length < 5 || password.length < 5) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('측정장소나 비밀번호를 입력해주세요.'),
                  ),
                );
                return;
              }
              _onMergeData(
                locationType: locationType,
                name: name,
                placeDataList: placeDataList,
                onMergeData: onMergeData,
                password: password,
              );
            },
            child: const Text("병합"),
          ),
          TextButton(
            child: const Text("취소"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void _onMergeData({
  required LocationType locationType,
  required String name,
  required List<PlaceData> placeDataList,
  required Function(PlaceData) onMergeData,
  required String password,
}) {
  print('병합하기 :: ${locationType.name} : $name}');
  final latitude = placeDataList
          .map((e) => e.latitude)
          .reduce((value, element) => value + element) /
      placeDataList.length;
  final longitude = placeDataList
          .map((e) => e.longitude)
          .reduce((value, element) => value + element) /
      placeDataList.length;
  final String formattedDate =
      DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  final placeData = PlaceData(
    idx: -1,
    type: placeDataList.first.type,
    group: placeDataList.first.group,
    name: name,
    division: locationType,
    latitude: latitude,
    longitude: longitude,
    dateTime: formattedDate,
    password: password,
  );
  onMergeData(placeData);
}
