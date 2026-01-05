/// Get All Notes Use Case.
///
/// Retrieves all notes from the repository with optional sorting.
library;

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/note_entity.dart';
import '../repositories/note_repository.dart';

/// Parameters for getting all notes.
class GetAllNotesParams {
  final NoteSortOption sortOption;

  const GetAllNotesParams({this.sortOption = NoteSortOption.dateUpdated});
}

/// Use case to get all notes.
class GetAllNotes {
  final NoteRepository repository;

  GetAllNotes(this.repository);

  /// Execute the use case.
  ///
  /// Returns a list of notes sorted according to [params.sortOption].
  /// Pinned notes are always shown first.
  Future<Either<Failure, List<NoteEntity>>> call([
    GetAllNotesParams params = const GetAllNotesParams(),
  ]) {
    return repository.getAllNotes(sortOption: params.sortOption);
  }
}
