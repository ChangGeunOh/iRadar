import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemap/common/const/color.dart';
import 'package:googlemap/domain/bloc/bloc_event.dart';
import 'package:googlemap/domain/bloc/bloc_scaffold.dart';
import 'package:googlemap/domain/model/map/area_data.dart';
import 'package:googlemap/domain/model/map_cursor_state.dart';
import 'package:googlemap/presentation/screen/compare/compare_screen.dart';
import 'package:googlemap/presentation/screen/map/component/map_side_menus.dart';
import 'package:googlemap/presentation/screen/map/viewmodel/map_bloc.dart';
import 'package:googlemap/presentation/screen/map/viewmodel/map_state.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import '../../../common/const/constants.dart';
import '../../../common/utils/mixin.dart';
import '../../../domain/model/enum/location_type.dart';
import '../../../domain/model/enum/wireless_type.dart';
import '../../component/dropdown_box.dart';
import '../../component/edit_text.dart';
import '../../component/iradar_dialog.dart';
import 'component/statefull_slider.dart';
import 'viewmodel/map_event.dart';

class MapScreen extends StatelessWidget with ShowMessageMixin {
  final Set<AreaData> areaDataSet;
  final bool isRemove;
  final WirelessType wirelessType;
  final Function onReloadArea;

  MapScreen({
    required this.areaDataSet,
    required this.isRemove,
    required this.wirelessType,
    required this.onReloadArea,
    super.key,
  }) {
    // print('MapScreen> areaDataSet: $areaDataSet');
    // print('MapScreen> isRemove: $isRemove');
    // print('MapScreen> wirelessType: $wirelessType');
  }

  @override
  Widget build(BuildContext context) {
    var mapLeftMargin = 0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox box = context.findRenderObject() as RenderBox;
      final screenSize = MediaQuery.of(context).size;
      mapLeftMargin = screenSize.width.toInt() - box.size.width.toInt();
    });

    return BlocScaffold<MapBloc, MapState>(
      extendBodyBehindAppBar: true,
      appBarBuilder: (context, bloc, state) =>
          _appBar(context, bloc, state, onReloadArea),
      create: (context) {
        return MapBloc(
          context,
          MapState(
            areaDataSet: areaDataSet,
            wirelessType: wirelessType,
          ),
        );
      },
      builder: (context, bloc, state) {
        if (wirelessType != state.wirelessType) {
          bloc.add(
              BlocEvent(MapEvent.onChangeWirelessType, extra: wirelessType));
        }
        if (areaDataSet != state.areaDataSet) {
          bloc.add(BlocEvent(MapEvent.onChangeAreaDataSet, extra: areaDataSet));
        }

        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          if (state.message.isNotEmpty) {
            showDialog(
              context: context,
              builder: (context) => IradarDialog(
                title: state.message,
                onConfirm: () {
                  if (state.showingDialog) {
                    context.pop();
                  }
                },
              ),
            );
            bloc.add(BlocEvent(MapEvent.onMessage, extra: ''));
          }
        });

        return Stack(
          children: [
            Listener(
              onPointerDown: (event) async {
                if (event.kind == PointerDeviceKind.mouse &&
                    event.buttons == kSecondaryMouseButton) {
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
                    (value) {
                      bloc.add(
                        BlocEvent(
                          MapEvent.onChangeCursorState,
                          extra: value,
                        ),
                      );
                    },
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
                  markers: state.mapBaseMarkerSet
                      .union(state.measureMarkerSet)
                      .union(state.otherBaseMarkerSet)
                      .union(state.isShowBestPoint
                          ? state.bestPointMarkerSet
                          : {}),
                  onMapCreated: (GoogleMapController controller) {
                    bloc.setGoogleMapController(controller);
                    bloc.controller = controller;
                  },
                  onTap: (value) {
                    bloc.add(BlocEvent(MapEvent.onTapMap, extra: value));
                  },
                  polygons: state.polygonSet,
                  circles: state.circleSet,
                  onCameraMove: (cameraPosition) {
                    bloc.setCameraPosition(cameraPosition);
                  },
                  onCameraIdle: () {
                    bloc.add(BlocEvent(MapEvent.onCameraIdle));
                  },
                ),
              ),
            ),
            Positioned(
              left: 16,
              bottom: 24,
              child: Image.asset(
                state.isShowSpeed
                    ? state.wirelessType == WirelessType.w5G
                        ? 'assets/images/img_legend_5g.png'
                        : 'assets/images/img_legend_lte.png'
                    : 'assets/images/img_legend.png',
                scale: 2,
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
            Positioned(
              top: 82,
              right: 8,
              child: MapSideMenus(
                onTap: (mapEvent) => bloc.add(BlocEvent(mapEvent)),
                state: state,
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
              SizedBox(width: 16),
              Icon(
                Icons.remove_circle_outline,
                color: Colors.red,
              ),
              SizedBox(
                width: 16,
              ),
              Text(
                '루트 제거 하기',
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
              SizedBox(width: 16),
              Icon(
                Icons.add_circle_outline,
                color: Colors.blue,
              ),
              SizedBox(
                width: 16,
              ),
              Text(
                '루트 추가 하기',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        const PopupMenuItem(
          height: 16,
          child: Divider(
            indent: 16,
            endIndent: 16,
            height: 1,
          ),
        ),
        PopupMenuItem(
          enabled: true,
          onTap: () => onTapMenuItem(MapCursorState.removeAll),
          child: const Row(
            children: [
              SizedBox(width: 16),
              Icon(
                Icons.remove_circle,
                color: Colors.red,
              ),
              SizedBox(
                width: 16,
              ),
              Text(
                '루트 전체 제거',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          enabled: true,
          onTap: () => onTapMenuItem(MapCursorState.addAll),
          child: const Row(
            children: [
              SizedBox(width: 16),
              Icon(
                Icons.add_circle,
                color: Colors.blue,
              ),
              SizedBox(
                width: 16,
              ),
              Text(
                '루트 전체 추가',
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
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    backgroundColor: WidgetStateProperty.resolveWith((state) {
                      if (!state.contains(WidgetState.disabled)) {
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

  AppBar? _appBar(context, bloc, MapState state, onReloadArea) {
    if (state.areaDataSet.isEmpty) {
      return null;
    }
    final title = state.areaDataSet.map((e) => e.name).join(', ');
    final type = state.areaDataSet.first.type;
    return AppBar(
      backgroundColor: Colors.white.withOpacity(0.7),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(type == WirelessType.wLte
              ? 'assets/icons/ic_lte.svg'
              : 'assets/icons/ic_5g.svg'),
          const SizedBox(width: 16),
          Text(title),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            _showMapCompareDialog(
              context: context,
              type: state.wirelessType,
              areaDataSet: state.areaDataSet,
              baseMarkers: state.mapBaseMarkerSet,
              rsrpMarkers: state.respMarkerSet,
              speedMarkers: state.dltpMarkerSet,
            );
          },
          icon: const Icon(Icons.compare_rounded),
        ),
        const SizedBox(width: 8),
        IconButton(
          iconSize: 32,
          icon: const Icon(
            Icons.upload,
          ),
          onPressed: () async {
            bloc.add(BlocEvent(MapEvent.onShowDialog, extra: true));
            await _showMergeDialog(
              context: context,
              bloc: bloc,
              areaDataSet: state.areaDataSet,
              onMergeData: (value) {
                bloc.add(
                  BlocEvent(
                    MapEvent.onMergeData,
                    extra: value,
                  ),
                );
              },
            );
            onReloadArea();
          },
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Future<void> _showMergeDialog({
    required BuildContext context,
    required MapBloc bloc,
    required Set<AreaData> areaDataSet,
    required Function(Map<String, dynamic>) onMergeData,
  }) async {
    final prefix = areaDataSet.length > 1 ? '[병합] ' : '[수정]';
    var name = '$prefix ${areaDataSet.map((e) => e.name).join(', ')}';
    var locationType = areaDataSet.first.division;
    AreaData mostRecent = areaDataSet.reduce((current, next) {
      return current.measuredAt!.isAfter(next.measuredAt!) ? current : next;
    });

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          titlePadding: const EdgeInsets.all(0),
          title: Container(
            color: Colors.red,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Center(
                child: Text(
                  areaDataSet.length > 1 ? "병합하기" : '수정하기',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          content: SizedBox(
            height: 200,
            width: 500,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 200,
                  child: DropdownBox(
                    value: locationType!.name,
                    onChanged: (value) {
                      locationType = LocationType.values
                          .firstWhere((element) => element.name == value);
                    },
                    hint: '구분선택',
                    label: '구분',
                    items: divisionList,
                  ),
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
              child: const Text("취소"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              onPressed: () {
                if (name.isEmpty) {
                  return;
                }
                onMergeData({
                  'name': name,
                  'locationType': locationType,
                  'measuredAt': mostRecent.measuredAt,
                });
                // Navigator.of(context).pop();
              },
              child: const Text("저장"),
            ),
          ],
        );
      },
    );
  }

  void _showMapCompareDialog({
    required BuildContext context,
    required WirelessType type,
    required Set<AreaData> areaDataSet,
    required Set<Marker> baseMarkers,
    required Set<Marker> rsrpMarkers,
    required Set<Marker> speedMarkers,
  }) async {

;


    await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.8,
              child: CompareScreen(
                type: type,
                areaDataSet: areaDataSet,
                baseMarkers: baseMarkers,
                rsrpMarkers: rsrpMarkers,
                speedMarkers: speedMarkers,
              ),
            ),
          );
        });
  }
}
