/// Update Note Use Case.
///
/// Updates an existing note in storage.
library;

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/note_entity.dart';
import '../repositories/note_repository.dart';
import 'usecase.dart';

/// Use case to update an existing note.
class UpdateNote implements UseCase<NoteEntity, NoteEntity> {
  final NoteRepository repository;

  UpdateNote(this.repository);

  /// Execute the use case.
  ///
  /// [params] is the note entity with updated values.
  /// The note ID must exist in storage.
  /// Returns the updated note with new updatedAt timestamp.
  @override
  Future<Either<Failure, NoteEntity>> call(NoteEntity params) {
    return repository.updateNote(params);
  }
}
