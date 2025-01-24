import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:collection/collection.dart';
import 'dart:ui' as ui;

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

    List<Marker> dataMarkers = [];
    if (widget.pciDataList != null) {
      dataMarkers = await Future.wait(
        widget.pciDataList!.mapIndexed((index, pciData) async {
          return Marker(
            markerId: MarkerId('data-$index'),
            // icon: getRsrpIcon(pciData.rsrp),
            icon: await _createCustomMarker(pciData.rsrp.toDouble()),
            position: LatLng(pciData.latitude, pciData.longitude),
            infoWindow: InfoWindow(
              title: 'PCI: ${pciData.pci}',
              snippet: 'RSRP: ${pciData.rsrp}',
            ),
          );
        }),
      );
    }

    markers = {...?baseMarker, ...dataMarkers};
    setState(() {});
  }

  Future<List<BitmapDescriptor>> _getMapPins() async {
    final filenames =
        List.generate(12, (index) => 'assets/icons/pin$index.jpg');
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
      if (rsrp >= rsrpThresholds[i]) {
        return mapPins[pinIndices[i]];
      }
    }
    return mapPins[pinIndices.last];
  }
  
  
  String _getMapPinFiles(double rsrp) {

    final filenames = List.generate(12, (index) => 'assets/icons/pin$index.jpg');
    
    List<double> rsrpThresholds = [-120, -110, -100, -90, -80, -70];
    List<int> pinIndices = [0, 1, 2, 4, 7, 8, 10];
    
    int index = pinIndices.last;
    for (int i = 0; i < rsrpThresholds.length; i++) {
      if (rsrp <= rsrpThresholds[i]) {
        return filenames[pinIndices[i]];
      }
    }
    
    return filenames.last;
  }

  Future<BitmapDescriptor> _createCustomMarker(double value) async {
    // 크기 지정
    const int width = 50;
    const int height = 40;
    const int imageSize = 14;

    // 이미지를 불러옵니다.
    final ByteData data = await rootBundle.load(_getMapPinFiles(value));
    final ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: imageSize,
    );
    final ui.FrameInfo fi = await codec.getNextFrame();
    final ui.Image image = fi.image;

    // Canvas와 PictureRecorder 생성
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    // 배경을 흰색으로 채우기 (선택사항)
    final Paint paint = Paint()..color = Colors.transparent;
    canvas.drawRect(Rect.fromLTWH(0.0, 0.0, width.toDouble(), height.toDouble()), paint);

    // 상단 가운데에 이미지를 배치
    const double imageOffsetX = (width - imageSize) / 2;
    const double imageOffsetY = 0;
    canvas.drawImage(image, const Offset(imageOffsetX, imageOffsetY), Paint());

    // 텍스트 추가
    final TextPainter textPainter = TextPainter(
      textDirection: ui.TextDirection.ltr,
    );
    textPainter.text = TextSpan(
      text: value.toString(),
      style: const TextStyle(
        fontSize: 14,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );
    textPainter.layout();

    // 텍스트를 이미지 하단에 중앙에 배치
    final double textOffsetX = (width - textPainter.width) / 2;
    final double textOffsetY = imageSize.toDouble() + 8; // 이미지 바로 아래
    textPainter.paint(canvas, Offset(textOffsetX, textOffsetY));

    // 이미지와 텍스트가 그려진 캔버스를 BitmapDescriptor로 변환
    final ui.Image markerImage = await pictureRecorder.endRecording().toImage(width, height);
    final ByteData? byteData = await markerImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List uint8List = byteData!.buffer.asUint8List();

    return BitmapDescriptor.bytes(uint8List);
  }
}
