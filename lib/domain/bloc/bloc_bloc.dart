import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repository/repository.dart';

abstract class BlocBloc<Event, State> extends Bloc<Event, State> {
  final BuildContext context;
  final Repository repository;

  BlocBloc(this.context, State initialState)
      : repository = context.read(),
        super(initialState) {
    on<Event>(onBlocEvent);
  }

  FutureOr<void> onBlocEvent(Event event, Emitter<State> emit);

  void event(Event event) {
    onEvent(event);
  }
}
