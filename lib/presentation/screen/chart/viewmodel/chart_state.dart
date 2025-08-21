import 'package:googlemap/domain/model/place_data.dart';

import '../../../../domain/model/chart/measure_data.dart';
import '../../../../domain/model/chart_table_data.dart';
import '../../../../domain/model/map/area_data.dart';

class ChartState {
  final AreaData areaData;
  final List<MeasureData> measureDataList;
  final List<MeasureData> filteredMeasureDataList;
  final String message;
  final bool isCheck;
  final bool isLoading;
  final bool isDeduplication;
  final Function(AreaData)? onChangeAreaData;

  ChartState({
    required this.areaData,
    this.measureDataList = const [],
    this.filteredMeasureDataList = const [],
    this.isCheck = false ,
    this.isLoading = false,
    this.message = '',
    this.isDeduplication = false,
    this.onChangeAreaData,
  });

  ChartState copyWith({
    AreaData? areaData,
    PlaceData? placeData,
    List<MeasureData>? measureDataList,
    List<MeasureData>? filteredMeasureDataList,
    bool? isCheck,
    bool? isLoading,
    String? message,
    bool? isDeduplication,
  }) {
    return ChartState(
      areaData: areaData ?? this.areaData,
      measureDataList: measureDataList ?? this.measureDataList,
      filteredMeasureDataList: filteredMeasureDataList ?? this.filteredMeasureDataList,
      isCheck: isCheck ?? this.isCheck,
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
      isDeduplication: isDeduplication ?? this.isDeduplication,
      onChangeAreaData: onChangeAreaData,
    );
  }
}
