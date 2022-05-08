extension ListHead<T> on List<T> {
 T? get head => this.isEmpty ? null : this[0];
}
