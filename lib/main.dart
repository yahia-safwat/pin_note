/// PinNote - A Flutter Notepad Application
///
/// A clean, modern notes app built with Clean Architecture,
/// SQLite for local storage, and Cubit for state management.
///
/// Architecture:
/// - Feature-based Clean Architecture
/// - Domain layer is pure Dart
/// - Repository Pattern for data access
/// - Dependency Injection with GetIt
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/di/injection_container.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize dependencies
  await initializeDependencies();

  // Run the app
  runApp(const PinNoteApp());
}

/// Root widget of the application.
class PinNoteApp extends StatelessWidget {
  const PinNoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // App info
      title: 'PinNote',
      debugShowCheckedModeBanner: false,

      // Theming
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      // Routing
      routerConfig: AppRouter.router,
    );
  }
}
