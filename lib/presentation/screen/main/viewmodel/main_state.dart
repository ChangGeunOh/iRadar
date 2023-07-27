import '../../../../domain/model/place_data.dart';
import '../../../../domain/model/wireless_type.dart';

class MainState {
  final List<PlaceData>? placeList;
  final String search;
  final WirelessType type;
  final bool isShowSide;
  final PlaceData? placeData;
  final bool isRemove;
  final bool isLoading;

  MainState({
    this.placeList,
    String? search,
    WirelessType? type,
    bool? isShowSide,
    this.placeData,
    bool? isRemove,
    bool? isLoading,
  })  : type = type ?? WirelessType.w5G,
        search = search ?? "",
        isShowSide = isShowSide ?? true,
        isRemove = isRemove ?? false,
        isLoading = isLoading ?? false;

  MainState copyWith({
    List<PlaceData>? placeList,
    String? search,
    WirelessType? type,
    bool? isShowSide,
    PlaceData? measureData,
    bool? isRemove,
    bool? isLoading,
  }) {
    return MainState(
      placeList: placeList ?? this.placeList,
      search: search ?? this.search,
      type: type ?? this.type,
      isShowSide: isShowSide ?? this.isShowSide,
      placeData: measureData ?? this.placeData,
      isRemove: isRemove ?? this.isRemove,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
