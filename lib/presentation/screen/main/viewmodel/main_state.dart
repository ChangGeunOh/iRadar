import '../../../../domain/model/meta_data.dart';
import '../../../../domain/model/place_data.dart';
import '../../../../domain/model/wireless_type.dart';

class MainState {
  final List<PlaceData>? placeList;
  final MetaData metaData;
  final String search;
  final WirelessType type;
  final bool isShowSide;
  final PlaceData? placeData;
  final bool isRemove;
  final bool isLoading;
  final bool hasMoreData;

  MainState({
    this.placeList,
    MetaData? metaData,
    String? search,
    WirelessType? type,
    bool? isShowSide,
    this.placeData,
    bool? isRemove,
    bool? isLoading,
    bool? hasMoreData,
  })  : type = type ?? WirelessType.w5G,
        metaData = metaData ??
            MetaData(
              code: 0,
              message: "",
              count: 30,
              total: 0,
              page: 0,
            ),
        search = search ?? "",
        isShowSide = isShowSide ?? true,
        isRemove = isRemove ?? false,
        isLoading = isLoading ?? false,
        hasMoreData = hasMoreData ?? true;

  MainState copyWith({
    List<PlaceData>? placeList,
    MetaData? metaData,
    String? search,
    WirelessType? type,
    bool? isShowSide,
    PlaceData? placeData,
    bool? isRemove,
    bool? isLoading,
    bool? hasMoreData,
  }) {
    return MainState(
      placeList: placeList ?? this.placeList,
      metaData: metaData ?? this.metaData,
      search: search ?? this.search,
      type: type ?? this.type,
      isShowSide: isShowSide ?? this.isShowSide,
      placeData: placeData ?? this.placeData,
      isRemove: isRemove ?? this.isRemove,
      isLoading: isLoading ?? this.isLoading,
      hasMoreData: hasMoreData ?? this.hasMoreData,
    );
  }
}
