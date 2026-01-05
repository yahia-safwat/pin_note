/// Color picker widget for selecting note colors.
///
/// Displays a horizontal list of color options for notes.
library;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// A widget that displays a horizontal list of color options.
class ColorPickerWidget extends StatelessWidget {
  /// Currently selected color
  final int selectedColor;

  /// Callback when a color is selected
  final ValueChanged<int> onColorSelected;

  /// Size of each color circle
  final double colorSize;

  /// Spacing between color circles
  final double spacing;

  const ColorPickerWidget({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
    this.colorSize = 36,
    this.spacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: colorSize + 16,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: NoteColors.values.length,
        separatorBuilder: (_, _) => SizedBox(width: spacing),
        itemBuilder: (context, index) {
          final color = NoteColors.values[index];
          final isSelected = color == selectedColor;

          return _ColorOption(
            color: color,
            isSelected: isSelected,
            size: colorSize,
            onTap: () => onColorSelected(color),
          );
        },
      ),
    );
  }
}

/// A single color option in the color picker.
class _ColorOption extends StatelessWidget {
  final int color;
  final bool isSelected;
  final double size;
  final VoidCallback onTap;

  const _ColorOption({
    required this.color,
    required this.isSelected,
    required this.size,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorValue = NoteColors.fromInt(color);
    final isDark = colorValue.computeLuminance() < 0.5;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: colorValue,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.black.withValues(alpha: 0.1),
            width: isSelected ? 3 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colorValue.withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: isSelected
            ? Icon(
                Icons.check,
                size: size * 0.5,
                color: isDark ? Colors.white : Colors.black87,
              )
            : null,
      ),
    );
  }
}

/// A compact color picker for use in dialogs or bottom sheets.
class ColorPickerGrid extends StatelessWidget {
  /// Currently selected color
  final int selectedColor;

  /// Callback when a color is selected
  final ValueChanged<int> onColorSelected;

  const ColorPickerGrid({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      runSpacing: 12,
      children: NoteColors.values.map((color) {
        final isSelected = color == selectedColor;

        return _ColorOption(
          color: color,
          isSelected: isSelected,
          size: 40,
          onTap: () => onColorSelected(color),
        );
      }).toList(),
    );
  }
}
