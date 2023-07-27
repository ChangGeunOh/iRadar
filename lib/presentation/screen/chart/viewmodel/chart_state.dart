import 'package:googlemap/domain/model/place_data.dart';

import '../../../../domain/model/chart_table_data.dart';

class ChartState {
  final PlaceData? placeData;
  final ChartTableData? chartTableData;

  ChartState({
    this.placeData,
    this.chartTableData,
  });

  ChartState copyWith({
    PlaceData? placeData,
    ChartTableData? chartTableData,
  }) {
    return ChartState(
      placeData: placeData ?? this.placeData,
      chartTableData: chartTableData ?? this.chartTableData,
    );
  }
}
