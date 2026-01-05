/// SQLite database helper singleton.
///
/// Provides centralized database management including:
/// - Database initialization
/// - Table creation
/// - Connection management
///
/// This is a reusable helper that can be extended for additional tables.
library;

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../constants/app_strings.dart';

/// Singleton class for managing SQLite database operations.
class SqliteHelper {
  // Private constructor for singleton pattern
  SqliteHelper._();

  // Singleton instance
  static final SqliteHelper instance = SqliteHelper._();

  // Database instance
  static Database? _database;

  /// Database version - increment when schema changes
  static const int _databaseVersion = 1;

  /// Get the database instance, initializing if necessary.
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  /// Initialize the database.
  Future<Database> _initDatabase() async {
    // Get the default database path
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, AppStrings.databaseName);

    // Open the database, creating it if it doesn't exist
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Create database tables.
  Future<void> _onCreate(Database db, int version) async {
    // Create notes table
    await db.execute('''
      CREATE TABLE ${AppStrings.notesTable} (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        color INTEGER NOT NULL,
        isPinned INTEGER NOT NULL DEFAULT 0,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');

    // Create index for faster searches
    await db.execute('''
      CREATE INDEX idx_notes_pinned ON ${AppStrings.notesTable} (isPinned DESC, updatedAt DESC)
    ''');

    await db.execute('''
      CREATE INDEX idx_notes_updated ON ${AppStrings.notesTable} (updatedAt DESC)
    ''');
  }

  /// Handle database upgrades (for future schema changes).
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle migrations here when needed
    // Example:
    // if (oldVersion < 2) {
    //   await db.execute('ALTER TABLE notes ADD COLUMN category TEXT');
    // }
  }

  /// Close the database connection.
  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  /// Delete the database (useful for testing/reset).
  Future<void> deleteDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, AppStrings.databaseName);
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }
}
