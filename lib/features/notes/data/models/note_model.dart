/// Note model for SQLite database mapping.
///
/// This model handles serialization/deserialization between
/// the domain entity and SQLite database format.
library;

import '../../domain/entities/note_entity.dart';

/// Data model representing a note in SQLite.
///
/// Contains methods for converting to/from SQLite map format.
class NoteModel {
  /// Unique identifier
  final String id;

  /// Note title
  final String title;

  /// Note content
  final String content;

  /// Color as ARGB integer
  final int color;

  /// Whether the note is pinned (stored as 0/1 in SQLite)
  final bool isPinned;

  /// Creation timestamp (stored as ISO8601 string)
  final DateTime createdAt;

  /// Last update timestamp (stored as ISO8601 string)
  final DateTime updatedAt;

  const NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.color,
    required this.isPinned,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create a NoteModel from a SQLite row map.
  ///
  /// [map] is the row data from SQLite query.
  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      color: map['color'] as int,
      isPinned: (map['isPinned'] as int) == 1,
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  /// Convert this model to a SQLite-compatible map.
  ///
  /// Booleans are converted to integers (0/1).
  /// DateTimes are converted to ISO8601 strings.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'color': color,
      'isPinned': isPinned ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create a NoteModel from a domain entity.
  factory NoteModel.fromEntity(NoteEntity entity) {
    return NoteModel(
      id: entity.id,
      title: entity.title,
      content: entity.content,
      color: entity.color,
      isPinned: entity.isPinned,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  /// Convert this model to a domain entity.
  NoteEntity toEntity() {
    return NoteEntity(
      id: id,
      title: title,
      content: content,
      color: color,
      isPinned: isPinned,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Create a copy with optional new values.
  NoteModel copyWith({
    String? id,
    String? title,
    String? content,
    int? color,
    bool? isPinned,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NoteModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      color: color ?? this.color,
      isPinned: isPinned ?? this.isPinned,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'NoteModel(id: $id, title: $title, isPinned: $isPinned)';
  }
}
