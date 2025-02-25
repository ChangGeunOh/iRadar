import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemap/common/const/color.dart';
import 'package:googlemap/domain/bloc/bloc_scaffold.dart';
import 'package:googlemap/domain/model/chart/measure_data.dart';
import 'package:googlemap/domain/model/chart_data.dart';
import 'package:googlemap/domain/model/enum/wireless_type.dart';
import 'package:googlemap/domain/model/pci/pci_base.dart';
import 'package:googlemap/presentation/screen/pci/bloc/pci_bloc.dart';
import 'package:googlemap/presentation/screen/pci/bloc/pci_state.dart';

import '../../../domain/model/pci/pci_base_data.dart';
import '../../../domain/model/pci/pci_data.dart';
import 'widget/google_map_view.dart';

class PciScreen extends StatelessWidget {
  final int idx;
  final WirelessType type;
  final String spci;

  const PciScreen({
    super.key,
    required this.type,
    required this.idx,
    required this.spci,
  });

  @override
  Widget build(BuildContext context) {
    return BlocScaffold<PciBloc, PciState>(
        create: (context) => PciBloc(
              context,
              PciState(
                idx: idx,
                spci: spci,
                type: type.name,
              ),
            ),
        builder: (context, bloc, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return GoogleMapDoubleView(
            type: type,
            spci: spci,
            position: state.pciBaseData?.position,
            nPciDataList: state.pciBaseData?.nPciDataList,
            sPciDataList: state.pciBaseData?.sPciDataList,
            pciBaseList: state.pciBaseData?.pciBaseList,
          );
        });
  }
}

//                 position: state.pciBaseData?.position,
//                 pciBaseList: state.pciBaseData?.pciBaseList,
//                 pciDataList: state.pciBaseData?.sPciDataList,
class GoogleMapDoubleView extends StatefulWidget {
  final Position? position;
  final List<PciData>? nPciDataList;
  final List<PciData>? sPciDataList;
  final List<PciBase>? pciBaseList;

  const GoogleMapDoubleView({
    super.key,
    required this.type,
    required this.spci,
    this.position,
    this.pciBaseList,
    this.nPciDataList,
    this.sPciDataList,
  });

  final WirelessType type;
  final String spci;

  @override
  State<GoogleMapDoubleView> createState() => _GoogleMapDoubleViewState();
}

class _GoogleMapDoubleViewState extends State<GoogleMapDoubleView> {
  late GoogleMapController leftController;
  late GoogleMapController rightController;
  bool isLinked = true;
  MapState leftMapState = MapState.idle;
  MapState rightMapState = MapState.idle;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          children: [
            Expanded(
              child: GoogleMapView(
                type: widget.type,
                position: widget.position,
                pciBaseList: widget.pciBaseList,
                pciDataList: widget.sPciDataList,
                isService: true,
                pci: widget.spci,
                onMapCreated: (controller) {
                  leftController = controller;
                },
                onCameraMove: (position) {
                  if (leftMapState == MapState.idle) {
                    leftMapState = MapState.moveByGesture;
                  }
                  if (isLinked && leftMapState == MapState.moveByGesture) {
                    rightMapState = MapState.moveByController;
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
                    leftMapState = MapState.idle;
                  });
                },
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: GoogleMapView(
                type: widget.type,
                position: widget.position,
                pciBaseList: widget.pciBaseList,
                pciDataList: widget.nPciDataList,
                isService: false,
                pci: widget.spci,
                onMapCreated: (controller) {
                  rightController = controller;
                },
                onCameraMove: (position) {
                  if (rightMapState == MapState.idle) {
                    rightMapState = MapState.moveByGesture;
                  }
                  if (isLinked && rightMapState == MapState.moveByGesture) {
                    leftMapState = MapState.moveByController;
                    leftController.animateCamera(
                        CameraUpdate.newCameraPosition(position));
                  }
                },
                onCameraMoveStarted: () {
                  setState(() {});
                },
                onCameraIdle: () {
                  rightMapState = MapState.idle;
                  setState(() {});
                },
              ),
            ),
          ],
        ),
        Positioned(
          left: 16,
          bottom: 24,
          child: Image.asset('assets/images/img_legend.png', scale: 2,),
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
        ))
      ],
    );
  }
}

enum MapState {
  idle,
  moveByController,
  moveByGesture,
  moveStart,
}
