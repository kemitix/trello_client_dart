extension ListHead<T> on List<T> {
  T? get head => isEmpty ? null : this[0];
}
