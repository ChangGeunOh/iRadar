import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googlemap/domain/model/enum/wireless_type.dart';
import 'package:googlemap/domain/model/map/area_data.dart';
import 'package:equatable/equatable.dart';

class CompareState extends Equatable {
  final bool isRightLoading;
  final bool isLeftLoading;
  final Set<AreaData> areaDataSet;
  final Set<Marker> leftMarkers;
  final Set<Marker> rightMarkers;
  final WirelessType type;

  const CompareState({
    required this.areaDataSet,
    required this.type,
    this.isLeftLoading = false,
    this.isRightLoading = true,
    this.leftMarkers = const {},
    this.rightMarkers = const {},
  });

  CompareState copyWith({
    String? message,
    bool? isLeftLoading,
    bool? isRightLoading,
    Set<Marker>? leftMarkers,
    Set<Marker>? rightMarkers,
  }) {
    return CompareState(
      areaDataSet: areaDataSet,
      type: type,
      isLeftLoading: isLeftLoading ?? this.isLeftLoading,
      isRightLoading: isRightLoading ?? this.isRightLoading,
      leftMarkers: leftMarkers ?? this.leftMarkers,
      rightMarkers: rightMarkers ?? this.rightMarkers,
    );
  }

  @override
  List<Object?> get props => [
        isLeftLoading,
        isRightLoading,
        areaDataSet,
        leftMarkers,
        rightMarkers,
        type,
      ];
}
