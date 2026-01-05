/// Search Notes Use Case.
///
/// Searches notes by title and content.
library;

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/note_entity.dart';
import '../repositories/note_repository.dart';
import 'usecase.dart';

/// Use case to search notes.
class SearchNotes implements UseCase<List<NoteEntity>, String> {
  final NoteRepository repository;

  SearchNotes(this.repository);

  /// Execute the use case.
  ///
  /// [params] is the search query string.
  /// Returns notes where title or content contains the query.
  @override
  Future<Either<Failure, List<NoteEntity>>> call(String params) {
    return repository.searchNotes(params);
  }
}
