import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googlemap/common/const/constants.dart';
import 'package:googlemap/domain/bloc/bloc_event.dart';
import 'package:googlemap/domain/bloc/bloc_layout.dart';
import 'package:googlemap/presentation/screen/login/viewmodel/login_bloc.dart';
import 'package:googlemap/presentation/screen/login/viewmodel/login_event.dart';
import 'package:googlemap/presentation/screen/login/viewmodel/login_state.dart';

import 'component/unsplash_copyright.dart';

class LoginScreen extends StatelessWidget {
  static String get routeName => 'login';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocLayout<LoginBloc, LoginState>(
      create: (context) => LoginBloc(context, LoginState()),
      builder: (context, bloc, state) {
        return Scaffold(
          backgroundColor: const Color(0xffbb8352),
          body: Stack(
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
                        'Select Location',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField(
                        items: dropdownItems,
                        hint: Text(
                          '지역을 선택하세요.',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        onChanged: (value) {
                          bloc.add(
                            BlocEvent(
                              LoginEvent.onLocation,
                              extra: value,
                            ),
                          );
                        },
                        style: Theme.of(context).textTheme.bodySmall,
                        elevation: 1,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 19,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0x59666666)),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0x59666666)),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                        ),
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
                              print('onTap');
                              bloc.add(
                                BlocEvent(
                                  LoginEvent.onTap,
                                  extra: LoginTapType.hide,
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
                              LoginEvent.onTap,
                              extra: LoginTapType.login,
                            ),
                          );
                        },
                        onChanged: (value) {
                          bloc.add(
                              BlocEvent(LoginEvent.onPassword, extra: value));
                        },
                        decoration: const InputDecoration(
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
                      ),
                      const SizedBox(height: 22),
                      ElevatedButton(
                        onPressed: () {
                          bloc.add(
                            BlocEvent(
                              LoginEvent.onTap,
                              extra: LoginTapType.login,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 22),
                          foregroundColor: Colors.white,
                          backgroundColor: state.isEnableLogin
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
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
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
                                      LoginEvent.onTap,
                                      extra: LoginTapType.terms,
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
                                      LoginEvent.onTap,
                                      extra: LoginTapType.policy,
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
                                LoginEvent.onTap,
                                extra: LoginTapType.issue,
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
                                LoginEvent.onTap,
                                extra: LoginTapType.password,
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
                right: 24,
                bottom: 24,
                child: UnsplashCopyright(),
              ),
            ],
          ),
        );
      },
    );
  }
}
