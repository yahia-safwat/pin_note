/// Exception classes for data layer operations.
///
/// Exceptions are thrown in the data layer and caught by
/// repositories, which convert them to Failure objects.
library;

/// Base exception for database-related errors.
class DatabaseException implements Exception {
  final String message;

  const DatabaseException([this.message = 'Database error occurred']);

  @override
  String toString() => 'DatabaseException: $message';
}

/// Exception when a record is not found in the database.
class NotFoundException implements Exception {
  final String message;

  const NotFoundException([this.message = 'Record not found']);

  @override
  String toString() => 'NotFoundException: $message';
}

/// Exception for cache-related errors.
class CacheException implements Exception {
  final String message;

  const CacheException([this.message = 'Cache error occurred']);

  @override
  String toString() => 'CacheException: $message';
}
