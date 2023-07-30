class WebState {
  final String? value;

  WebState({
    this.value,
  });

  WebState copyWith({
    String? value,
  }) {
    return WebState(
      value: value ?? this.value,
    );
  }
}
