import 'package:flutter/cupertino.dart';

import '../../../../domain/model/map/area_data.dart';
import '../../../../domain/model/chart_table_data.dart';
import '../../../../domain/model/map/map_base_data.dart';
import '../../../../domain/model/response/meta_data.dart';
import '../../../../domain/model/place_data.dart';
import '../../../../domain/model/enum/wireless_type.dart';

class MainState {
  final MapBaseData? mapBaseData;
  final ChartTableData? chartTableData;
  final String search;
  final WirelessType type;
  final bool isShowSide;
  final PlaceData? placeData;
  final bool isRemove;
  final bool isLoading;
  final Set<AreaData> selectedAreaDataSet;
  final List<AreaData> areaDataList;
  final List<AreaData> filteredAreaDataList;
  final String message;
  final bool isShiftPressed;

  MainState({
    this.mapBaseData,
    this.chartTableData,
    this.search = "",
    this.type = WirelessType.w5G,
    this.isShowSide = true,
    this.placeData,
    this.isRemove = false,
    this.isLoading = false,
    this.selectedAreaDataSet = const {},
    this.areaDataList = const [],
    this.filteredAreaDataList = const [],
    this.message = "",
    this.isShiftPressed = false,
  });

  MainState copyWith({
    List<PlaceData>? placeList,
    MapBaseData? mapBaseData,
    ChartTableData? chartTableData,
    String? search,
    WirelessType? type,
    bool? isShowSide,
    PlaceData? placeData,
    bool? isRemove,
    bool? isLoading,
    Set<AreaData>? selectedAreaDataSet,
    List<AreaData>? areaDataList,
    String? message,
    List<AreaData>? filteredAreaDataList,
    bool? isShiftPressed,
  }) {
    return MainState(
      mapBaseData: mapBaseData ?? this.mapBaseData,
      chartTableData: chartTableData ?? this.chartTableData,
      search: search ?? this.search,
      type: type ?? this.type,
      isShowSide: isShowSide ?? this.isShowSide,
      placeData: placeData ?? this.placeData,
      isRemove: isRemove ?? this.isRemove,
      isLoading: isLoading ?? this.isLoading,
      selectedAreaDataSet: selectedAreaDataSet ?? this.selectedAreaDataSet,
      areaDataList: areaDataList ?? this.areaDataList,
      message: message ?? this.message,
      filteredAreaDataList: filteredAreaDataList ?? this.filteredAreaDataList,
      isShiftPressed: isShiftPressed ?? this.isShiftPressed,
    );
  }
}
