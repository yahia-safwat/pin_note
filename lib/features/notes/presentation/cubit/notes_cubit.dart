/// Notes Cubit for managing notes list state.
///
/// Handles all operations related to the notes list display,
/// including loading, searching, sorting, and view mode changes.
library;

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/note_entity.dart';
import '../../domain/repositories/note_repository.dart';
import '../../domain/usecases/delete_note.dart';
import '../../domain/usecases/get_all_notes.dart';
import '../../domain/usecases/search_notes.dart';
import '../../domain/usecases/toggle_pin_note.dart';
import '../../domain/usecases/update_note_color.dart';
import 'notes_state.dart';

/// Cubit for managing notes list state and operations.
class NotesCubit extends Cubit<NotesState> {
  final GetAllNotes getAllNotes;
  final SearchNotes searchNotes;
  final DeleteNote deleteNote;
  final TogglePinNote togglePinNote;
  final UpdateNoteColor updateNoteColor;

  /// Current view preferences (preserved across state changes)
  bool _isGridView = true;
  NoteSortOption _sortOption = NoteSortOption.dateUpdated;
  String? _searchQuery;

  NotesCubit({
    required this.getAllNotes,
    required this.searchNotes,
    required this.deleteNote,
    required this.togglePinNote,
    required this.updateNoteColor,
  }) : super(const NotesState.initial());

  /// Load all notes from storage.
  Future<void> loadNotes() async {
    emit(const NotesState.loading());

    final result = await getAllNotes(
      GetAllNotesParams(sortOption: _sortOption),
    );

    result.fold((failure) => emit(NotesState.error(failure.message)), (notes) {
      if (notes.isEmpty) {
        emit(const NotesState.empty());
      } else {
        emit(
          NotesState.loaded(
            notes: notes,
            isGridView: _isGridView,
            sortOption: _sortOption,
            searchQuery: _searchQuery,
          ),
        );
      }
    });
  }

  /// Search notes by query.
  Future<void> search(String query) async {
    _searchQuery = query.trim().isEmpty ? null : query;

    if (_searchQuery == null) {
      return loadNotes();
    }

    emit(const NotesState.loading());

    final result = await searchNotes(query);

    result.fold((failure) => emit(NotesState.error(failure.message)), (notes) {
      if (notes.isEmpty) {
        emit(const NotesState.empty());
      } else {
        emit(
          NotesState.loaded(
            notes: notes,
            isGridView: _isGridView,
            sortOption: _sortOption,
            searchQuery: _searchQuery,
          ),
        );
      }
    });
  }

  /// Clear search and reload all notes.
  Future<void> clearSearch() async {
    _searchQuery = null;
    await loadNotes();
  }

  /// Toggle between grid and list view.
  void toggleViewMode() {
    _isGridView = !_isGridView;

    // Update state if we're in loaded state
    state.maybeWhen(
      loaded: (notes, _, sortOption, searchQuery) {
        emit(
          NotesState.loaded(
            notes: notes,
            isGridView: _isGridView,
            sortOption: sortOption,
            searchQuery: searchQuery,
          ),
        );
      },
      orElse: () {},
    );
  }

  /// Change the sort option and reload notes.
  Future<void> changeSortOption(NoteSortOption option) async {
    _sortOption = option;
    await loadNotes();
  }

  /// Delete a note by ID.
  Future<void> removeNote(String noteId) async {
    final result = await deleteNote(noteId);

    result.fold(
      (failure) => emit(NotesState.error(failure.message)),
      (_) => loadNotes(), // Reload notes after deletion
    );
  }

  /// Toggle pin status of a note.
  Future<void> togglePin(String noteId) async {
    final result = await togglePinNote(noteId);

    result.fold(
      (failure) => emit(NotesState.error(failure.message)),
      (_) => loadNotes(), // Reload to update order
    );
  }

  /// Update the color of a note.
  Future<void> changeNoteColor(String noteId, int color) async {
    final result = await updateNoteColor(
      UpdateNoteColorParams(noteId: noteId, color: color),
    );

    result.fold(
      (failure) => emit(NotesState.error(failure.message)),
      (_) => loadNotes(), // Reload to update display
    );
  }

  /// Get current notes list (helper for optimistic updates).
  List<NoteEntity>? get currentNotes {
    return state.maybeWhen(
      loaded: (notes, _, _, _) => notes,
      orElse: () => null,
    );
  }
}
