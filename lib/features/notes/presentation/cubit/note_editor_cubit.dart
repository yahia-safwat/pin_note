/// Note Editor Cubit for managing single note editing state.
///
/// Handles creating, editing, and deleting individual notes
/// with auto-save functionality.
library;

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/note_entity.dart';
import '../../domain/usecases/create_note.dart';
import '../../domain/usecases/delete_note.dart';
import '../../domain/usecases/get_note_by_id.dart';
import '../../domain/usecases/update_note.dart';
import 'notes_cubit.dart';
import 'note_editor_state.dart';

/// Cubit for managing note editing state and operations.
class NoteEditorCubit extends Cubit<NoteEditorState> {
  final GetNoteById getNoteById;
  final CreateNote createNote;
  final UpdateNote updateNote;
  final DeleteNote deleteNote;
  final NotesCubit notesCubit;

  /// Timer for auto-save debouncing
  Timer? _autoSaveTimer;

  /// Duration before auto-save triggers
  static const Duration autoSaveDelay = Duration(milliseconds: 1500);

  /// The current note being edited
  NoteEntity? _currentNote;

  /// Whether this is a new note
  bool _isNewNote = false;

  /// Whether the note has been saved at least once
  bool _hasBeenSaved = false;

  NoteEditorCubit({
    required this.getNoteById,
    required this.createNote,
    required this.updateNote,
    required this.deleteNote,
    required this.notesCubit,
  }) : super(const NoteEditorState.initial());

  /// Initialize the editor with an existing note or a new note.
  ///
  /// [noteId] - If provided, loads the existing note. If null, creates a new note.
  Future<void> initialize({String? noteId}) async {
    if (noteId != null) {
      // Load existing note
      emit(const NoteEditorState.loading());

      final result = await getNoteById(noteId);

      result.fold((failure) => emit(NoteEditorState.error(failure.message)), (
        note,
      ) {
        _currentNote = note;
        _isNewNote = false;
        _hasBeenSaved = true;
        emit(NoteEditorState.editing(note: note, isNewNote: false));
      });
    } else {
      // Create a new note template
      final now = DateTime.now();
      _currentNote = NoteEntity(
        id: '', // Will be generated on save
        title: '',
        content: '',
        color: NoteColors.defaultColor,
        isPinned: false,
        createdAt: now,
        updatedAt: now,
      );
      _isNewNote = true;
      _hasBeenSaved = false;

      emit(NoteEditorState.editing(note: _currentNote!, isNewNote: true));
    }
  }

  /// Update the note title and trigger auto-save.
  void updateTitle(String title) {
    if (_currentNote == null) return;

    _currentNote = _currentNote!.copyWith(title: title);
    _emitEditingState(hasChanges: true);
    _scheduleAutoSave();
  }

  /// Update the note content and trigger auto-save.
  void updateContent(String content) {
    if (_currentNote == null) return;

    _currentNote = _currentNote!.copyWith(content: content);
    _emitEditingState(hasChanges: true);
    _scheduleAutoSave();
  }

  /// Update the note color.
  void updateColor(int color) {
    if (_currentNote == null) return;

    _currentNote = _currentNote!.copyWith(color: color);
    _emitEditingState(hasChanges: true);
    _scheduleAutoSave();
  }

  /// Toggle the pin status.
  void togglePin() {
    if (_currentNote == null) return;

    _currentNote = _currentNote!.copyWith(isPinned: !_currentNote!.isPinned);
    _emitEditingState(hasChanges: true);
    _scheduleAutoSave();
  }

  /// Schedule auto-save with debouncing.
  void _scheduleAutoSave() {
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer(autoSaveDelay, () {
      _performAutoSave();
    });
  }

  /// Perform the auto-save operation.
  Future<void> _performAutoSave() async {
    if (_currentNote == null) return;

    // Don't save empty notes
    if (_currentNote!.isEmpty) return;

    await _saveNote(showSavingState: false);
  }

  /// Manually save the note.
  Future<void> saveNote() async {
    await _saveNote(showSavingState: true);
  }

  /// Save the note to storage.
  Future<void> _saveNote({bool showSavingState = false}) async {
    if (_currentNote == null) return;

    // Don't save empty notes
    if (_currentNote!.isEmpty) return;

    if (showSavingState) {
      emit(const NoteEditorState.saving());
    }

    if (_isNewNote && !_hasBeenSaved) {
      // Create new note
      final result = await createNote(_currentNote!);

      result.fold((failure) => emit(NoteEditorState.error(failure.message)), (
        note,
      ) {
        _currentNote = note;
        _isNewNote = false;
        _hasBeenSaved = true;

        if (showSavingState) {
          emit(const NoteEditorState.saved());
          // Refresh notes list
          notesCubit.loadNotes();
          // Return to editing state after brief delay
          Future.delayed(const Duration(milliseconds: 500), () {
            if (!isClosed) {
              _emitEditingState(hasChanges: false);
            }
          });
        } else {
          // Silent refresh for auto-save
          notesCubit.loadNotes();
          _emitEditingState(hasChanges: false);
        }
      });
    } else {
      // Update existing note
      final result = await updateNote(_currentNote!);

      result.fold((failure) => emit(NoteEditorState.error(failure.message)), (
        note,
      ) {
        _currentNote = note;

        if (showSavingState) {
          emit(const NoteEditorState.saved());
          // Refresh notes list
          notesCubit.loadNotes();
          // Return to editing state after brief delay
          Future.delayed(const Duration(milliseconds: 500), () {
            if (!isClosed) {
              _emitEditingState(hasChanges: false);
            }
          });
        } else {
          // Silent refresh for auto-save
          notesCubit.loadNotes();
          _emitEditingState(hasChanges: false);
        }
      });
    }
  }

  /// Delete the current note.
  Future<void> deleteCurrentNote() async {
    if (_currentNote == null || _currentNote!.id.isEmpty) {
      // Note hasn't been saved yet, just close
      emit(const NoteEditorState.deleted());
      return;
    }

    emit(const NoteEditorState.saving());

    final result = await deleteNote(_currentNote!.id);

    result.fold((failure) => emit(NoteEditorState.error(failure.message)), (_) {
      notesCubit.loadNotes();
      emit(const NoteEditorState.deleted());
    });
  }

  /// Emit the editing state with current note.
  void _emitEditingState({required bool hasChanges}) {
    if (_currentNote == null) return;

    emit(
      NoteEditorState.editing(
        note: _currentNote!,
        isNewNote: _isNewNote,
        hasUnsavedChanges: hasChanges,
      ),
    );
  }

  /// Check if the note can be discarded (empty or no unsaved changes).
  bool get canDiscard {
    if (_currentNote == null) return true;
    if (_currentNote!.isEmpty && !_hasBeenSaved) return true;
    return false;
  }

  /// Get the current note's color.
  int get currentColor => _currentNote?.color ?? NoteColors.defaultColor;

  /// Get whether the note is pinned.
  bool get isPinned => _currentNote?.isPinned ?? false;

  @override
  Future<void> close() {
    _autoSaveTimer?.cancel();
    return super.close();
  }
}
