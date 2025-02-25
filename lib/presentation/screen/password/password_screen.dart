import 'package:flutter/material.dart';
import 'package:googlemap/common/const/color.dart';
import 'package:googlemap/common/utils/mixin.dart';

import '../../../domain/bloc/bloc_event.dart';
import '../../../domain/bloc/bloc_scaffold.dart';
import '../../component/custom_elevated_button.dart';
import 'bloc/password_bloc.dart';
import 'bloc/password_event.dart';
import 'bloc/password_state.dart';

class PasswordScreen extends StatelessWidget with ShowMessageMixin {
  static String get routeName => 'password';

  const PasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocScaffold<PasswordBloc, PasswordState>(
      create: (context) => PasswordBloc(
        context,
        PasswordState(),
      ),
      builder: (context, bloc, state) {
        if (state.message.isNotEmpty) {
          showToast(state.message);
          bloc.add(BlocEvent(PasswordEvent.onShowMessage));
        }
        return Column(
          children: [
            const SizedBox(
              width: double.infinity,
              child: Text(
                '비밀번호 변경',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Divider(
              height: 1,
              color: Colors.grey,
            ),
            const SizedBox(height: 8),
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 48),
                      PasswordEditText(
                        onChanged: (value) {
                          bloc.add(BlocEvent(PasswordEvent.onChangeOld,
                              extra: value));
                        },
                        title: '현재 비밀번호',
                        hintText: '현재 비밀번호 입력',
                        controller: bloc.oldController,
                      ),
                      const SizedBox(height: 24),
                      PasswordEditText(
                        onChanged: (value) {
                          bloc.add(BlocEvent(PasswordEvent.onChangeNew,
                              extra: value));
                        },
                        title: '현재 비밀번호',
                        hintText: '새 비밀번호',
                        controller: bloc.newController,
                      ),
                      const SizedBox(height: 4),
                      PasswordEditText(
                        onChanged: (value) {
                          bloc.add(BlocEvent(PasswordEvent.onChangeNewCheck,
                              extra: value));
                        },
                        hintText: '새 비밀번호 재입력',
                        controller: bloc.checkController,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        state.errorMessage,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: state.errorMessage.isNotEmpty
                              ? null
                              : () {
                                  bloc.add(BlocEvent(PasswordEvent.onTapChange));
                                },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 32,
                            ),
                            foregroundColor: Colors.white,
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  50), // Adjust the radius as needed
                            ),
                          ),
                          child: const Text(
                            '비밀번호 변경',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                if (state.isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class PasswordEditText extends StatelessWidget {
  final Function(String) onChanged;
  final String? title;
  final String hintText;
  final TextEditingController controller;

  const PasswordEditText({
    super.key,
    this.title,
    required this.onChanged,
    required this.hintText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Text(
            title!,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: true,
          decoration: InputDecoration(
            fillColor: Colors.grey[200],
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            suffixIcon: IconButton(
                onPressed: () {
                  controller.clear();
                },
                icon: const Icon(
                  Icons.close,
                )),
          ),
          style: const TextStyle(
            color: Colors.black,
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
