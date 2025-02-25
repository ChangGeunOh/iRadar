
class PasswordState {
  final String message;
  final bool isLoading;
  final String errorMessage;
  final String oldPassword;
  final String newPassword;
  final String newPasswordCheck;
  PasswordState({
    this.message = '',
    this.isLoading = false,
    this.errorMessage = '8-15자리의 영문/숫자/특수문자를 함께 입력해 주세요',
    this.oldPassword = '',
    this.newPassword = '',
    this.newPasswordCheck = '',
  });

  PasswordState copyWith({
    String? message,
    bool? isLoading,
    String? errorMessage,
    String? oldPassword,
    String? newPassword,
    String? newPasswordCheck,
  }) {
    return PasswordState(
      message: message ?? this.message,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      oldPassword: oldPassword ?? this.oldPassword,
      newPassword: newPassword ?? this.newPassword,
      newPasswordCheck: newPasswordCheck ?? this.newPasswordCheck,
    );
  }
}
