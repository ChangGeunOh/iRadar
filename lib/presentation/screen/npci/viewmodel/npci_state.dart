
import '../../../../domain/model/chart/measure_data.dart';
import '../../../../domain/model/map/area_data.dart';

class NpciState  {
  final AreaData areaData;
  final String pci;
  final List<MeasureData> measureDataList;
  final bool isLoading;
  final String message;

  NpciState({
    required this.areaData,
    required this.pci,
    this.isLoading = false,
    this.message = '',
    this.measureDataList = const [],
  });

  NpciState copyWith({
    bool? isLoading,
    String? message,
    AreaData? areaData,
    String? pci,
    List<MeasureData>? measureDataList,
  }) {
    return NpciState(
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
      areaData: areaData ?? this.areaData,
      pci: pci ?? this.pci,
      measureDataList: measureDataList ?? this.measureDataList,
    );
  }

}
