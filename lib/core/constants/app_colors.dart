/// Application color constants for note colors.
///
/// This file defines the color palette available for notes,
/// inspired by ColorNote's design language.
library;

import 'package:flutter/material.dart';

/// Available note colors with their corresponding integer values.
///
/// Each color is represented by its ARGB value for SQLite storage.
class NoteColors {
  NoteColors._(); // Private constructor to prevent instantiation

  /// Default note color - Yellow
  static const int yellow = 0xFFFFF9C4;

  /// Orange note color
  static const int orange = 0xFFFFE0B2;

  /// Red/Pink note color
  static const int red = 0xFFFFCDD2;

  /// Blue note color
  static const int blue = 0xFFBBDEFB;

  /// Green note color
  static const int green = 0xFFC8E6C9;

  /// Purple note color
  static const int purple = 0xFFE1BEE7;

  /// White note color
  static const int white = 0xFFFFFFFF;

  /// Gray note color
  static const int gray = 0xFFE0E0E0;

  /// List of all available note colors
  static const List<int> values = [
    yellow,
    orange,
    red,
    blue,
    green,
    purple,
    white,
    gray,
  ];

  /// Get Color object from integer value
  static Color fromInt(int colorValue) => Color(colorValue);

  /// Get the default note color
  static int get defaultColor => yellow;
}

/// Application-wide color scheme
class AppColors {
  AppColors._();

  // Primary colors
  static const Color primary = Color(0xFF2196F3);
  static const Color primaryDark = Color(0xFF1976D2);
  static const Color primaryLight = Color(0xFFBBDEFB);

  // Accent colors
  static const Color accent = Color(0xFFFF9800);

  // Background colors
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);

  // Text colors
  static const Color textPrimaryLight = Color(0xFF212121);
  static const Color textSecondaryLight = Color(0xFF757575);
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFB3B3B3);

  // Utility colors
  static const Color error = Color(0xFFE53935);
  static const Color success = Color(0xFF43A047);
  static const Color warning = Color(0xFFFFA000);

  // Pin indicator color
  static const Color pinned = Color(0xFFFF5722);
}
