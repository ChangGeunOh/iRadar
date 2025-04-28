import 'package:googlemap/domain/model/base/base_data.dart';

class BaseRemoveState {
  final bool isLoading;
  final String? message;
  final bool isSearch;
  final String searchText;
  final List<BaseData> baseDataList;
  final Set<int> idSet;
  final bool isSelectAll;
  final List<BaseData> filteredBaseDataList;

  const BaseRemoveState({
    this.isLoading = false,
    this.message,
    this.isSearch = false,
    this.searchText = '',
    this.baseDataList = const [],
    this.filteredBaseDataList = const [],
    this.idSet = const {},
    this.isSelectAll = false,
  });

  BaseRemoveState copyWith({
    bool? isLoading,
    String? message,
    bool? isSearch,
    String? searchText,
    List<BaseData>? baseDataList,
    Set<int>? idSet,
    bool? isSelectAll,
    List<BaseData>? filteredBaseDataList,
  }) {
    return BaseRemoveState(
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
      isSearch: isSearch ?? this.isSearch,
      searchText: searchText ?? this.searchText,
      baseDataList: baseDataList ?? this.baseDataList,
      idSet: idSet ?? this.idSet,
      isSelectAll: isSelectAll ?? this.isSelectAll,
      filteredBaseDataList: filteredBaseDataList ?? this.filteredBaseDataList,
    );
  }
}