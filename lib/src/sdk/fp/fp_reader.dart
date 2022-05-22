/// `Reader<R, A>` allows to read values `A` from a dependency/context `R`
/// without explicitly passing the dependency between multiple nested
/// function calls.
///
/// Minimalist implementation - most functions commented out as not used
class Reader<R, A> {
  final A Function(R r) _read;

  /// Build a [Reader] given `A Function(R)`.
  const Reader(this._read);

  /// Provide the value `R` (dependency) and extract result `A`.
  A run(R r) => _read(r);
}
