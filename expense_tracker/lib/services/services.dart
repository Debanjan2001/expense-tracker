import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Services {
  Database? _database;

  Future<void> initDB() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'expense_tracker.db'),
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE transactions(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            msg_id INTEGER,
            title TEXT,
            amount REAL,
            date TEXT, 
            type TEXT
          )
        ''');
      },
    );
  }

  // Add methods for interacting with the database here
  Database getDB() {
    if (_database == null) {
      throw Exception("Database not initialized");
    }
    return _database!;
  }
}
