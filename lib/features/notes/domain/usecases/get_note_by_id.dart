/// Get Note By ID Use Case.
///
/// Retrieves a single note by its unique identifier.
library;

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/note_entity.dart';
import '../repositories/note_repository.dart';
import 'usecase.dart';

/// Use case to get a note by ID.
class GetNoteById implements UseCase<NoteEntity, String> {
  final NoteRepository repository;

  GetNoteById(this.repository);

  /// Execute the use case.
  ///
  /// [params] is the note ID to retrieve.
  /// Returns [NotFoundFailure] if note doesn't exist.
  @override
  Future<Either<Failure, NoteEntity>> call(String params) {
    return repository.getNoteById(params);
  }
}
