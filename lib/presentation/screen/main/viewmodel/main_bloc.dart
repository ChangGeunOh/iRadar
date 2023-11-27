import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:googlemap/domain/bloc/bloc_bloc.dart';
import 'package:googlemap/domain/model/place_data.dart';
import 'package:googlemap/presentation/screen/main/viewmodel/main_event.dart';
import 'package:googlemap/presentation/screen/main/viewmodel/main_state.dart';
import 'package:googlemap/presentation/screen/upload/upload_screen.dart';

import '../../../../domain/bloc/bloc_event.dart';

class MainBloc extends BlocBloc<BlocEvent<MainEvent>, MainState> {
  final PageController pageController = PageController(
    initialPage: 0,
  );

  MainBloc(super.context, super.initialState) {
    _init();
  }

  void _init() async {
    add(BlocEvent(MainEvent.isLoading, extra: true));
    final placeList = await repository.loadPlaceList(state.type);
    add(BlocEvent(MainEvent.init, extra: placeList));
  }

  @override
  FutureOr<void> onBlocEvent(
    BlocEvent<MainEvent> event,
    Emitter<MainState> emit,
  ) async {
    print('Event>${event.type.toString()}');
    switch (event.type) {
      case MainEvent.init:
        emit(state.copyWith(placeList: event.extra, isLoading: false));
        break;
      case MainEvent.onTapType:
        emit(state.copyWith(isLoading: true, placeList: List.empty()));
        final list = await repository.loadPlaceList(event.extra);
        emit(state.copyWith(
            placeList: list, type: event.extra, isLoading: false));
        break;
      case MainEvent.onDelete:
        break;
      case MainEvent.onSearch:
        var list = await repository.loadPlaceList(state.type);
        list = list
            .where((element) => element.name.contains(event.extra))
            .toList();
        print(
            'Search>${event.extra} :; Size>${state.placeList?.length} :: List>${list.length}');
        emit(state.copyWith(placeList: list, search: event.extra));
        break;
      case MainEvent.onTapDrawer:
        emit(state.copyWith(isShowSide: !state.isShowSide));
        break;
      case MainEvent.onTapItem:
        final PlaceData placeData = event.extra;
        emit(state.copyWith(
          placeData: event.extra,
          selectedPlaceSet: {placeData},
        ));
        // Loading MapDataList and Loading ChartDataList
        // final mapBaseList = await repository.loadMapBaseData(placeData);
        // emit(state.copyWith(
        //   mapBaseData: mapBaseList,
        // ));
        // final chartTableList = await repository.loadChartTableData(placeData);
        // emit(state.copyWith(
        //   chartTableData: chartTableList,
        // ));
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
      case MainEvent.onTapRefresh:
        emit(state.copyWith(isLoading: true, placeList: List.empty()));
        await repository.remove(state.type);
        final list = await repository.loadPlaceList(state.type);
        emit(state.copyWith(
            placeList: list, type: event.extra, isLoading: false));
        break;
      case MainEvent.onMoreLoading:
        emit(state.copyWith(isLoading: true));
        final list = await repository.loadPlaceList(state.type);
        emit(state.copyWith(placeList: list, isLoading: false));
        break;
      case MainEvent.onTapMenu:
        context.pushNamed(UploadScreen.routeName);
        break;
      case MainEvent.onTapItemWithShift:
        final PlaceData placeData = event.extra;
        var selectedPlace = state.selectedPlaceSet;
        if (selectedPlace.contains(placeData)) {
          selectedPlace.remove(placeData);
        } else {
          selectedPlace.add(placeData);
        }
        emit(state.copyWith(selectedPlaceSet: selectedPlace));
        break;
    }
  }

  Future<List<PlaceData>> readSampleData() async {
    final List<PlaceData> list = List.empty(growable: true);
    String lines = await rootBundle.loadString('assets/files/sample_data.csv');
    // LineSplitter.split(lines).forEach((line) {
    //   final values = line.split(',');
    //   final measureData = PlaceData.fromLine(values);
    //   list.add(measureData);
    // });
    return list;
  }

  void loadMore() {
    if (repository.hasMorePlaceList(state.type)) {
      add(BlocEvent(MainEvent.onMoreLoading));
    }
  }
}
