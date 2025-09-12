import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:money_expense/app/data/models/expense.dart';
import 'dart:io';

class DatabaseHelper {
  static const _databaseName = 'expense_database.db';
  static const _databaseVersion = 1;

  // Table name
  static const table = 'expenses';

  // Column names
  static const columnId = 'id';
  static const columnName = 'name';
  static const columnType = 'type';
  static const columnDateTime = 'date_time';
  static const columnPrice = 'price';

  // Make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Open the database and create it if it doesn't exist
  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);

    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  // Create the database table
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId TEXT PRIMARY KEY,
        $columnName TEXT NOT NULL,
        $columnType TEXT NOT NULL,
        $columnDateTime TEXT NOT NULL,
        $columnPrice REAL NOT NULL
      )
    ''');
  }

  // Insert an expense into the database
  Future<int> insertExpense(Expense expense) async {
    Database db = await database;
    return await db.insert(table, expense.toDbMap());
  }

  // Get all expenses
  Future<List<Expense>> getExpenses() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(table, orderBy: '$columnDateTime DESC');
    return List.generate(maps.length, (i) => Expense.fromDbMap(maps[i]));
  }

  // Get a single expense by id
  Future<Expense?> getExpense(String id) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(table, where: '$columnId = ?', whereArgs: [id], limit: 1);
    if (maps.isNotEmpty) {
      return Expense.fromDbMap(maps.first);
    }
    return null;
  }

  // Update an expense
  Future<int> updateExpense(Expense expense) async {
    Database db = await database;
    return await db.update(table, expense.toDbMap(), where: '$columnId = ?', whereArgs: [expense.id]);
  }

  // Delete an expense
  Future<int> deleteExpense(String id) async {
    Database db = await database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  // Get expenses by date range
  Future<List<Expense>> getExpensesByDateRange(DateTime start, DateTime end) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      table,
      where: '$columnDateTime BETWEEN ? AND ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      orderBy: '$columnDateTime DESC',
    );
    return List.generate(maps.length, (i) => Expense.fromDbMap(maps[i]));
  }

  // Get total expenses by type
  Future<Map<String, double>> getExpensesByType() async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT $columnType, SUM($columnPrice) as total
      FROM $table
      GROUP BY $columnType
    ''');

    Map<String, double> expensesByType = {};
    for (var row in result) {
      expensesByType[row[columnType] as String] = row['total'] as double;
    }
    return expensesByType;
  }

  // Close the database connection
  Future<void> close() async {
    final db = await database;
    await db.close();
  }

  Future<int> clearDatabase() async {
    Database db = await database;
    return await db.delete(table);
  }
}
