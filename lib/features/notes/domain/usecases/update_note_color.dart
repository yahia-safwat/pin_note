/// Update Note Color Use Case.
///
/// Changes the color of a note.
library;

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/note_entity.dart';
import '../repositories/note_repository.dart';
import 'usecase.dart';

/// Parameters for updating note color.
class UpdateNoteColorParams {
  final String noteId;
  final int color;

  const UpdateNoteColorParams({required this.noteId, required this.color});
}

/// Use case to update note color.
class UpdateNoteColor implements UseCase<NoteEntity, UpdateNoteColorParams> {
  final NoteRepository repository;

  UpdateNoteColor(this.repository);

  /// Execute the use case.
  ///
  /// [params] contains the note ID and new color.
  /// Returns the note with updated color.
  @override
  Future<Either<Failure, NoteEntity>> call(UpdateNoteColorParams params) {
    return repository.updateNoteColor(params.noteId, params.color);
  }
}
