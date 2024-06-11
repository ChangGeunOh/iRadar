import 'package:googlemap/domain/model/place_data.dart';

import '../../../../domain/model/chart/measure_data.dart';
import '../../../../domain/model/chart_table_data.dart';
import '../../../../domain/model/map/area_data.dart';

class ChartState {
  final AreaData areaData;
  final List<MeasureData> measureDataList;
  final String message;
  final bool isCheck;
  final bool isLoading;

  ChartState({
    required this.areaData,
    this.measureDataList = const [],
    this.isCheck = false ,
    this.isLoading = false,
    this.message = '',
  });

  ChartState copyWith({
    AreaData? areaData,
    PlaceData? placeData,
    List<MeasureData>? measureDataList,
    bool? isCheck,
    bool? isLoading,
    String? message,
  }) {
    return ChartState(
      areaData: areaData ?? this.areaData,
      measureDataList: measureDataList ?? this.measureDataList,
      isCheck: isCheck ?? this.isCheck,
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
    );
  }
}
