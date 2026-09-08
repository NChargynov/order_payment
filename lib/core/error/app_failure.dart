enum AppFailureType {
  network,
  server,
  validation,
  invalidData,
  cancelled,
  unknown,
}

class AppFailure implements Exception {
  const AppFailure(
    this.message, {
    this.type = AppFailureType.unknown,
    this.statusCode,
  });

  final String message;
  final AppFailureType type;
  final int? statusCode;

  @override
  String toString() => message;
}
