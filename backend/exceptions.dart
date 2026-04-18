// lib/core/error/exceptions.dart

class ServerException implements Exception {
  final String message;
  const ServerException(this.message);
  @override
  String toString() => 'ServerException: $message';
}

class CacheException implements Exception {
  final String message;
  const CacheException(this.message);
  @override
  String toString() => 'CacheException: $message';
}

class NotFoundException implements Exception {
  final String message;
  const NotFoundException(this.message);
  @override
  String toString() => 'NotFoundException: $message';
}

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);
  @override
  String toString() => 'AuthException: $message';
}

class ValidationException implements Exception {
  final String message;
  const ValidationException(this.message);
  @override
  String toString() => 'ValidationException: $message';
}
