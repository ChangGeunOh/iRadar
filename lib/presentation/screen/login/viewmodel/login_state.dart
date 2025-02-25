class LoginState {
  final bool isHide;
  final String? location;
  final String password;
  final String userId;
  final bool isEnableLogin;
  final String message;

  LoginState({
    bool? isHide,
    this.userId = '',
    this.location,
    this.password = '',
    bool? isEnableLogin,
    this.message = '',
  })  : isHide = isHide ?? true,
        isEnableLogin = isEnableLogin ?? false;

  LoginState copyWith({
    String? userId,
    bool? isHide,
    String? location,
    String? password,
    bool? isEnableLogin,
    String? message,
  }) {
    return LoginState(
      userId: userId ?? this.userId,
      isHide: isHide ?? this.isHide,
      location: location ?? this.location,
      password: password ?? this.password,
      isEnableLogin: isEnableLogin ?? this.isEnableLogin,
      message: message ?? this.message,
    );
  }

  // bool get isEnableLoginButton => userId.length > 4 && password.length > 4;
  bool get isEnableLoginButton => true;
}
