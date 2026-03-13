import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/history_entry_model.dart';
import '../models/todo_item_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('dolar_bcv.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        amountBs REAL NOT NULL,
        rateUsed REAL NOT NULL,
        operation TEXT NOT NULL,
        sessionDate TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE todos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        text TEXT NOT NULL,
        isDone INTEGER NOT NULL
      )
    ''');
  }

  // --- History Methods ---
  Future<int> insertHistory(HistoryEntryModel entry) async {
    final db = await instance.database;
    return await db.insert('history', entry.toMap());
  }

  Future<List<HistoryEntryModel>> getAllHistory() async {
    final db = await instance.database;
    final maps = await db.query('history', orderBy: 'id DESC');
    return maps.map((map) => HistoryEntryModel.fromMap(map)).toList();
  }

  Future<void> clearHistory() async {
    final db = await instance.database;
    await db.delete('history');
  }

  // --- Todos Methods ---
  Future<int> insertTodo(TodoItemModel todo) async {
    final db = await instance.database;
    return await db.insert('todos', todo.toMap());
  }

  Future<List<TodoItemModel>> getAllTodos() async {
    final db = await instance.database;
    final maps = await db.query('todos', orderBy: 'id DESC');
    return maps.map((map) => TodoItemModel.fromMap(map)).toList();
  }

  Future<int> updateTodo(TodoItemModel todo) async {
    final db = await instance.database;
    return await db.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  Future<void> deleteDoneTodos() async {
    final db = await instance.database;
    await db.delete('todos', where: 'isDone = ?', whereArgs: [1]);
  }
}
