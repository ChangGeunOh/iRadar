import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:googlemap/common/utils/mixin.dart';
import 'package:googlemap/domain/bloc/bloc_event.dart';
import 'package:googlemap/presentation/screen/login/component/web_version.dart';
import 'package:googlemap/presentation/screen/login/viewmodel/login_bloc.dart';
import 'package:googlemap/presentation/screen/login/viewmodel/login_event.dart';
import 'package:googlemap/presentation/screen/login/viewmodel/login_state.dart';

import '../../../domain/bloc/bloc_scaffold.dart';
import 'component/unsplash_copyright.dart';

class LoginScreen extends StatelessWidget with ShowMessageMixin {
  static String get routeName => 'login';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocScaffold<LoginBloc, LoginState>(
      create: (context) => LoginBloc(context, LoginState()),
      backgroundColor: const Color(0xffbb8352),
      builder: (context, bloc, state) {
        if (state.message.isNotEmpty) {
          showToast(state.message);
          bloc.add(BlocEvent(LoginEvent.onMessage, extra: ''));
        }
        return Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/images/img_login.jpg',
              width: double.infinity,
              fit: BoxFit.fill,
            ),
            Container(
              width: 640,
              height: 555,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(24),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 40.0,
                  horizontal: 56.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(
                      child: Text(
                        'Sign in',
                        style: TextStyle(
                          color: Color(0xff333333),
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          fontSize: 32,
                        ),
                      ),
                    ),
                    const SizedBox(height: 38),
                    Text(
                      'N/W O&M HQ',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 6),
                    // TextField(
                    //   controller: bloc.usernameController,
                    //   style: Theme.of(context).textTheme.bodySmall,
                    //   onSubmitted: (value) {
                    //     bloc.add(
                    //       BlocEvent(
                    //         LoginEvent.onTapLogin,
                    //       ),
                    //     );
                    //   },
                    //   onChanged: (value) {
                    //     bloc.add(
                    //         BlocEvent(LoginEvent.onUserId, extra: value));
                    //   },
                    //   decoration: InputDecoration(
                    //     contentPadding:
                    //     const EdgeInsets.symmetric(horizontal: 16),
                    //     suffixIcon: state.userId.isNotEmpty
                    //         ? IconButton(
                    //       onPressed: ()=>bloc.usernameController.clear(),
                    //       icon: const Icon(
                    //         Icons.clear,
                    //         size: 20,
                    //       ),
                    //     )
                    //         : null,
                    //     enabledBorder: const OutlineInputBorder(
                    //       borderSide: BorderSide(color: Color(0x59666666)),
                    //       borderRadius: BorderRadius.all(Radius.circular(8)),
                    //     ),
                    //     focusedBorder: const OutlineInputBorder(
                    //       borderSide: BorderSide(
                    //         color: Color(0x59666666),
                    //         width: 2,
                    //       ),
                    //       borderRadius: BorderRadius.all(Radius.circular(8)),
                    //     ),
                    //   ),
                    //   autofillHints: const [AutofillHints.name],
                    // ),
                    DropdownButtonFormField<String>(
                      value: state.userId.isNotEmpty ? state.userId : null,
                      // 선택된 값
                      style: Theme.of(context).textTheme.bodySmall,
                      onChanged: (value) {
                        // 선택된 값을 bloc에 전달
                        print("UserId> $value");
                        if (value != null) {
                          bloc.add(
                            BlocEvent(LoginEvent.onUserId, extra: value),
                          );
                        }
                      },
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0x59666666)),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x59666666),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: "강북", child: Text("강북")),
                        DropdownMenuItem(value: "강원", child: Text("강원")),
                        DropdownMenuItem(value: "강남", child: Text("강남")),
                        DropdownMenuItem(value: "서부", child: Text("서부")),
                        DropdownMenuItem(value: "부산", child: Text("부산")),
                        DropdownMenuItem(value: "울산", child: Text("울산")),
                        DropdownMenuItem(value: "경남", child: Text("경남")),
                        DropdownMenuItem(value: "대구", child: Text("대구")),
                        DropdownMenuItem(value: "경북", child: Text("경북")),
                        DropdownMenuItem(value: "전남", child: Text("전남")),
                        DropdownMenuItem(value: "전북", child: Text("전북")),
                        DropdownMenuItem(value: "제주", child: Text("제주")),
                        DropdownMenuItem(value: "충남", child: Text("충남")),
                        DropdownMenuItem(value: "충북", child: Text("충북")),
                      ],
                      hint: const Text("지역을 선택하세요"), // 초기 상태의 힌트 텍스트
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Text(
                          'Your password',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            bloc.add(
                              BlocEvent(
                                LoginEvent.onTapHide,
                              ),
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                state.isHide
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                size: 20,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                state.isHide ? 'Show' : 'Hide',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(width: 12),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: bloc.passwordController,
                      style: Theme.of(context).textTheme.bodySmall,
                      obscureText: state.isHide,
                      onSubmitted: (value) {
                        bloc.add(
                          BlocEvent(
                            LoginEvent.onTapLogin,
                          ),
                        );
                      },
                      onChanged: (value) {
                        bloc.add(
                            BlocEvent(LoginEvent.onPassword, extra: value));
                      },
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0x59666666)),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0x59666666),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                      autofillHints: const [AutofillHints.password],
                    ),
                    const SizedBox(height: 22),
                    ElevatedButton(
                      onPressed: state.isEnableLoginButton
                          ? () {
                              bloc.add(
                                BlocEvent(
                                  LoginEvent.onTapLogin,
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 22),
                        foregroundColor: Colors.white,
                        backgroundColor: state.isEnableLoginButton
                            ? Colors.red
                            : const Color(0xffb8b8b8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              50), // Adjust the radius as needed
                        ),
                      ),
                      child: const Text(
                        'Log in',
                        style: TextStyle(
                          fontSize: 22,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text.rich(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      TextSpan(
                        text: 'By continuing, you agree to the ',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w300,
                            ),
                        children: [
                          TextSpan(
                            text: 'Terms of use',
                            style: const TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                bloc.add(
                                  BlocEvent(
                                    LoginEvent.onTapTerms,
                                  ),
                                );
                              },
                          ),
                          const TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w200,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                bloc.add(
                                  BlocEvent(
                                    LoginEvent.onTapPolicy,
                                  ),
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 36),
                    Row(
                      children: [
                        InkWell(
                          onTap: () => bloc.add(
                            BlocEvent(
                              LoginEvent.onTapIssue,
                            ),
                          ),
                          child: Text(
                            'Other Issue with sign in',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  decoration: TextDecoration.underline,
                                ),
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () => bloc.add(
                            BlocEvent(
                              LoginEvent.onTapPassword,
                            ),
                          ),
                          child: Text(
                            'Forget your password',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  decoration: TextDecoration.underline,
                                ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const Positioned(
              left: 24,
              bottom: 24,
              child: WebVersion(),
            ),
            const Positioned(
              right: 24,
              bottom: 24,
              child: UnsplashCopyright(),
            ),
          ],
        );
      },
    );
  }
}
