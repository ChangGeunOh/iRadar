class LoginState {
  final bool isHide;
  final String? location;
  final String? password;
  final bool isEnableLogin;

  LoginState({
    bool? isHide,
    this.location,
    this.password,
    bool? isEnableLogin,
  })  : isHide = isHide ?? true,
        isEnableLogin = isEnableLogin ?? false;

  LoginState copyWith({
    bool? isHide,
    String? location,
    String? password,
    bool? isEnableLogin,
  }) {
    return LoginState(
      isHide: isHide ?? this.isHide,
      location: location ?? this.location,
      password: password ?? this.password,
      isEnableLogin: isEnableLogin ?? this.isEnableLogin,
    );
  }
}
