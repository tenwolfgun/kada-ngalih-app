class ServerException implements Exception {
  final String message;

  ServerException(this.message);
}

class PermissionDeniedException implements Exception {
  final String message;

  PermissionDeniedException(this.message);
}

class ConnectionException implements Exception {}
