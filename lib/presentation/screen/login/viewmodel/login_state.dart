class LoginState {
  final bool isHide;
  final String? location;
  final String password;
  final String userId;
  final bool isEnableLogin;

  LoginState({
    bool? isHide,
    this.userId = '12345678',
    this.location,
    this.password = '00000000',
    bool? isEnableLogin,
  })  : isHide = isHide ?? true,
        isEnableLogin = isEnableLogin ?? false;

  LoginState copyWith({
    String? userId,
    bool? isHide,
    String? location,
    String? password,
    bool? isEnableLogin,
  }) {
    return LoginState(
      userId: userId ?? this.userId,
      isHide: isHide ?? this.isHide,
      location: location ?? this.location,
      password: password ?? this.password,
      isEnableLogin: isEnableLogin ?? this.isEnableLogin,
    );
  }

  // bool get isEnableLoginButton => userId.length > 4 && password.length > 4;
  bool get isEnableLoginButton => true;
}
