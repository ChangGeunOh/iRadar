import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googlemap/domain/model/pci/pci_base_data.dart';
import '../../../../domain/bloc/bloc_bloc.dart';
import '../../../../domain/bloc/bloc_event.dart';
import 'pci_event.dart';
import 'pci_state.dart';

class PciBloc extends BlocBloc<BlocEvent<PciEvent>, PciState> {
  PciBloc(super.context, super.initialState) {
    add(BlocEvent(PciEvent.init));
  }

  @override
  Future<FutureOr<void>> onBlocEvent(
    BlocEvent<PciEvent> event,
    Emitter<PciState> emit,
  ) async {
    switch (event.type) {
      case PciEvent.init:
        emit(state.copyWith(isLoading: true));
        final response = await repository.loadPciData(
          type: state.type,
          idx: state.idx,
          spci: state.spci,
        );
        if (response.meta.code == 200) {
          final data = response.data as PciBaseData;
          print(data.toJson());
          emit(state.copyWith(
            isLoading: false,
            pciBaseData: response.data,
          ));
        } else {
          emit(state.copyWith(
            isLoading: false,
            message: response.meta.message,
          ));
        }
        break;
    }
  }
}
