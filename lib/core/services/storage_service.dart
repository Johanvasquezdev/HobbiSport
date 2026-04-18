import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../error/exceptions.dart';

abstract class StorageService {
  Future<Database> database();
}

class StorageServiceImpl implements StorageService {
  StorageServiceImpl();

  Database? _db;

  @override
  Future<Database> database() async {
    if (_db != null) return _db!;

    try {
      final dbPath = await getDatabasesPath();
      _db = await openDatabase(
        p.join(dbPath, 'hobbisport.db'),
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS posts(
              id TEXT PRIMARY KEY,
              userId TEXT,
              username TEXT,
              content TEXT,
              avatarUrl TEXT,
              likesCount INTEGER,
              commentsCount INTEGER,
              likedByMe INTEGER,
              createdAt TEXT
            )
          ''');
          await db.execute('''
            CREATE TABLE IF NOT EXISTS events(
              id TEXT PRIMARY KEY,
              title TEXT,
              description TEXT,
              dateTime TEXT,
              location TEXT,
              category TEXT,
              colorHex TEXT,
              createdAt TEXT
            )
          ''');
          await db.execute('''
            CREATE TABLE IF NOT EXISTS sport_activities(
              id TEXT PRIMARY KEY,
              sportType TEXT,
              date TEXT,
              durationMinutes INTEGER,
              distanceKm REAL,
              caloriesBurned INTEGER,
              notes TEXT,
              createdAt TEXT
            )
          ''');
        },
      );
      return _db!;
    } catch (e) {
      throw CacheException('Failed to open local database: $e');
    }
  }
}
