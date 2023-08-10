import 'package:googlemap/domain/model/place_data.dart';
import 'package:googlemap/domain/model/table_data.dart';

class NpciState {
  final PlaceData? placeData;
  final List<TableData>? tableList;
  final bool isCheck;

  NpciState({
    this.placeData,
    this.tableList,
    bool? isCheck,
  }) : isCheck = isCheck ?? false;

  NpciState copyWith({
    PlaceData? placeData,
    List<TableData>? tableList,
    bool? isCheck,
  }) {
    return NpciState(
      placeData: placeData ?? this.placeData,
      tableList: tableList ?? this.tableList,
      isCheck: isCheck ?? this.isCheck,
    );
  }
}
