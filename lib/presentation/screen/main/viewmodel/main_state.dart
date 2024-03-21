import '../../../../domain/model/chart_table_data.dart';
import '../../../../domain/model/map_base_data.dart';
import '../../../../domain/model/response/meta_data.dart';
import '../../../../domain/model/place_data.dart';
import '../../../../domain/model/wireless_type.dart';

class MainState {
  final List<PlaceData>? placeList;
  final MapBaseData? mapBaseData;
  final ChartTableData? chartTableData;
  final MetaData metaData;
  final String search;
  final WirelessType type;
  final bool isShowSide;
  final PlaceData? placeData;
  final bool isRemove;
  final bool isLoading;
  final bool hasMoreData;
  final Set<PlaceData> selectedPlaceSet;

  MainState({
    this.placeList,
    this.mapBaseData,
    this.chartTableData,
    MetaData? metaData,
    String? search,
    WirelessType? type,
    bool? isShowSide,
    this.placeData,
    bool? isRemove,
    bool? isLoading,
    bool? hasMoreData,
    Set<PlaceData>? selectedPlaceSet,
  })  : type = type ?? WirelessType.w5G,
        metaData = metaData ??
            MetaData(
              code: 0,
              message: "",
            ),
        search = search ?? "",
        isShowSide = isShowSide ?? true,
        isRemove = isRemove ?? false,
        isLoading = isLoading ?? false,
        hasMoreData = hasMoreData ?? true,
        selectedPlaceSet = selectedPlaceSet ?? <PlaceData>{};

  MainState copyWith({
    List<PlaceData>? placeList,
    MapBaseData? mapBaseData,
    ChartTableData? chartTableData,
    MetaData? metaData,
    String? search,
    WirelessType? type,
    bool? isShowSide,
    PlaceData? placeData,
    bool? isRemove,
    bool? isLoading,
    bool? hasMoreData,
    Set<PlaceData>? selectedPlaceSet,
  }) {
    return MainState(
      placeList: placeList ?? this.placeList,
      mapBaseData: mapBaseData ?? this.mapBaseData,
      chartTableData: chartTableData ?? this.chartTableData,
      metaData: metaData ?? this.metaData,
      search: search ?? this.search,
      type: type ?? this.type,
      isShowSide: isShowSide ?? this.isShowSide,
      placeData: placeData ?? this.placeData,
      isRemove: isRemove ?? this.isRemove,
      isLoading: isLoading ?? this.isLoading,
      hasMoreData: hasMoreData ?? this.hasMoreData,
      selectedPlaceSet: selectedPlaceSet ?? this.selectedPlaceSet,
    );
  }
}
