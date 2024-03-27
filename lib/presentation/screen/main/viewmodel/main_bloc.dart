import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:googlemap/domain/bloc/bloc_bloc.dart';
import 'package:googlemap/domain/model/map/area_data.dart';
import 'package:googlemap/domain/model/enum/wireless_type.dart';
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
        await _getAreaList(emit, state);
        break;
      case MainEvent.onTapRefresh:
        await _getAreaList(emit, state);
        break;
      case MainEvent.onTapType:
        final filteredAreaDataList = state.areaDataList
            .where((element) => element.type == event.extra || element.type == WirelessType.all)
            .toList();
        emit(state.copyWith(
          type: event.extra,
          filteredAreaDataList: filteredAreaDataList,
        ));
        break;
      case MainEvent.onDelete:
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
        context.pushNamed(UploadScreen.routeName);
        break;
      case MainEvent.onTapShiftKey:
        emit(state.copyWith(isShiftPressed: event.extra));
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
