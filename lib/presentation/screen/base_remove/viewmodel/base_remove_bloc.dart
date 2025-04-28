import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/bloc/bloc_bloc.dart';
import '../../../../domain/bloc/bloc_event.dart';
import 'base_remove_event.dart';
import 'base_remove_state.dart';

class BaseRemoveBloc
    extends BlocBloc<BlocEvent<BaseRemoveEvent>, BaseRemoveState> {
  BaseRemoveBloc(
    super.context,
    super.initialState,
  ) {
    add(BlocEvent(BaseRemoveEvent.init));
  }

  @override
  Future<void> onBlocEvent(
    BlocEvent<BaseRemoveEvent> event,
    Emitter<BaseRemoveState> emit,
  ) async {
    switch (event.type) {
      case BaseRemoveEvent.init:
        emit(state.copyWith(
          isLoading: true,
        ));
        final responseData = await repository.getBaseDataList();
        emit(state.copyWith(
          baseDataList: responseData.data,
          filteredBaseDataList: responseData.data,
        ));
        emit(state.copyWith(
          isLoading: false,
        ));
        break;
      case BaseRemoveEvent.onClose:
        emit(state.copyWith(
          searchText: state.searchText.isNotEmpty ? '' : state.searchText,
          isSearch: state.searchText.isEmpty ? false : state.isSearch,
        ));
        break;
      case BaseRemoveEvent.onSearch:
        emit(state.copyWith(
          isSearch: true,
        ));
        break;
      case BaseRemoveEvent.onTapSelectAll:
        final Set<int> idSet = !state.isSelectAll
            ? Set<int>.from(
                state.filteredBaseDataList.map((value) => value.idx))
            : {};
        emit(state.copyWith(
          isSelectAll: !state.isSelectAll,
          idSet: idSet,
        ));
        break;
      case BaseRemoveEvent.onTapSelect:
        print('BaseRemoveEvent.onTapSelect');
        final index = event.extra['id'] as int;
        final selected = event.extra['selected'] as bool;
        final idSet = Set<int>.from(state.idSet);
        if (selected) {
          idSet.add(index);
        } else {
          idSet.remove(index);
        }
        emit(state.copyWith(
          idSet: idSet,
        ));
      case BaseRemoveEvent.onSearchText:
        final searchText = event.extra as String;
        final filtered = state.baseDataList
            .where((element) =>
                element.code.toLowerCase().contains(searchText.toLowerCase()) ||
                element.rnm.toLowerCase().contains(searchText.toLowerCase()))
            .toList();
        emit(state.copyWith(
          searchText: searchText,
          filteredBaseDataList: filtered,
          isSelectAll: false,
          idSet: const {},
        ));
      case BaseRemoveEvent.onTapDelete:
        final response =
            await repository.deleteBaseDataList(state.idSet.toList());
        if (response.meta.code == 200) {
          final baseDataList = state.baseDataList
              .where((element) => !state.idSet.contains(element.idx))
              .toList();
          emit(state.copyWith(
            isSelectAll: false,
            idSet: const {},
            baseDataList: baseDataList,
            filteredBaseDataList: baseDataList,
          ));
        }
        break;
    }
  }
}
