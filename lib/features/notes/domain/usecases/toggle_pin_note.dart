/// Toggle Pin Note Use Case.
///
/// Toggles the pinned status of a note.
library;

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/note_entity.dart';
import '../repositories/note_repository.dart';
import 'usecase.dart';

/// Use case to toggle note pin status.
class TogglePinNote implements UseCase<NoteEntity, String> {
  final NoteRepository repository;

  TogglePinNote(this.repository);

  /// Execute the use case.
  ///
  /// [params] is the ID of the note to toggle.
  /// Returns the note with flipped isPinned value.
  @override
  Future<Either<Failure, NoteEntity>> call(String params) {
    return repository.togglePinNote(params);
  }
}
