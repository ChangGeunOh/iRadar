import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemap/domain/model/enum/wireless_type.dart';
import 'package:googlemap/domain/model/map/area_data.dart';
import 'package:googlemap/presentation/screen/compare/component/compare_map_view.dart';
import '../../../common/const/color.dart';
import '../../../domain/bloc/bloc_scaffold.dart';
import 'viewmodel/compare_state.dart';
import 'viewmodel/compare_bloc.dart';

class CompareScreen extends StatefulWidget {
  static String get routeName => 'compare';

  final WirelessType type;
  final Set<AreaData> areaDataSet;
  final Set<Marker> baseMarkers;
  final Set<Marker> rsrpMarkers;
  final Set<Marker> speedMarkers;

  const CompareScreen({
    super.key,
    required this.type,
    required this.areaDataSet,
    required this.baseMarkers,
    required this.rsrpMarkers,
    required this.speedMarkers,
  });

  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  bool isLinked = true;

  late GoogleMapController leftController;
  late GoogleMapController rightController;
  GoogleMapState leftMapState = GoogleMapState.idle;
  GoogleMapState rightMapState = GoogleMapState.idle;

  LatLng avgLatLng = const LatLng(0, 0);

  @override
  void initState() {
    super.initState();
    double totalLat = 0;
    double totalLng = 0;
    for (final marker in widget.baseMarkers) {
      totalLat += marker.position.latitude;
      totalLng += marker.position.longitude;
    }
    final avgLat = totalLat / widget.baseMarkers.length;
    final avgLng = totalLng / widget.baseMarkers.length;
    avgLatLng = LatLng(avgLat, avgLng);
  }

  @override
  Widget build(BuildContext context) {
    return BlocScaffold<CompareBloc, CompareState>(
      create: (context) => CompareBloc(
          context,
          CompareState(
            areaDataSet: widget.areaDataSet,
            type: widget.type,
            leftMarkers: widget.rsrpMarkers,
            rightMarkers: widget.speedMarkers,
          )),
      builder: (context, bloc, state) {
        return Stack(
          children: [
            Row(
              children: [
                Expanded(
                  child: CompareMapview(
                    isSpeed: false,
                    type: widget.type,
                    position: avgLatLng,
                    markers: {...widget.baseMarkers, ...state.leftMarkers},
                    onMapCreated: (GoogleMapController controller) {
                      leftController = controller;
                    },
                    onCameraMove: (position) {
                      if (leftMapState == GoogleMapState.idle) {
                        leftMapState = GoogleMapState.moveByGesture;
                      }
                      if (isLinked &&
                          leftMapState == GoogleMapState.moveByGesture) {
                        rightMapState = GoogleMapState.moveByController;
                        rightController.animateCamera(
                            CameraUpdate.newCameraPosition(position));
                      }
                      setState(() {});
                    },
                    onCameraMoveStarted: () {
                      setState(() {
                        // leftMapState = MapState.moveStart;
                      });
                    },
                    onCameraIdle: () {
                      setState(() {
                        leftMapState = GoogleMapState.idle;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: CompareMapview(
                    isSpeed: true,
                    type: widget.type,
                    position: avgLatLng,
                    markers: {...widget.baseMarkers, ...state.rightMarkers},
                    isLoading: state.isRightLoading,
                    onMapCreated: (GoogleMapController controller) {
                      rightController = controller;
                    },
                    onCameraMove: (position) {
                      if (rightMapState == GoogleMapState.idle) {
                        rightMapState = GoogleMapState.moveByGesture;
                      }
                      if (isLinked &&
                          rightMapState == GoogleMapState.moveByGesture) {
                        leftMapState = GoogleMapState.moveByController;
                        leftController.animateCamera(
                            CameraUpdate.newCameraPosition(position));
                      }
                    },
                    onCameraMoveStarted: () {
                      setState(() {});
                    },
                    onCameraIdle: () {
                      rightMapState = GoogleMapState.idle;
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
            Center(
              child: IconButton(
                icon: Icon(
                  Icons.link_outlined,
                  size: 54,
                  color: isLinked ? primaryColor : Colors.grey[300],
                ),
                onPressed: () {
                  isLinked = !isLinked;
                  setState(() {});
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

enum GoogleMapState {
  idle,
  moveStart,
  moveByGesture,
  moveByController,
}
