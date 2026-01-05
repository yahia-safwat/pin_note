/// Delete Note Use Case.
///
/// Removes a note from storage.
library;

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/note_repository.dart';
import 'usecase.dart';

/// Use case to delete a note.
class DeleteNote implements UseCase<Unit, String> {
  final NoteRepository repository;

  DeleteNote(this.repository);

  /// Execute the use case.
  ///
  /// [params] is the ID of the note to delete.
  /// Returns [Unit] on success (void equivalent in dartz).
  @override
  Future<Either<Failure, Unit>> call(String params) {
    return repository.deleteNote(params);
  }
}
