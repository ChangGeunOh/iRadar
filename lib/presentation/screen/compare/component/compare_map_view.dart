import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemap/common/const/color.dart';
import 'package:googlemap/domain/model/enum/wireless_type.dart';

class CompareMapview extends StatelessWidget {
  final bool isSpeed;
  final WirelessType type;
  final bool isLoading;
  final LatLng position;
  final Function(GoogleMapController)? onMapCreated;
  final Function(CameraPosition) onCameraMove;
  final Function() onCameraMoveStarted;
  final Function() onCameraIdle;
  final Set<Marker> markers;

  const CompareMapview({
    super.key,
    this.isSpeed = false,
    this.isLoading = false,
    this.position = const LatLng(37.42796133580664, -122.085749655962),
    required this.type,
    required this.onMapCreated,
    required this.onCameraMove,
    required this.onCameraMoveStarted,
    required this.onCameraIdle,
    this.markers = const {},
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !isSpeed,
        centerTitle: true,
        title: Text(
          isSpeed ? '${type.name} Mac T/P' : 'RSRP',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: position,
              zoom: 14.4746,
            ),
            onMapCreated: onMapCreated,
            onCameraMove: onCameraMove,
            onCameraMoveStarted: onCameraMoveStarted,
            onCameraIdle: onCameraIdle,
            markers: markers,
          ),
          Positioned(
            left: 16,
            bottom: 24,
            child: Image.asset(
              !isSpeed
                  ? 'assets/images/img_legend.png'
                  : type == WirelessType.wLte
                      ? 'assets/images/img_legend_lte.png'
                      : 'assets/images/img_legend_5g.png',
              scale: 2,
            ),
          ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            ),
        ],
      ),
    );
  }
}
