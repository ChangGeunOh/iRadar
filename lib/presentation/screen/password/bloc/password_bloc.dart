import 'dart:async';

import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../domain/bloc/bloc_bloc.dart';
import '../../../../domain/bloc/bloc_event.dart';
import 'password_event.dart';
import 'password_state.dart';

class PasswordBloc extends BlocBloc<BlocEvent<PasswordEvent>, PasswordState> {
  PasswordBloc(super.context, super.initialState) {
    init();
  }

  void init() {
    add(BlocEvent(PasswordEvent.onInit));
  }

  final oldController = TextEditingController();
  final newController = TextEditingController();
  final checkController = TextEditingController();

  @override
  FutureOr<void> onBlocEvent(
      BlocEvent<PasswordEvent> event, Emitter<PasswordState> emit) async {
    switch (event.type) {
      case PasswordEvent.onInit:
        break;
      case PasswordEvent.onTapChange:
        emit(state.copyWith(isLoading: true));
        final response = await repository.loadPasswordChange(
          state.oldPassword,
          state.newPassword,
        );
        emit(state.copyWith(isLoading: false, message: response.meta.message));
        if (response.meta.code == 200 && context.mounted) {
          context.pop();
        }
        break;
      case PasswordEvent.onChangeOld:
        await _checkPassword(
          emit,
          event.extra,
          state.newPassword,
          state.newPasswordCheck,
        );
        break;
      case PasswordEvent.onChangeNew:
        _checkPassword(
          emit,
          state.oldPassword,
          event.extra,
          state.newPasswordCheck,
        );
        break;
      case PasswordEvent.onChangeNewCheck:
        _checkPassword(
          emit,
          state.oldPassword,
          state.newPassword,
          event.extra,
        );
        break;
      case PasswordEvent.onShowMessage:
        emit(state.copyWith(message: event.extra ?? ''));
        break;
    }
  }

  Future<void> _checkPassword(
    Emitter<PasswordState> emit,
    String oldPassword,
    String newPassword,
    String newPasswordCheck,
  ) async {
    if (newPassword.length < 8 || newPassword.length > 15) {
      emit(state.copyWith(
        errorMessage: "8-15자리의 영문/숫자/특수문자를 함께 입력해 주세요",
        oldPassword: oldPassword,
        newPassword: newPassword,
        newPasswordCheck: newPasswordCheck,
      ));
      return;
    }

    if (newPassword != newPasswordCheck) {
      emit(state.copyWith(
        errorMessage: "비밀번호가 일치하지 않습니다",
        oldPassword: oldPassword,
        newPassword: newPassword,
        newPasswordCheck: newPasswordCheck,
      ));
      return;
    }

    if (newPassword == oldPassword) {
      emit(state.copyWith(
        errorMessage: "기존 비밀번호와 동일합니다",
        oldPassword: oldPassword,
        newPassword: newPassword,
        newPasswordCheck: newPasswordCheck,
      ));
      return;
    }

    emit(state.copyWith(errorMessage: ""));
  }
}
