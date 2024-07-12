import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:googlemap/domain/bloc/bloc_bloc.dart';
import 'package:googlemap/domain/model/map/area_data.dart';
import 'package:googlemap/domain/model/enum/wireless_type.dart';
import 'package:googlemap/presentation/screen/login/login_screen.dart';
import 'package:googlemap/presentation/screen/main/viewmodel/main_event.dart';
import 'package:googlemap/presentation/screen/main/viewmodel/main_state.dart';
import 'package:googlemap/presentation/screen/upload/upload_screen.dart';

import '../../../../domain/bloc/bloc_event.dart';

class MainBloc extends BlocBloc<BlocEvent<MainEvent>, MainState> {
  final PageController pageController = PageController(
    initialPage: 0,
  );

  final focusNode = FocusNode();

  MainBloc(super.context, super.initialState) {
    _init();
  }

  void _init() async {
    add(BlocEvent(MainEvent.init));
  }

  @override
  FutureOr<void> onBlocEvent(
    BlocEvent<MainEvent> event,
    Emitter<MainState> emit,
  ) async {
    switch (event.type) {
      case MainEvent.init:
        final userData = await repository.getUserData();
        print('userData>$userData');
        emit(state.copyWith(userData: userData));
        await _getAreaList(emit, state);
        break;
      case MainEvent.onTapRefresh:
        await _getAreaList(emit, state);
        break;
      case MainEvent.onTapType:
        final filteredAreaDataList = state.areaDataList
            .where((element) =>
                element.type == event.extra || element.type == WirelessType.all)
            .toList();
        emit(state.copyWith(
          type: event.extra,
          filteredAreaDataList: filteredAreaDataList,
        ));
        break;
      case MainEvent.onDelete:
        final areaData = event.extra as AreaData;
        emit(state.copyWith(isLoading: true));
        final response = await repository.deleteAreaData(areaData);
        emit(state.copyWith(
            message: response.meta.code == 200
                ? '측정 데이터를 삭제 했습니다.'
                : '삭제 중 오류가 발생 했습니다.'));
        if (response.meta.code == 200) {
          await _getAreaList(emit, state);
        }
        emit(state.copyWith(isLoading: false));
        if (context.mounted) {
          context.pop();
        }
        break;
      case MainEvent.onSearch:
        final filteredAreaDataList = state.areaDataList
            .where((element) => element.name.contains(event.extra))
            .toList();
        emit(state.copyWith(
            search: event.extra, filteredAreaDataList: filteredAreaDataList));
        break;
      case MainEvent.onTapDrawer:
        emit(state.copyWith(isShowSide: !state.isShowSide));
        break;
      case MainEvent.onTapItem:
        final AreaData areaData = event.extra;
        Set<AreaData> selectedAreaDataSet;
        if (state.isShiftPressed) {
          selectedAreaDataSet = Set.from(state.selectedAreaDataSet);
          if (selectedAreaDataSet.contains(areaData)) {
            selectedAreaDataSet.remove(areaData);
          } else {
            selectedAreaDataSet.add(areaData);
          }
        } else {
          selectedAreaDataSet = {areaData};
        }
        emit(state.copyWith(
          selectedAreaDataSet: selectedAreaDataSet,
        ));
        break;
      case MainEvent.onTapItemAll:
        emit(state.copyWith(placeData: event.extra, isRemove: false));
        break;
      case MainEvent.onTapItemRemove:
        emit(state.copyWith(placeData: event.extra, isRemove: true));
        break;
      case MainEvent.isLoading:
        emit(state.copyWith(isLoading: event.extra));
        break;
      case MainEvent.onTapMenu:
        break;
      case MainEvent.onTapItemWithShift:
        final AreaData areaData = event.extra;
        var selectedPlace = state.selectedAreaDataSet;
        if (selectedPlace.contains(areaData)) {
          selectedPlace.remove(areaData);
        } else {
          selectedPlace.add(areaData);
        }
        emit(state.copyWith(selectedAreaDataSet: selectedPlace));
        break;
      case MainEvent.onTapUpload:
        final result = await context.pushNamed(UploadScreen.routeName);
        print('Result>${result.runtimeType}');
        if (result != null && result.runtimeType == bool && result as bool) {
          add(BlocEvent(MainEvent.onTapRefresh));
        }
        break;
      case MainEvent.onTapShiftKey:
        emit(state.copyWith(isShiftPressed: event.extra));
        break;
      case MainEvent.onShowDialog:
        emit(state.copyWith(isShowDialog: event.extra));
        break;
      case MainEvent.onTapNoticePage:
        print('onTapNoticePage>${event.extra}');
        emit(state.copyWith(currentPage: event.extra + 1));
        break;
      case MainEvent.onLogout:
        await repository.logout();
        if (context.mounted) {
          context.goNamed(LoginScreen.routeName);
        }
        break;
      case MainEvent.onPassword:
        break;
    }
  }

  Future<void> _getAreaList(Emitter<MainState> emit, MainState state) async {
    emit(state.copyWith(isLoading: true));
    final responseData = await repository.getAreaList();
    emit(state.copyWith(
      message: responseData.meta.message,
      areaDataList: responseData.data,
      filteredAreaDataList: _getFilteredAreaDataList(
        responseData.data,
        state.search,
        state.type,
      ),
      isLoading: false,
    ));
  }

  List<AreaData> _getFilteredAreaDataList(
    List<AreaData>? areaDataList,
    String search,
    WirelessType type,
  ) {
    if (areaDataList == null) {
      return [];
    }
    return areaDataList
        .where((element) => element.name.contains(search))
        .where((element) =>
            element.type == type || element.type == WirelessType.all)
        .toList();
  }
}
