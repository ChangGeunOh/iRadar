import 'package:googlemap/domain/model/place_data.dart';

import '../../../../domain/model/chart_table_data.dart';

class ChartState {
  final PlaceData? placeData;
  final ChartTableData? chartTableData;
  final bool isCheck;
  final bool isLoading;

  ChartState({
    this.placeData,
    this.chartTableData,
    bool? isCheck,
    this.isLoading = false,
  }) : isCheck = isCheck ?? false;

  ChartState copyWith({
    PlaceData? placeData,
    ChartTableData? chartTableData,
    bool? isCheck,
    bool? isLoading,
  }) {
    return ChartState(
      placeData: placeData ?? this.placeData,
      chartTableData: chartTableData ?? this.chartTableData,
      isCheck: isCheck ?? this.isCheck,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
