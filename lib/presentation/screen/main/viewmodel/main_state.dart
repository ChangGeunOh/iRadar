import 'dart:typed_data';

import '../../../../domain/model/chart_table_data.dart';
import '../../../../domain/model/enum/wireless_type.dart';
import '../../../../domain/model/map/area_data.dart';
import '../../../../domain/model/map/map_base_data.dart';
import '../../../../domain/model/place_data.dart';
import '../../../../domain/model/user_data.dart';

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
  final UserData? userData;
  final bool isShowDialog;
  final int totalPage;
  final int currentPage;
  final String? noticeData;

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
    this.userData,
    this.isShowDialog = false,
    this.totalPage = 35,
    this.currentPage = 1,
    this.noticeData,
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
    UserData? userData,
    bool? isShowDialog,
    int? startPage,
    int? totalPage,
    int? currentPage,
    String? noticeData,
  }) {
    return MainState(
      userData: userData ?? this.userData,
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
      isShowDialog: isShowDialog ?? this.isShowDialog,
      totalPage: totalPage ?? this.totalPage,
      currentPage: currentPage ?? this.currentPage,
      noticeData: noticeData ?? this.noticeData,
    );
  }

  MainState clearNoticeData() {
    return MainState(
      userData: userData,
      mapBaseData: mapBaseData,
      chartTableData: chartTableData,
      search: search,
      type: type,
      isShowSide: isShowSide,
      placeData: placeData,
      isRemove: isRemove,
      isLoading: isLoading,
      selectedAreaDataSet: selectedAreaDataSet,
      areaDataList: areaDataList,
      message: message,
      filteredAreaDataList: filteredAreaDataList,
      isShiftPressed: isShiftPressed,
      isShowDialog: isShowDialog,
      totalPage: totalPage,
      currentPage: currentPage,
      noticeData: null,
    );
  }

  // MainState clearScreenCapture() {
  //   return MainState(
  //     userData: userData,
  //     mapBaseData: mapBaseData,
  //     chartTableData: chartTableData,
  //     search: search,
  //     type: type,
  //     isShowSide: isShowSide,
  //     placeData: placeData,
  //     isRemove: isRemove,
  //     isLoading: isLoading,
  //     selectedAreaDataSet: selectedAreaDataSet,
  //     areaDataList: areaDataList,
  //     message: message,
  //     filteredAreaDataList: filteredAreaDataList,
  //     isShiftPressed: isShiftPressed,
  //     screenCapture: null,
  //   );
  // }
}
