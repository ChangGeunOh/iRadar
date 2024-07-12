import 'package:googlemap/domain/model/base/base_data.dart';

class BaseState {
  final bool isLoading;
  final String message;
  final List<BaseData> baseDataList;
  final List<BaseData> errorDataList;

  BaseState({
    this.isLoading = false,
    this.message = '',
    this.baseDataList = const [],
    this.errorDataList = const [],
  });

  BaseState copyWith({
    bool? isLoading,
    String? message,
    List<BaseData>? baseDataList,
    List<BaseData>? errorDataList,
  }) {
    return BaseState(
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
      baseDataList: baseDataList ?? this.baseDataList,
      errorDataList: errorDataList ?? this.errorDataList,
    );
  }

}
