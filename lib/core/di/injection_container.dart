/// Dependency Injection Container.
///
/// Centralized registration of all dependencies using GetIt.
/// This follows the Service Locator pattern for dependency injection.
library;

import 'package:get_it/get_it.dart';

import '../database/sqlite_helper.dart';
import '../../features/notes/data/datasources/local/notes_local_datasource.dart';
import '../../features/notes/data/repositories/note_repository_impl.dart';
import '../../features/notes/domain/repositories/note_repository.dart';
import '../../features/notes/domain/usecases/create_note.dart';
import '../../features/notes/domain/usecases/delete_note.dart';
import '../../features/notes/domain/usecases/get_all_notes.dart';
import '../../features/notes/domain/usecases/get_note_by_id.dart';
import '../../features/notes/domain/usecases/search_notes.dart';
import '../../features/notes/domain/usecases/toggle_pin_note.dart';
import '../../features/notes/domain/usecases/update_note.dart';
import '../../features/notes/domain/usecases/update_note_color.dart';
import '../../features/notes/presentation/cubit/note_editor_cubit.dart';
import '../../features/notes/presentation/cubit/notes_cubit.dart';

/// Global service locator instance.
final sl = GetIt.instance;

/// Initialize all dependencies.
///
/// Call this before runApp() in main.dart.
Future<void> initializeDependencies() async {
  // ============================================
  // CORE
  // ============================================

  // Database
  sl.registerLazySingleton<SqliteHelper>(() => SqliteHelper.instance);

  // ============================================
  // FEATURES - NOTES
  // ============================================

  // --- Data Sources ---
  sl.registerLazySingleton<NotesLocalDataSource>(
    () => NotesLocalDataSourceImpl(sqliteHelper: sl()),
  );

  // --- Repositories ---
  sl.registerLazySingleton<NoteRepository>(
    () => NoteRepositoryImpl(localDataSource: sl()),
  );

  // --- Use Cases ---
  sl.registerLazySingleton(() => GetAllNotes(sl()));
  sl.registerLazySingleton(() => GetNoteById(sl()));
  sl.registerLazySingleton(() => CreateNote(sl()));
  sl.registerLazySingleton(() => UpdateNote(sl()));
  sl.registerLazySingleton(() => DeleteNote(sl()));
  sl.registerLazySingleton(() => SearchNotes(sl()));
  sl.registerLazySingleton(() => TogglePinNote(sl()));
  sl.registerLazySingleton(() => UpdateNoteColor(sl()));

  // --- Cubits ---
  // NotesCubit is a factory because multiple instances may be needed
  sl.registerFactory(
    () => NotesCubit(
      getAllNotes: sl(),
      searchNotes: sl(),
      deleteNote: sl(),
      togglePinNote: sl(),
      updateNoteColor: sl(),
    ),
  );

  // NoteEditorCubit is a factory for each editor instance
  sl.registerFactory(
    () => NoteEditorCubit(
      getNoteById: sl(),
      createNote: sl(),
      updateNote: sl(),
      deleteNote: sl(),
    ),
  );
}

/// Reset all dependencies (useful for testing).
Future<void> resetDependencies() async {
  await sl.reset();
}
