/// Create Note Use Case.
///
/// Creates a new note and persists it to storage.
library;

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/note_entity.dart';
import '../repositories/note_repository.dart';
import 'usecase.dart';

/// Use case to create a new note.
class CreateNote implements UseCase<NoteEntity, NoteEntity> {
  final NoteRepository repository;

  CreateNote(this.repository);

  /// Execute the use case.
  ///
  /// [params] is the note entity to create.
  /// Returns the created note with generated ID and timestamps.
  @override
  Future<Either<Failure, NoteEntity>> call(NoteEntity params) {
    return repository.createNote(params);
  }
}
