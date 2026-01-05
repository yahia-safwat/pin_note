/// Notes state definitions using freezed pattern.
///
/// Defines all possible states for the notes list feature.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/note_entity.dart';
import '../../domain/repositories/note_repository.dart';

part 'notes_state.freezed.dart';

/// State for the notes list feature.
///
/// Uses freezed for immutable state with pattern matching.
@freezed
class NotesState with _$NotesState {
  /// Initial state before any data is loaded
  const factory NotesState.initial() = _Initial;

  /// Loading state while fetching notes
  const factory NotesState.loading() = _Loading;

  /// Loaded state with notes data
  ///
  /// [notes] - List of notes to display
  /// [isGridView] - Whether to show grid or list view
  /// [sortOption] - Current sort option
  /// [searchQuery] - Active search query if any
  const factory NotesState.loaded({
    required List<NoteEntity> notes,
    @Default(true) bool isGridView,
    @Default(NoteSortOption.dateUpdated) NoteSortOption sortOption,
    String? searchQuery,
  }) = _Loaded;

  /// Empty state when no notes exist
  const factory NotesState.empty() = _Empty;

  /// Error state with message
  const factory NotesState.error(String message) = _Error;
}
