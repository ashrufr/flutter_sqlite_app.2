import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'records_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE records(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT NOT NULL
      )
    ''');
    
    // Insert some sample data
    await insertSampleData();
  }

  Future<void> insertSampleData() async {
    final Database db = await database;
    
    // Check if we already have data
    final count = await getRecordCount();
    if (count == 0) {
      // Insert sample records
      await db.insert('records', {'name': 'Sample 1', 'description': 'This is the first sample record'});
      await db.insert('records', {'name': 'Sample 2', 'description': 'This is the second sample record'});
      await db.insert('records', {'name': 'Sample 3', 'description': 'This is the third sample record'});
      await db.insert('records', {'name': 'Sample 4', 'description': 'This is the fourth sample record'});
      await db.insert('records', {'name': 'Sample 5', 'description': 'This is the fifth sample record'});
    }
  }

  Future<List<Map<String, dynamic>>> getAllRecords() async {
    final Database db = await database;
    return await db.query('records', orderBy: 'id ASC');
  }
  
  Future<Map<String, dynamic>?> getRecordById(int id) async {
    final Database db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'records',
      where: 'id = ?',
      whereArgs: [id],
    );
    
    return result.isNotEmpty ? result.first : null;
  }
  
  Future<Map<String, dynamic>?> getNextRecord(int currentId) async {
    final Database db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'records',
      where: 'id > ?',
      whereArgs: [currentId],
      orderBy: 'id ASC',
      limit: 1,
    );
    
    return result.isNotEmpty ? result.first : null;
  }
  
  Future<Map<String, dynamic>?> getPreviousRecord(int currentId) async {
    final Database db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'records',
      where: 'id < ?',
      whereArgs: [currentId],
      orderBy: 'id DESC',
      limit: 1,
    );
    
    return result.isNotEmpty ? result.first : null;
  }
  
  Future<Map<String, dynamic>?> getFirstRecord() async {
    final Database db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'records',
      orderBy: 'id ASC',
      limit: 1,
    );
    
    return result.isNotEmpty ? result.first : null;
  }
  
  Future<int> getRecordCount() async {
    final Database db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM records');
    return Sqflite.firstIntValue(result) ?? 0;
  }
}

