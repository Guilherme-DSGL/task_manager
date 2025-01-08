import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabaseService {
  static final LocalDatabaseService _instance = LocalDatabaseService._();

  static LocalDatabaseService get instance => _instance;

  LocalDatabaseService._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'todo_database.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE todos(id INTEGER PRIMARY KEY, title TEXT, description TEXT, isCompleted INTEGER)',
        );
      },
    );
  }

  Future<int> insert(
    String table,
    Map<String, dynamic> values,
  ) async {
    final db = await database;
    return await db.insert(table, values);
  }

  Future<int> update(
    String table,
    Map<String, dynamic> values,
    String where,
    List<Object?> whereArgs,
  ) async {
    final db = await database;
    return await db.update(
      table,
      values,
      where: where,
      whereArgs: whereArgs,
    );
  }

  Future<int> delete(
      String table, String where, List<Object?> whereArgs) async {
    final db = await database;
    return await db.delete(
      table,
      where: where,
      whereArgs: whereArgs,
    );
  }

  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<Object?>? whereArgs,
    int? limit,
    int? offset,
  }) async {
    final db = await database;
    return await db.query(
      table,
      where: where,
      whereArgs: whereArgs,
      limit: limit,
      offset: offset,
    );
  }
}
