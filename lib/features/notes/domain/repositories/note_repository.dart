/// Note repository interface (abstract).
///
/// Defines the contract for note data operations.
/// The data layer implements this interface, allowing
/// the domain layer to remain independent of data sources.
library;

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/note_entity.dart';

/// Sorting options for notes list.
enum NoteSortOption {
  /// Sort by last updated date (newest first)
  dateUpdated,

  /// Sort by creation date (newest first)
  dateCreated,

  /// Sort by title alphabetically
  title,

  /// Sort by color
  color,
}

/// Abstract repository defining note operations.
///
/// Uses [Either] from dartz for functional error handling.
/// Left side contains [Failure], right side contains success value.
abstract class NoteRepository {
  /// Get all notes, optionally sorted.
  ///
  /// Returns notes with pinned notes first, then sorted by [sortOption].
  Future<Either<Failure, List<NoteEntity>>> getAllNotes({
    NoteSortOption sortOption = NoteSortOption.dateUpdated,
  });

  /// Get a single note by its ID.
  ///
  /// Returns [NotFoundFailure] if note doesn't exist.
  Future<Either<Failure, NoteEntity>> getNoteById(String id);

  /// Create a new note.
  ///
  /// Returns the created note with generated ID.
  Future<Either<Failure, NoteEntity>> createNote(NoteEntity note);

  /// Update an existing note.
  ///
  /// Returns the updated note.
  Future<Either<Failure, NoteEntity>> updateNote(NoteEntity note);

  /// Delete a note by its ID.
  ///
  /// Returns [Unit] on success (void equivalent in dartz).
  Future<Either<Failure, Unit>> deleteNote(String id);

  /// Search notes by title and content.
  ///
  /// Returns notes matching the query string.
  Future<Either<Failure, List<NoteEntity>>> searchNotes(String query);

  /// Toggle the pinned status of a note.
  ///
  /// Returns the updated note with flipped isPinned value.
  Future<Either<Failure, NoteEntity>> togglePinNote(String id);

  /// Update the color of a note.
  ///
  /// Returns the updated note with new color.
  Future<Either<Failure, NoteEntity>> updateNoteColor(String id, int color);
}
