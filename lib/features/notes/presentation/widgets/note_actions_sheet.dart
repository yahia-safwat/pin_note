/// Note action bottom sheet for long-press actions.
///
/// Provides quick actions like pin, delete, and color change.
library;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/note_entity.dart';
import 'color_picker_widget.dart';

/// Bottom sheet with note actions.
class NoteActionsSheet extends StatelessWidget {
  /// The note to perform actions on
  final NoteEntity note;

  /// Callback when pin is toggled
  final VoidCallback onTogglePin;

  /// Callback when delete is requested
  final VoidCallback onDelete;

  /// Callback when color is changed
  final ValueChanged<int> onColorChanged;

  const NoteActionsSheet({
    super.key,
    required this.note,
    required this.onTogglePin,
    required this.onDelete,
    required this.onColorChanged,
  });

  /// Show the action sheet.
  static Future<void> show({
    required BuildContext context,
    required NoteEntity note,
    required VoidCallback onTogglePin,
    required VoidCallback onDelete,
    required ValueChanged<int> onColorChanged,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => NoteActionsSheet(
        note: note,
        onTogglePin: onTogglePin,
        onDelete: onDelete,
        onColorChanged: onColorChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Note preview
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: NoteColors.fromInt(note.color),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title.isNotEmpty ? note.title : AppStrings.untitled,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (note.content.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      note.content,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Color picker label
            Text(
              AppStrings.changeColor,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 12),

            // Color picker
            ColorPickerGrid(
              selectedColor: note.color,
              onColorSelected: (color) {
                onColorChanged(color);
                Navigator.pop(context);
              },
            ),

            const SizedBox(height: 24),

            // Action buttons
            Row(
              children: [
                // Pin button
                Expanded(
                  child: _ActionButton(
                    icon: note.isPinned
                        ? Icons.push_pin
                        : Icons.push_pin_outlined,
                    label: note.isPinned ? AppStrings.unpin : AppStrings.pin,
                    onTap: () {
                      onTogglePin();
                      Navigator.pop(context);
                    },
                  ),
                ),

                const SizedBox(width: 12),

                // Delete button
                Expanded(
                  child: _ActionButton(
                    icon: Icons.delete_outline,
                    label: AppStrings.delete,
                    isDestructive: true,
                    onTap: () => _confirmDelete(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.deleteConfirmTitle),
        content: const Text(AppStrings.deleteConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close bottom sheet
              onDelete();
            },
            child: const Text(AppStrings.delete),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isDestructive
        ? theme.colorScheme.error
        : theme.colorScheme.primary;

    return Material(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(color: color, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
