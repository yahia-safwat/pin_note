/// Note entity - pure Dart domain object.
///
/// This is the core business object representing a note.
/// It contains no Flutter or external package dependencies,
/// ensuring the domain layer remains pure and testable.
library;

import 'package:equatable/equatable.dart';

/// Represents a note in the domain layer.
///
/// All properties are immutable. Use [copyWith] to create
/// modified copies of the entity.
class NoteEntity extends Equatable {
  /// Unique identifier for the note
  final String id;

  /// Title of the note
  final String title;

  /// Main content/body of the note
  final String content;

  /// Color of the note as an ARGB integer value
  final int color;

  /// Whether the note is pinned to the top
  final bool isPinned;

  /// When the note was created
  final DateTime createdAt;

  /// When the note was last updated
  final DateTime updatedAt;

  const NoteEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.color,
    required this.isPinned,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create a copy of this note with optional new values.
  NoteEntity copyWith({
    String? id,
    String? title,
    String? content,
    int? color,
    bool? isPinned,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NoteEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      color: color ?? this.color,
      isPinned: isPinned ?? this.isPinned,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Check if the note has any content (title or body)
  bool get hasContent => title.isNotEmpty || content.isNotEmpty;

  /// Check if the note is empty
  bool get isEmpty => title.isEmpty && content.isEmpty;

  /// Get a preview of the content (first 100 characters)
  String get contentPreview {
    if (content.isEmpty) return '';
    return content.length > 100 ? '${content.substring(0, 100)}...' : content;
  }

  @override
  List<Object?> get props => [
    id,
    title,
    content,
    color,
    isPinned,
    createdAt,
    updatedAt,
  ];

  @override
  String toString() {
    return 'NoteEntity(id: $id, title: $title, isPinned: $isPinned)';
  }
}
