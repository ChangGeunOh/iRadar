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
  final passwordController = TextEditingController(text: "");
  final usernameController = TextEditingController(text: "");

  LoginBloc(super.context, super.initialState) {
    _init();
  }

  void _init() {}

  @override
  Future<FutureOr<void>> onBlocEvent(
      BlocEvent<LoginEvent> event, Emitter<LoginState> emit) async {
    // print(event.toString());
    switch (event.type) {
      case LoginEvent.init:
        break;
      case LoginEvent.onLocation:
        emit(
          state.copyWith(
            location: event.extra,
            isEnableLogin: state.location != null &&
                state.password.length > 4 &&
                state.location!.isNotEmpty,
          ),
        );
        break;
      case LoginEvent.onPassword:
        final password = event.extra as String;
        emit(
          state.copyWith(
            password: password,
            isEnableLogin: state.location != null &&
                state.password.length > 4 &&
                state.location!.isNotEmpty,
          ),
        );
        break;
      case LoginEvent.onUserId:
        emit(state.copyWith(userId: event.extra));
        break;
      case LoginEvent.onTapIssue:
        break;
      case LoginEvent.onTapLogin:
        final userid = usernameController.value.text;
        final password = passwordController.value.text;
        final responseData = await repository.login(
          userid: userid,
          password: password,
        );
        if (responseData.meta.code == 200) {
          await repository.loadUserData();
          if (context.mounted) {
            context.goNamed(MainScreen.routeName);
          }
        } else {
          emit(state.copyWith(message: responseData.meta.message));
          passwordController.clear();
        }
        break;
      case LoginEvent.onTapHide:
        emit(state.copyWith(isHide: !state.isHide));
        break;
      // TODO: Handle this case.
      case LoginEvent.onTapPolicy:
      // TODO: Handle this case.
      case LoginEvent.onTapTerms:
      // TODO: Handle this case.
      case LoginEvent.onTapPassword:
      // TODO: Handle this case.
      case LoginEvent.onMessage:
        emit(state.copyWith(message: event.extra));
        break;
    }
  }

  // Future<void> onTap(LoginTapType tapType, Emitter<LoginState> emit) async {
  //   switch (tapType) {
  //     case LoginTapType.login:
  //       final isSuccess = await repository.login(
  //         location: state.location!,
  //         password: state.password!,
  //       );
  //       add(BlocEvent(LoginEvent.onLogin, extra: isSuccess));
  //       break;
  //     case LoginTapType.hide:
  //       emit(state.copyWith(isHide: !state.isHide));
  //       break;
  //     default:
  //   }
  // }

  @override
  Future<void> close() {
    passwordController.dispose();
    usernameController.dispose();
    return super.close();
  }
}
