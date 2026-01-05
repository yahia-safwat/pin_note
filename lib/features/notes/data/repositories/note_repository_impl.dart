/// Note repository implementation.
///
/// Implements the domain repository interface, connecting
/// use cases to the data source with proper error handling.
library;

import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/note_entity.dart';
import '../../domain/repositories/note_repository.dart';
import '../datasources/local/notes_local_datasource.dart';
import '../mappers/note_mapper.dart';
import '../models/note_model.dart';

/// Implementation of NoteRepository using local SQLite storage.
class NoteRepositoryImpl implements NoteRepository {
  final NotesLocalDataSource localDataSource;
  final Uuid uuid;

  NoteRepositoryImpl({required this.localDataSource, Uuid? uuid})
    : uuid = uuid ?? const Uuid();

  @override
  Future<Either<Failure, List<NoteEntity>>> getAllNotes({
    NoteSortOption sortOption = NoteSortOption.dateUpdated,
  }) async {
    try {
      final models = await localDataSource.getAllNotes();
      var entities = NoteMapper.toEntityList(models);

      // Apply sorting (pinned notes are already first from data source)
      entities = _sortNotes(entities, sortOption);

      return Right(entities);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, NoteEntity>> getNoteById(String id) async {
    try {
      final model = await localDataSource.getNoteById(id);
      return Right(NoteMapper.toEntity(model));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, NoteEntity>> createNote(NoteEntity note) async {
    try {
      final now = DateTime.now();

      // Create new note with generated ID and timestamps
      final newNote = NoteModel(
        id: uuid.v4(),
        title: note.title,
        content: note.content,
        color: note.color != 0 ? note.color : NoteColors.defaultColor,
        isPinned: note.isPinned,
        createdAt: now,
        updatedAt: now,
      );

      final result = await localDataSource.insertNote(newNote);
      return Right(NoteMapper.toEntity(result));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, NoteEntity>> updateNote(NoteEntity note) async {
    try {
      final now = DateTime.now();

      // Update with new timestamp
      final updatedModel = NoteModel(
        id: note.id,
        title: note.title,
        content: note.content,
        color: note.color,
        isPinned: note.isPinned,
        createdAt: note.createdAt,
        updatedAt: now,
      );

      final result = await localDataSource.updateNote(updatedModel);
      return Right(NoteMapper.toEntity(result));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteNote(String id) async {
    try {
      await localDataSource.deleteNote(id);
      return const Right(unit);
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<NoteEntity>>> searchNotes(String query) async {
    try {
      if (query.trim().isEmpty) {
        return getAllNotes();
      }

      final models = await localDataSource.searchNotes(query);
      final entities = NoteMapper.toEntityList(models);
      return Right(entities);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, NoteEntity>> togglePinNote(String id) async {
    try {
      // Get current note
      final model = await localDataSource.getNoteById(id);

      // Toggle pin status
      final updatedModel = model.copyWith(
        isPinned: !model.isPinned,
        updatedAt: DateTime.now(),
      );

      final result = await localDataSource.updateNote(updatedModel);
      return Right(NoteMapper.toEntity(result));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, NoteEntity>> updateNoteColor(
    String id,
    int color,
  ) async {
    try {
      // Get current note
      final model = await localDataSource.getNoteById(id);

      // Update color
      final updatedModel = model.copyWith(
        color: color,
        updatedAt: DateTime.now(),
      );

      final result = await localDataSource.updateNote(updatedModel);
      return Right(NoteMapper.toEntity(result));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  /// Sort notes by the given option while keeping pinned notes first.
  List<NoteEntity> _sortNotes(List<NoteEntity> notes, NoteSortOption option) {
    // Separate pinned and unpinned notes
    final pinned = notes.where((n) => n.isPinned).toList();
    final unpinned = notes.where((n) => !n.isPinned).toList();

    // Sort each group
    switch (option) {
      case NoteSortOption.dateUpdated:
        pinned.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        unpinned.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        break;
      case NoteSortOption.dateCreated:
        pinned.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        unpinned.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case NoteSortOption.title:
        pinned.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
        unpinned.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
        break;
      case NoteSortOption.color:
        pinned.sort((a, b) => a.color.compareTo(b.color));
        unpinned.sort((a, b) => a.color.compareTo(b.color));
        break;
    }

    // Return pinned first, then unpinned
    return [...pinned, ...unpinned];
  }
}
