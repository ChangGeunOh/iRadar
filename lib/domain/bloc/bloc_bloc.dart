import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repository/repository.dart';

abstract class BlocBloc<Event, StateT> extends Bloc<Event, StateT> {
  final BuildContext context;
  final Repository repository;

  BlocBloc(this.context, StateT initialState)
      : repository = context.read(),
        super(initialState) {
    on<Event>(onBlocEvent);
  }

  FutureOr<void> onBlocEvent(Event event, Emitter<StateT> emit);

  void event(Event event) {
    onEvent(event);
  }
}
