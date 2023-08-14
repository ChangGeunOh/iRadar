import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:googlemap/domain/bloc/bloc_bloc.dart';
import 'package:googlemap/domain/bloc/bloc_event.dart';
import 'package:googlemap/presentation/screen/login/viewmodel/login_event.dart';
import 'package:googlemap/presentation/screen/login/viewmodel/login_state.dart';
import 'package:googlemap/presentation/screen/main/main_screen.dart';

class LoginBloc extends BlocBloc<BlocEvent<LoginEvent>, LoginState> {
  final passwordController = TextEditingController();

  LoginBloc(super.context, super.initialState) {
    _init();
  }

  void _init() {}

  @override
  FutureOr<void> onBlocEvent(
      BlocEvent<LoginEvent> event, Emitter<LoginState> emit) {
    // print(event.toString());
    switch (event.type) {
      case LoginEvent.onLocation:
        emit(
          state.copyWith(
            location: event.extra,
            isEnableLogin: state.password != null &&
                state.location != null &&
                state.password!.length > 4 &&
                state.location!.isNotEmpty,
          ),
        );
        break;
      case LoginEvent.onPassword:
        final password = event.extra as String;
        emit(
          state.copyWith(
            password: password,
            isEnableLogin: state.password != null &&
                state.location != null &&
                state.password!.length > 4 &&
                state.location!.isNotEmpty,
          ),
        );
        break;
      case LoginEvent.onTap:
        onTap(event.extra, emit);
        break;
      case LoginEvent.onLogin:
        print('loginResult>${event.extra}');
        if (event.extra) {
          context.goNamed(MainScreen.routeName);
        } else {
          passwordController.clear();
        }
        break;
      case LoginEvent.init:
        break;
    }
  }

  void onTap(LoginTapType tapType, Emitter<LoginState> emit) async {
    switch (tapType) {
      case LoginTapType.login:
        final isSuccess = await repository.login(
          location: state.location!,
          password: state.password!,
        );
        add(BlocEvent(LoginEvent.onLogin, extra: isSuccess));
        break;
      case LoginTapType.hide:
        emit(state.copyWith(isHide: !state.isHide));
        break;
      default:
    }
  }

  @override
  Future<void> close() {
    passwordController.dispose();
    return super.close();
  }
}
