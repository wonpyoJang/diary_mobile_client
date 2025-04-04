abstract class Failure {
  final String message;
  final String? code;

  /// Additional information about the failure.
  ///
  /// Examples:
  /// ```dart
  /// // Network error details
  /// details: {
  ///   'statusCode': 404,
  ///   'endpoint': '/api/users'
  /// }
  ///
  /// // Validation error details
  /// details: {
  ///   'field': 'email',
  ///   'error': 'Invalid email format'
  /// }
  ///
  /// // Server error details
  /// details: {
  ///   'errorCode': 'DB_CONNECTION_ERROR',
  ///   'timestamp': '2024-03-15T09:30:00Z'
  /// }
  /// ```
  final dynamic details;

  const Failure({
    required this.message,
    this.code,
    this.details,
  });
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code,
    super.details,
  });
}

class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.code,
    super.details,
  });
}

class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.code,
    super.details,
  });
}

class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code,
    super.details,
  });
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure({
    required super.message,
    super.code,
    super.details,
  });
}
