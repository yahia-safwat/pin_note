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
- [x] App shell with bottom navigation (`core/widgets/app_shell.dart`)

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
- [x] Notes list page (home) - minimal design
- [x] Note editor page - minimal design

### UI Components
- [x] Note card widget (matching reference design)
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
- [x] Grid and list view toggle (in menu)
- [x] Search notes by title and content
- [x] Sort notes (date, title, color) - in menu
- [x] Long-press quick actions
- [x] Timestamps (createdAt, updatedAt)

### Navigation & Layout
- [x] Bottom navigation bar (4 tabs)
- [x] Home (Notes) tab
- [x] Tasks tab (placeholder)
- [x] Notifications tab (placeholder)
- [x] Settings tab (with options)
- [x] Centered FAB with lavender color
- [x] Minimal AppBar with menu

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

### Version 1.3 - Tasks Feature
- [ ] Create tasks with due dates
- [ ] Task list view
- [ ] Task completion tracking
- [ ] Task reminders

### Version 1.4 - Sync & Backup
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
│   ├── utils/
│   │   └── date_formatter.dart
│   └── widgets/
│       └── app_shell.dart
│
├── features/
│   ├── notes/
│   │   ├── data/
│   │   │   ├── datasources/local/
│   │   │   ├── mappers/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── cubit/
│   │       ├── pages/
│   │       └── widgets/
│   │
│   ├── tasks/
│   │   └── presentation/pages/
│   │
│   ├── notifications/
│   │   └── presentation/pages/
│   │
│   └── settings/
│       └── presentation/pages/
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
- Bottom navigation with 4 tabs (Home, Tasks, Notifications, Settings)
- Minimal, professional UI inspired by reference design
