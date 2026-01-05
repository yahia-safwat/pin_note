/// Note card widget for displaying note preview.
///
/// Used in both grid and list views to show a note's
/// title, content preview, and metadata.
library;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/note_entity.dart';

/// A card widget that displays a note preview.
class NoteCard extends StatelessWidget {
  /// The note to display
  final NoteEntity note;

  /// Callback when the card is tapped
  final VoidCallback? onTap;

  /// Callback when the card is long-pressed
  final VoidCallback? onLongPress;

  /// Whether to use grid layout (compact) or list layout (expanded)
  final bool isGridView;

  const NoteCard({
    super.key,
    required this.note,
    this.onTap,
    this.onLongPress,
    this.isGridView = true,
  });

  @override
  Widget build(BuildContext context) {
    final noteColor = NoteColors.fromInt(note.color);
    final isDarkBackground = _isDarkColor(noteColor);
    final textColor = isDarkBackground ? Colors.white : Colors.black87;
    final secondaryTextColor = isDarkBackground
        ? Colors.white70
        : Colors.black54;

    return Card(
      color: noteColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.black.withValues(alpha: 0.05), width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with pin indicator and date
              Row(
                children: [
                  // Pin indicator
                  if (note.isPinned) ...[
                    Icon(Icons.push_pin, size: 16, color: AppColors.pinned),
                    const SizedBox(width: 4),
                  ],

                  // Date
                  Expanded(
                    child: Text(
                      DateFormatter.formatForCard(note.updatedAt),
                      style: TextStyle(fontSize: 12, color: secondaryTextColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Title
              if (note.title.isNotEmpty) ...[
                Text(
                  note.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                    height: 1.3,
                  ),
                  maxLines: isGridView ? 2 : 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
              ],

              // Content preview
              if (note.content.isNotEmpty)
                Expanded(
                  child: Text(
                    note.content,
                    style: TextStyle(
                      fontSize: 14,
                      color: secondaryTextColor,
                      height: 1.4,
                    ),
                    maxLines: isGridView ? 6 : 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Check if a color is considered dark.
  bool _isDarkColor(Color color) {
    // Calculate luminance
    final luminance = color.computeLuminance();
    return luminance < 0.5;
  }
}

/// A list tile variant of the note card for list view.
class NoteListTile extends StatelessWidget {
  /// The note to display
  final NoteEntity note;

  /// Callback when the tile is tapped
  final VoidCallback? onTap;

  /// Callback when the tile is long-pressed
  final VoidCallback? onLongPress;

  const NoteListTile({
    super.key,
    required this.note,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final noteColor = NoteColors.fromInt(note.color);
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.1)),
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Color indicator
              Container(
                width: 4,
                height: 48,
                decoration: BoxDecoration(
                  color: noteColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title row
                    Row(
                      children: [
                        if (note.isPinned) ...[
                          Icon(
                            Icons.push_pin,
                            size: 14,
                            color: AppColors.pinned,
                          ),
                          const SizedBox(width: 4),
                        ],
                        Expanded(
                          child: Text(
                            note.title.isNotEmpty ? note.title : 'Untitled',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    // Content preview
                    if (note.content.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        note.content,
                        style: theme.textTheme.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Date
              Text(
                DateFormatter.formatForCard(note.updatedAt),
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
