/// Base use case abstract class.
///
/// All use cases follow this pattern for consistency.
/// The [T] is the return T and [Params] is the input.
library;

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

/// Abstract use case with parameters.
///
/// [T] is the success return T.
/// [Params] is the input parameters T.
abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// Use case without parameters.
///
/// Uses [NoParams] as the parameter T.
abstract class UseCaseNoParams<T> {
  Future<Either<Failure, T>> call();
}

/// Empty parameters class.
///
/// Used for use cases that don't require input.
class NoParams {
  const NoParams();
}
