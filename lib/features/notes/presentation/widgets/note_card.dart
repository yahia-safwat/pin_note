import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/entities/note_entity.dart';

/// A card widget that displays a note preview matching the reference design.
class NoteCard extends StatelessWidget {
  /// The note to display
  final NoteEntity note;

  /// Callback when the card is tapped
  final VoidCallback? onTap;

  /// Callback when the menu is tapped
  final VoidCallback? onMenuTap;

  /// Whether the card is in grid mode
  final bool isGridMode;

  const NoteCard({
    super.key,
    required this.note,
    this.onTap,
    this.onMenuTap,
    this.isGridMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final noteColor = NoteColors.fromInt(note.color);

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isGridMode ? 0 : 16,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: noteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title row with menu
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Pin indicator
                    if (note.isPinned) ...[
                      const Icon(
                        Icons.push_pin,
                        size: 16,
                        color: AppColors.pinned,
                      ),
                      const SizedBox(width: 6),
                    ],

                    // Title
                    Expanded(
                      child: Text(
                        note.title.isNotEmpty ? note.title : 'Untitled',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          height: 1.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                // Content preview
                if (note.content.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          note.content,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black.withValues(alpha: 0.65),
                            height: 1.4,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // Menu button
                      GestureDetector(
                        onTap: onMenuTap,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Icon(
                            Icons.more_vert,
                            size: 20,
                            color: Colors.black.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],

                // Date
                const SizedBox(height: 8),
                Text(
                  DateFormatter.formatDate(note.updatedAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A list tile variant of the note card.
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
