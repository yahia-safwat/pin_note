/// Note editor state definitions using freezed pattern.
///
/// Defines all possible states for the note editor feature.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/note_entity.dart';

part 'note_editor_state.freezed.dart';

/// State for the note editor feature.
@freezed
class NoteEditorState with _$NoteEditorState {
  /// Initial state before the editor is set up
  const factory NoteEditorState.initial() = _Initial;

  /// Loading state while fetching an existing note
  const factory NoteEditorState.loading() = _Loading;

  /// Editing state with the current note data
  ///
  /// [note] - The note being edited
  /// [isNewNote] - Whether this is a new note or existing
  /// [hasUnsavedChanges] - Whether there are unsaved changes
  const factory NoteEditorState.editing({
    required NoteEntity note,
    @Default(false) bool isNewNote,
    @Default(false) bool hasUnsavedChanges,
  }) = _Editing;

  /// Saving state while persisting changes
  const factory NoteEditorState.saving() = _Saving;

  /// Saved state after successful save
  const factory NoteEditorState.saved() = _Saved;

  /// Deleted state after successful deletion
  const factory NoteEditorState.deleted() = _Deleted;

  /// Error state with message
  const factory NoteEditorState.error(String message) = _Error;
}
