import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:collection/collection.dart';


import '../../../../domain/model/enum/wireless_type.dart';
import '../../../../domain/model/pci/pci_base.dart';
import '../../../../domain/model/pci/pci_base_data.dart';
import '../../../../domain/model/pci/pci_data.dart';


class GoogleMapView extends StatefulWidget {
  final WirelessType type;
  final Position? position;
  final List<PciData>? pciDataList;
  final List<PciBase>? pciBaseList;
  final bool isService;
  final String pci;
  final Function(GoogleMapController) onMapCreated;
  final Function(CameraPosition) onCameraMove;
  final Function() onCameraMoveStarted;
  final Function() onCameraIdle;

  const GoogleMapView({
    super.key,
    required this.type,
    required this.position,
    required this.pciBaseList,
    required this.pciDataList,
    required this.isService,
    required this.pci,
    required this.onMapCreated,
    required this.onCameraMove,
    required this.onCameraMoveStarted,
    required this.onCameraIdle,
  });

  @override
  State<GoogleMapView> createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {
  List<BitmapDescriptor> mapPins = [];
  Set<Marker> markers = {};

  @override
  void initState() {
    print('------------------------------------>GoogleMapView initState');
    init();
    super.initState();
  }

  Future<void> init() async {
    mapPins = await _getMapPins();
    await _makeMarkers(widget.type);
  }

  @override
  Widget build(BuildContext context) {
    final latLng = widget.position == null
        ? const LatLng(37.42796133580664, -122.085749655962)
        : LatLng(widget.position!.latitude, widget.position!.longitude);
    return Stack(
      children: [
        GoogleMap(
          markers: markers,
          initialCameraPosition: CameraPosition(
            target: latLng,
            zoom: 14.4746,
          ),
          onMapCreated: widget.onMapCreated,
          onCameraMove: widget.onCameraMove,
          onCameraMoveStarted: widget.onCameraMoveStarted,
          onCameraIdle: widget.onCameraIdle,
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 48,
            color: Colors.white.withOpacity(0.8),
            child: Center(
              child: Text(
                '${widget.isService ? '서빙셀' : '네이버셀'} (${widget.pci})',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                  fontSize: 24,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Future<void> _makeMarkers(WirelessType type) async {
    final imagePath = type == WirelessType.wLte
        ? 'assets/icons/pin_base_lte.png'
        : 'assets/icons/pin_base_5g.png';
    final image = await rootBundle.load(imagePath);
    final basePin = BitmapDescriptor.bytes(image.buffer.asUint8List());

    final baseMarker = widget.pciBaseList?.map((pciBase) {
      return Marker(
        markerId: MarkerId('base-${pciBase.code}'),
        position: LatLng(pciBase.latitude, pciBase.longitude),
        infoWindow: InfoWindow(
          title: 'PCI: ${pciBase.rnm}',
          snippet: 'RSRP: ${pciBase.code}',
        ),
        icon: basePin,
      );
    });

    final dataMarkers = widget.pciDataList?.mapIndexed((index, pciData) {
      return Marker(
        markerId: MarkerId('data-$index'),
        icon: getRsrpIcon(pciData.rsrp),
        position: LatLng(pciData.latitude, pciData.longitude),
        infoWindow: InfoWindow(
          title: 'PCI: ${pciData.pci}',
          snippet: 'RSRP: ${pciData.rsrp}',
        ),
      );
    });

    markers = {...?baseMarker, ...?dataMarkers};
    setState(() {});
  }

  Future<List<BitmapDescriptor>> _getMapPins() async {
    final filenames = List.generate(
        12, (index) => 'assets/icons/pin$index.jpg');
    return await Future.wait(filenames.map((e) async {
      final image = await rootBundle.load(e);
      final bytes = image.buffer.asUint8List();
      return BitmapDescriptor.bytes(bytes);
    }).toList());
  }

  BitmapDescriptor getRsrpIcon(double rsrp) {
    List<double> rsrpThresholds = [-120, -110, -100, -90, -80, -70];
    List<int> pinIndices = [0, 1, 2, 4, 7, 8, 10];

    for (int i = 0; i < rsrpThresholds.length; i++) {
      print('rsrp: $rsrp, threshold: ${rsrpThresholds[i]}');
      if (rsrp >= rsrpThresholds[i]) {
        return mapPins[pinIndices[i]];
      }
    }
    return mapPins[pinIndices.last];
  }
}