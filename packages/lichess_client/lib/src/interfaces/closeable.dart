/// Generic interface for closeable resources.
mixin CloseableMixin {
  /// Close any resources associated with this object.
  Future<void> close({bool force = false});
}
