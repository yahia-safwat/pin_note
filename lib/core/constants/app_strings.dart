/// Application string constants.
///
/// Centralizes all string literals used throughout the app
/// for easy maintenance and localization preparation.
library;

class AppStrings {
  AppStrings._();

  // App info
  static const String appName = 'PinNote';
  static const String appTagline = 'Your thoughts, organized';

  // Notes
  static const String notes = 'Notes';
  static const String newNote = 'New Note';
  static const String editNote = 'Edit Note';
  static const String untitled = 'Untitled';
  static const String noContent = 'No content';
  static const String titleHint = 'Title';
  static const String contentHint = 'Start typing...';

  // Actions
  static const String save = 'Save';
  static const String delete = 'Delete';
  static const String cancel = 'Cancel';
  static const String pin = 'Pin';
  static const String unpin = 'Unpin';
  static const String changeColor = 'Change Color';
  static const String search = 'Search notes...';

  // View modes
  static const String gridView = 'Grid View';
  static const String listView = 'List View';

  // Sort options
  static const String sortByDate = 'Sort by Date';
  static const String sortByColor = 'Sort by Color';
  static const String sortByTitle = 'Sort by Title';

  // Empty states
  static const String noNotes = 'No notes yet';
  static const String noNotesMessage =
      'Tap the + button to create your first note';
  static const String noSearchResults = 'No notes found';
  static const String noSearchResultsMessage = 'Try a different search term';

  // Error messages
  static const String errorGeneric = 'Something went wrong';
  static const String errorLoadingNotes = 'Failed to load notes';
  static const String errorSavingNote = 'Failed to save note';
  static const String errorDeletingNote = 'Failed to delete note';

  // Confirmations
  static const String deleteConfirmTitle = 'Delete Note?';
  static const String deleteConfirmMessage = 'This action cannot be undone.';

  // Database
  static const String databaseName = 'pin_note.db';
  static const String notesTable = 'notes';
}
