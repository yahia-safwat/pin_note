/// Error handling classes using the Either pattern from dartz.
///
/// Failures represent expected error conditions that the app
/// can handle gracefully, as opposed to exceptions which are
/// unexpected runtime errors.
library;

import 'package:equatable/equatable.dart';

/// Base failure class that all specific failures extend.
///
/// Using Equatable allows for easy comparison of failure instances.
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

/// Failure related to database operations.
///
/// Occurs when SQLite operations fail (CRUD, connection, etc.)
class DatabaseFailure extends Failure {
  const DatabaseFailure([super.message = 'Database operation failed']);
}

/// Failure when a requested resource is not found.
///
/// For example, trying to get a note by ID that doesn't exist.
class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Resource not found']);
}

/// Failure related to cache operations.
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache operation failed']);
}

/// Failure for validation errors.
///
/// Occurs when input data doesn't meet requirements.
class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Validation failed']);
}

/// Generic unexpected failure.
///
/// Used as a fallback for unexpected error conditions.
class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'An unexpected error occurred']);
}
