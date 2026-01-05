/// Notes local data source for SQLite operations.
///
/// Handles all direct database interactions for notes.
/// Throws exceptions on errors which are caught by the repository.
library;

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/database/sqlite_helper.dart';
import '../../../../../core/error/exceptions.dart';
import '../../models/note_model.dart';

/// Abstract definition for notes local data source.
///
/// Allows for easy mocking in tests.
abstract class NotesLocalDataSource {
  /// Get all notes from the database.
  Future<List<NoteModel>> getAllNotes();

  /// Get a single note by ID.
  Future<NoteModel> getNoteById(String id);

  /// Insert a new note.
  Future<NoteModel> insertNote(NoteModel note);

  /// Update an existing note.
  Future<NoteModel> updateNote(NoteModel note);

  /// Delete a note by ID.
  Future<void> deleteNote(String id);

  /// Search notes by query string.
  Future<List<NoteModel>> searchNotes(String query);
}

/// SQLite implementation of NotesLocalDataSource.
class NotesLocalDataSourceImpl implements NotesLocalDataSource {
  final SqliteHelper sqliteHelper;

  NotesLocalDataSourceImpl({required this.sqliteHelper});

  /// Table name constant
  String get _tableName => AppStrings.notesTable;

  @override
  Future<List<NoteModel>> getAllNotes() async {
    try {
      final db = await sqliteHelper.database;

      // Query all notes, ordered by pinned status (pinned first)
      // then by updated date (newest first)
      final result = await db.query(
        _tableName,
        orderBy: 'isPinned DESC, updatedAt DESC',
      );

      return result.map((map) => NoteModel.fromMap(map)).toList();
    } catch (e) {
      throw DatabaseException('Failed to get notes: $e');
    }
  }

  @override
  Future<NoteModel> getNoteById(String id) async {
    try {
      final db = await sqliteHelper.database;

      final result = await db.query(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (result.isEmpty) {
        throw NotFoundException('Note with id $id not found');
      }

      return NoteModel.fromMap(result.first);
    } catch (e) {
      if (e is NotFoundException) rethrow;
      throw DatabaseException('Failed to get note: $e');
    }
  }

  @override
  Future<NoteModel> insertNote(NoteModel note) async {
    try {
      final db = await sqliteHelper.database;

      await db.insert(_tableName, note.toMap());

      return note;
    } catch (e) {
      throw DatabaseException('Failed to insert note: $e');
    }
  }

  @override
  Future<NoteModel> updateNote(NoteModel note) async {
    try {
      final db = await sqliteHelper.database;

      final count = await db.update(
        _tableName,
        note.toMap(),
        where: 'id = ?',
        whereArgs: [note.id],
      );

      if (count == 0) {
        throw NotFoundException('Note with id ${note.id} not found');
      }

      return note;
    } catch (e) {
      if (e is NotFoundException) rethrow;
      throw DatabaseException('Failed to update note: $e');
    }
  }

  @override
  Future<void> deleteNote(String id) async {
    try {
      final db = await sqliteHelper.database;

      final count = await db.delete(
        _tableName,
        where: 'id = ?',
        whereArgs: [id],
      );

      if (count == 0) {
        throw NotFoundException('Note with id $id not found');
      }
    } catch (e) {
      if (e is NotFoundException) rethrow;
      throw DatabaseException('Failed to delete note: $e');
    }
  }

  @override
  Future<List<NoteModel>> searchNotes(String query) async {
    try {
      final db = await sqliteHelper.database;

      // Case-insensitive search in title and content
      final searchPattern = '%$query%';

      final result = await db.query(
        _tableName,
        where: 'title LIKE ? OR content LIKE ?',
        whereArgs: [searchPattern, searchPattern],
        orderBy: 'isPinned DESC, updatedAt DESC',
      );

      return result.map((map) => NoteModel.fromMap(map)).toList();
    } catch (e) {
      throw DatabaseException('Failed to search notes: $e');
    }
  }
}
