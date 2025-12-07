import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('health_mate.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    print('Database path: $path');

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    print('Creating database tables...');
    
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        name TEXT NOT NULL
      )
    ''');
    print('Users table created');

    await db.execute('''
      CREATE TABLE user_profile (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        name TEXT NOT NULL,
        height REAL NOT NULL,
        weight REAL NOT NULL,
        gender TEXT NOT NULL,
        age INTEGER NOT NULL,
        FOREIGN KEY (userId) REFERENCES users (id)
      )
    ''');
    print('User_profile table created');

    await db.execute('''
      CREATE TABLE health_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        date TEXT NOT NULL,
        steps INTEGER NOT NULL,
        caloriesBurned INTEGER NOT NULL,
        waterIntake INTEGER NOT NULL,
        sleepHours REAL NOT NULL,
        FOREIGN KEY (userId) REFERENCES users (id)
      )
    ''');
    print('Health_records table created');
    print('All tables created successfully');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    print('Upgrading database from version $oldVersion to $newVersion');
    // Add any future schema changes here
  }

  // User methods
  Future<int?> registerUser(Map<String, dynamic> user) async {
    try {
      final db = await instance.database;
      return await db.insert('users', user);
    } catch (e) {
      print('Registration error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    try {
      final db = await instance.database;
      final result = await db.query(
        'users',
        where: 'email = ? AND password = ?',
        whereArgs: [email, password],
      );
      return result.isNotEmpty ? result.first : null;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  // Profile methods
  Future<void> insertProfile(Map<String, dynamic> profile) async {
    final db = await instance.database;
    final existing = await db.query(
      'user_profile',
      where: 'userId = ?',
      whereArgs: [profile['userId']],
    );

    if (existing.isNotEmpty) {
      await db.update(
        'user_profile',
        profile,
        where: 'userId = ?',
        whereArgs: [profile['userId']],
      );
    } else {
      await db.insert('user_profile', profile);
    }
  }

  Future<Map<String, dynamic>?> getProfile(String userId) async {
    final db = await instance.database;
    final result = await db.query(
      'user_profile',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // Health records methods
  Future<void> insertRecord(Map<String, dynamic> record) async {
    try {
      final db = await instance.database;
      final result = await db.insert('health_records', record);
      print('Record inserted with ID: $result, Data: $record');
    } catch (e) {
      print('Insert record error: $e');
      throw e;
    }
  }

  Future<List<Map<String, dynamic>>> getRecords(String userId) async {
    final db = await instance.database;
    return await db.query(
      'health_records',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'date DESC',
    );
  }

  Future<Map<String, dynamic>?> getRecordByDate(String userId, String date) async {
    final db = await instance.database;
    final result = await db.query(
      'health_records',
      where: 'userId = ? AND date = ?',
      whereArgs: [userId, date],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<void> updateRecord(Map<String, dynamic> record) async {
    final db = await instance.database;
    await db.update(
      'health_records',
      record,
      where: 'id = ?',
      whereArgs: [record['id']],
    );
  }

  Future<void> deleteRecord(String id) async {
    final db = await instance.database;
    await db.delete(
      'health_records',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<bool> testConnection() async {
    try {
      await database;
      return true;
    } catch (e) {
      print('Database connection test failed: $e');
      return false;
    }
  }

  Future<String> getDatabasePath() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'health_mate.db');
    print('Database path: $path');
    return path;
  }

  // Debug methods to view all data
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await instance.database;
    return await db.query('users');
  }

  Future<List<Map<String, dynamic>>> getAllProfiles() async {
    final db = await instance.database;
    return await db.query('user_profile');
  }

  Future<List<Map<String, dynamic>>> getAllRecords() async {
    final db = await instance.database;
    return await db.query('health_records', orderBy: 'date DESC');
  }
}