class MissingPermissionException implements Exception {
  final String message;

  MissingPermissionException(this.message);

  @override
  String toString() => message;
}
