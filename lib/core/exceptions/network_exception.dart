class NetworkException implements Exception {
  final String message;

  const NetworkException(this.message);
}

class ResourceNotFoundException implements Exception {
  final String message;

  const ResourceNotFoundException(this.message);
}

class ServerException implements Exception {
  final String message;

  const ServerException(this.message);
}

class TimeoutException implements Exception {
  final String message;

  const TimeoutException(this.message);
}

class RequestCanceledException implements Exception {
  final String message;

  const RequestCanceledException(this.message);
}
