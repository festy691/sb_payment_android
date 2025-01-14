extension ExtendedIterableWithType<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

extension ExtendedDoubleIterable on Iterable<double> {
  double get sum =>
      isNotEmpty ? reduce((value, element) => value + element) : 0;
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
