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
  final passwordController = TextEditingController(text: "00000000");
  final useridController = TextEditingController(text: "12345678");

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
      // case LoginEvent.onLogin:
      //   if (event.extra) {
      //     context.goNamed(MainScreen.routeName);
      //   } else {
      //     passwordController.clear();
      //   }
      //   break;
      case LoginEvent.onUserId:
        emit(state.copyWith(userId: event.extra));
        break;
      case LoginEvent.onTapIssue:
      // TODO: Handle this case.
      case LoginEvent.onTapLogin:
        final userid = useridController.value.text;
        final password = passwordController.value.text;
        final responseData = await repository.login(
          userid: userid,
          password: password,
        );
        if (responseData.meta.code == 200) {
          // final tokenData = await repository.loadTokenData(
          //   userid: userid,
          //   password: password,
          // );
          add(BlocEvent(LoginEvent.onNextScreen, extra: MainScreen.routeName));
        } else {
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
      case LoginEvent.onNextScreen:
        context.goNamed(event.extra);
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
    useridController.dispose();
    return super.close();
  }
}
