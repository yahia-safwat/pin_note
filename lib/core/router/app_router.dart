/// Application router using go_router.
///
/// Defines all navigation routes for the app with
/// type-safe route parameters.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/notes/presentation/pages/note_editor_page.dart';
import '../../features/notes/presentation/pages/notes_list_page.dart';

/// Route names as constants for type-safe navigation.
class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String noteEditor = '/note/:id';
  static const String newNote = '/note/new';
}

/// Application router configuration.
class AppRouter {
  AppRouter._();

  /// The GoRouter instance
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: true,
    routes: [
      // Home - Notes List
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const NotesListPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),

      // Note Editor (new or existing)
      GoRoute(
        path: '/note/:id',
        name: 'noteEditor',
        pageBuilder: (context, state) {
          final noteId = state.pathParameters['id'];
          // 'new' means creating a new note
          final isNew = noteId == 'new';

          return CustomTransitionPage(
            key: state.pageKey,
            child: NoteEditorPage(noteId: isNew ? null : noteId),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return SlideTransition(
                    position:
                        Tween<Offset>(
                          begin: const Offset(1, 0),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                          ),
                        ),
                    child: child,
                  );
                },
          );
        },
      ),
    ],

    // Error page
    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Page not found',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                state.uri.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go(AppRoutes.home),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
