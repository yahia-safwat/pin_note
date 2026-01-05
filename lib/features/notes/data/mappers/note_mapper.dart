/// Note mapper for converting between model and entity.
///
/// Provides static methods for mapping between data layer
/// models and domain layer entities.
library;

import '../../domain/entities/note_entity.dart';
import '../models/note_model.dart';

/// Mapper class for Note conversions.
class NoteMapper {
  NoteMapper._();

  /// Convert a NoteModel to NoteEntity.
  static NoteEntity toEntity(NoteModel model) {
    return NoteEntity(
      id: model.id,
      title: model.title,
      content: model.content,
      color: model.color,
      isPinned: model.isPinned,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  /// Convert a NoteEntity to NoteModel.
  static NoteModel toModel(NoteEntity entity) {
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

  /// Convert a list of NoteModels to NoteEntities.
  static List<NoteEntity> toEntityList(List<NoteModel> models) {
    return models.map((model) => toEntity(model)).toList();
  }

  /// Convert a list of NoteEntities to NoteModels.
  static List<NoteModel> toModelList(List<NoteEntity> entities) {
    return entities.map((entity) => toModel(entity)).toList();
  }
}
