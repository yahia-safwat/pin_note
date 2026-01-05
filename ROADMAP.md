# PinNote - Development Roadmap

A Flutter notepad application similar to ColorNote, built with Clean Architecture and SQLite.

---

## ✅ Completed Features

### Architecture & Setup
- [x] Feature-based Clean Architecture structure
- [x] SQLite database setup with sqflite package
- [x] Dependency Injection with GetIt
- [x] Routing with go_router
- [x] Modern Material 3 theming (light & dark)
- [x] Error handling with dartz Either pattern
- [x] Freezed for immutable state management

### Core Infrastructure
- [x] SQLite helper singleton (`core/database/sqlite_helper.dart`)
- [x] App color constants and note colors (`core/constants/app_colors.dart`)
- [x] String constants for i18n preparation (`core/constants/app_strings.dart`)
- [x] Failure classes for error handling (`core/error/failures.dart`)
- [x] Date formatting utilities (`core/utils/date_formatter.dart`)
- [x] App theme with Material 3 (`core/theme/app_theme.dart`)
- [x] App router configuration (`core/router/app_router.dart`)
- [x] Dependency injection container (`core/di/injection_container.dart`)

### Domain Layer
- [x] Note entity (pure Dart, no dependencies)
- [x] Note repository interface with dartz Either
- [x] Use cases:
  - [x] GetAllNotes
  - [x] GetNoteById
  - [x] CreateNote
  - [x] UpdateNote
  - [x] DeleteNote
  - [x] SearchNotes
  - [x] TogglePinNote
  - [x] UpdateNoteColor

### Data Layer
- [x] Note model with SQLite mapping
- [x] Note mapper (Model ↔ Entity)
- [x] Notes local data source (SQLite operations)
- [x] Note repository implementation

### Presentation Layer
- [x] NotesCubit for notes list management
- [x] NotesState with freezed
- [x] NoteEditorCubit for note editing
- [x] NoteEditorState with freezed
- [x] Notes list page (home)
- [x] Note editor page

### UI Components
- [x] Note card widget (grid view)
- [x] Note list tile widget (list view)
- [x] Color picker widget
- [x] Search bar widget
- [x] Empty state widget
- [x] Loading state widget
- [x] Error state widget
- [x] Note actions bottom sheet

### Core Features
- [x] Create, edit, and delete notes
- [x] Auto-save while typing
- [x] Pin and unpin notes
- [x] Color-coded notes (8 colors)
- [x] Grid and list view toggle
- [x] Search notes by title and content
- [x] Sort notes (date, title, color)
- [x] Long-press quick actions
- [x] Timestamps (createdAt, updatedAt)

---

## 🔄 In Progress

_No items currently in progress_

---

## 📋 Planned Features

### Version 1.1 - Enhanced UX
- [ ] Swipe to delete/pin gestures
- [ ] Undo delete action
- [ ] Note sharing functionality
- [ ] Export notes to text file
- [ ] Keyboard shortcuts

### Version 1.2 - Organization
- [ ] Folders/categories for notes
- [ ] Tags system
- [ ] Archive notes
- [ ] Trash bin with restore

### Version 1.3 - Sync & Backup
- [ ] Cloud backup (Firebase/Supabase)
- [ ] Export/import all notes
- [ ] Auto-backup settings

### Version 2.0 - Advanced Features
- [ ] Rich text formatting
- [ ] Checklists/todos
- [ ] Image attachments
- [ ] Voice notes
- [ ] Reminders and notifications
- [ ] Note templates
- [ ] Biometric lock

---

## 📁 Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   └── app_strings.dart
│   ├── database/
│   │   └── sqlite_helper.dart
│   ├── di/
│   │   └── injection_container.dart
│   ├── error/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   ├── router/
│   │   └── app_router.dart
│   ├── theme/
│   │   └── app_theme.dart
│   └── utils/
│       └── date_formatter.dart
│
├── features/
│   └── notes/
│       ├── data/
│       │   ├── datasources/
│       │   │   └── local/
│       │   │       └── notes_local_datasource.dart
│       │   ├── mappers/
│       │   │   └── note_mapper.dart
│       │   ├── models/
│       │   │   └── note_model.dart
│       │   └── repositories/
│       │       └── note_repository_impl.dart
│       │
│       ├── domain/
│       │   ├── entities/
│       │   │   └── note_entity.dart
│       │   ├── repositories/
│       │   │   └── note_repository.dart
│       │   └── usecases/
│       │       ├── create_note.dart
│       │       ├── delete_note.dart
│       │       ├── get_all_notes.dart
│       │       ├── get_note_by_id.dart
│       │       ├── search_notes.dart
│       │       ├── toggle_pin_note.dart
│       │       ├── update_note.dart
│       │       ├── update_note_color.dart
│       │       └── usecase.dart
│       │
│       └── presentation/
│           ├── cubit/
│           │   ├── note_editor_cubit.dart
│           │   ├── note_editor_state.dart
│           │   ├── note_editor_state.freezed.dart
│           │   ├── notes_cubit.dart
│           │   ├── notes_state.dart
│           │   └── notes_state.freezed.dart
│           ├── pages/
│           │   ├── note_editor_page.dart
│           │   └── notes_list_page.dart
│           └── widgets/
│               ├── color_picker_widget.dart
│               ├── empty_state_widget.dart
│               ├── note_actions_sheet.dart
│               ├── note_card.dart
│               └── search_bar_widget.dart
│
└── main.dart
```

---

## 🛠 Tech Stack

| Category | Technology |
|----------|------------|
| Framework | Flutter 3.10+ |
| State Management | flutter_bloc (Cubit) |
| Local Storage | sqflite |
| Dependency Injection | get_it |
| Routing | go_router |
| Functional Programming | dartz |
| Immutable Data | freezed |

---

## 🚀 Getting Started

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Build for production
flutter build apk --release
```

---

## 📝 Notes

- Domain layer is pure Dart (no Flutter dependencies)
- All use cases return `Either<Failure, T>` for error handling
- Auto-save debounces with 1.5 second delay
- Pinned notes always appear at the top
- Supports both light and dark themes
