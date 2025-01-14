class Val {
  Val({required this.error, required this.isFocus});
  final String? error;
  final bool isFocus;

  bool get hasError => error != null;

  factory Val.dd() => Val(
        error: null,
        isFocus: false,
      );

  @override
  operator ==(covariant Val other) =>
      other.hasError == hasError &&
      other.isFocus == isFocus &&
      other.error == error;

  @override
  int get hashCode => hasError.hashCode ^ isFocus.hashCode ^ error.hashCode;

  Val copyWith({
    String? error,
    bool? isFocus,
  }) {
    return Val(
      error: (error?.isEmpty ?? false ? null : error ?? this.error),
      isFocus: isFocus ?? this.isFocus,
    );
  }

  @override
  String toString() {
    return 'error -> $error, isFocus -> $isFocus';
  }
}
