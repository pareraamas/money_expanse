import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:money_expense/app/data/models/expense.dart';
import 'package:money_expense/app/data/models/category_model.dart';
import 'package:money_expense/app/data/models/expense_type.dart';
import 'package:money_expense/app/data/models/budget_model.dart';
import 'dart:io';

class DatabaseHelper {
  static const _databaseName = 'expense_database.db';
  static const _databaseVersion = 1;

  // Table names
  static const tableExpenses = 'expenses';
  static const tableCategories = 'categories';
  static const tableBudgets = 'budgets';

  // Expense Column names
  static const columnId = 'id';
  static const columnName = 'name';
  static const columnType = 'type'; // References Category ID
  static const columnTransactionType = 'transaction_type';
  static const columnDateTime = 'date_time';
  static const columnPrice = 'price';

  // Category Column names
  static const catId = 'id';
  static const catLabel = 'label';
  static const catColor = 'color_value';
  static const catIcon = 'icon';

  // Budget Column names
  static const budgetId = 'id';
  static const budgetCategoryId = 'category_id';
  static const budgetYearMonth = 'year_month'; // Format: 'YYYY-MM'
  static const budgetAmount = 'amount';

  // Make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create Categories table first
    await db.execute('''
      CREATE TABLE $tableCategories (
        $catId TEXT PRIMARY KEY,
        $catLabel TEXT NOT NULL,
        $catColor INTEGER NOT NULL,
        $catIcon TEXT NOT NULL
      )
    ''');

    // Create Expenses table
    await db.execute('''
      CREATE TABLE $tableExpenses (
        $columnId TEXT PRIMARY KEY,
        $columnName TEXT NOT NULL,
        $columnType TEXT NOT NULL,
        $columnTransactionType TEXT NOT NULL DEFAULT 'expense',
        $columnDateTime TEXT NOT NULL,
        $columnPrice REAL NOT NULL
      )
    ''');

    // Create Budgets table (one budget per category per month)
    await db.execute('''
      CREATE TABLE $tableBudgets (
        $budgetId TEXT PRIMARY KEY,
        $budgetCategoryId TEXT NOT NULL,
        $budgetYearMonth TEXT NOT NULL,
        $budgetAmount REAL NOT NULL,
        UNIQUE($budgetCategoryId, $budgetYearMonth)
      )
    ''');

    // Seed default categories
    for (var type in ExpenseType.values) {
      await db.insert(tableCategories, {
        'id': type
            .toShortString()
            .toLowerCase(), // Use enum name as ID for migration compatibility
        'label': type.label,
        'color_value': type.color.toARGB32(),
        'icon': type.icon,
      });
    }
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Schema history was squashed into version 1 — any older install just gets reset.
    await db.execute('DROP TABLE IF EXISTS $tableExpenses');
    await db.execute('DROP TABLE IF EXISTS $tableCategories');
    await db.execute('DROP TABLE IF EXISTS $tableBudgets');
    await _onCreate(db, newVersion);
  }

  // --- Category Methods ---

  Future<List<Category>> getCategories() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(tableCategories);
    return List.generate(maps.length, (i) => Category.fromMap(maps[i]));
  }

  Future<int> insertCategory(Category category) async {
    Database db = await database;
    return await db.insert(tableCategories, category.toMap());
  }

  Future<int> updateCategory(Category category) async {
    Database db = await database;
    return await db.update(
      tableCategories,
      category.toMap(),
      where: '$catId = ?',
      whereArgs: [category.id],
    );
  }

  Future<int> countExpensesByCategory(String categoryId) async {
    Database db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $tableExpenses WHERE $columnType = ?',
      [categoryId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> deleteCategory(String categoryId) async {
    Database db = await database;
    return await db.delete(
      tableCategories,
      where: '$catId = ?',
      whereArgs: [categoryId],
    );
  }

  // --- Budget Methods ---

  Future<List<Budget>> getBudgetsForMonth(String yearMonth) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      tableBudgets,
      where: '$budgetYearMonth = ?',
      whereArgs: [yearMonth],
    );
    return List.generate(maps.length, (i) => Budget.fromMap(maps[i]));
  }

  Future<void> setBudget(
    String categoryId,
    String yearMonth,
    double amount,
  ) async {
    Database db = await database;
    final existing = await db.query(
      tableBudgets,
      where: '$budgetCategoryId = ? AND $budgetYearMonth = ?',
      whereArgs: [categoryId, yearMonth],
    );

    if (existing.isNotEmpty) {
      await db.update(
        tableBudgets,
        {budgetAmount: amount},
        where: '$budgetId = ?',
        whereArgs: [existing.first[budgetId]],
      );
    } else {
      await db.insert(
        tableBudgets,
        Budget.create(
          categoryId: categoryId,
          yearMonth: yearMonth,
          amount: amount,
        ).toMap(),
      );
    }
  }

  Future<int> deleteBudget(String categoryId, String yearMonth) async {
    Database db = await database;
    return await db.delete(
      tableBudgets,
      where: '$budgetCategoryId = ? AND $budgetYearMonth = ?',
      whereArgs: [categoryId, yearMonth],
    );
  }

  // --- Expense Methods ---

  Future<int> insertExpense(Expense expense) async {
    Database db = await database;
    return await db.insert(tableExpenses, expense.toDbMap());
  }

  Future<List<Expense>> getExpenses({int limit = 10, int offset = 0}) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT e.*, c.label as cat_label, c.color_value as cat_color, c.icon as cat_icon
      FROM $tableExpenses e
      JOIN $tableCategories c ON e.$columnType = c.$catId
      ORDER BY e.$columnDateTime DESC
      LIMIT ? OFFSET ?
    ''',
      [limit, offset * limit],
    );

    return List.generate(maps.length, (i) {
      final map = maps[i];
      final category = Category(
        id: map[columnType] as String,
        label: map['cat_label'] as String,
        colorValue: map['cat_color'] as int,
        icon: map['cat_icon'] as String,
      );
      return Expense.fromDbMap(map).copyWith(category: category);
    });
  }

  Future<Expense?> getExpense(String id) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT e.*, c.label as cat_label, c.color_value as cat_color, c.icon as cat_icon
      FROM $tableExpenses e
      JOIN $tableCategories c ON e.$columnType = c.$catId
      WHERE e.$columnId = ?
    ''',
      [id],
    );

    if (maps.isNotEmpty) {
      final map = maps.first;
      final category = Category(
        id: map[columnType] as String,
        label: map['cat_label'] as String,
        colorValue: map['cat_color'] as int,
        icon: map['cat_icon'] as String,
      );
      return Expense.fromDbMap(map).copyWith(category: category);
    }
    return null;
  }

  Future<int> updateExpense(Expense expense) async {
    Database db = await database;
    return await db.update(
      tableExpenses,
      expense.toDbMap(),
      where: '$columnId = ?',
      whereArgs: [expense.id],
    );
  }

  Future<int> deleteExpense(String id) async {
    Database db = await database;
    return await db.delete(
      tableExpenses,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<List<Expense>> getExpensesByDateRange(
    DateTime start,
    DateTime end, {
    String? transactionType,
  }) async {
    Database db = await database;
    String whereClause = 'e.$columnDateTime BETWEEN ? AND ?';
    List<dynamic> whereArgs = [start.toIso8601String(), end.toIso8601String()];

    if (transactionType != null) {
      whereClause += ' AND e.$columnTransactionType = ?';
      whereArgs.add(transactionType);
    }

    List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT e.*, c.label as cat_label, c.color_value as cat_color, c.icon as cat_icon
      FROM $tableExpenses e
      JOIN $tableCategories c ON e.$columnType = c.$catId
      WHERE $whereClause
      ORDER BY e.$columnDateTime DESC
    ''', whereArgs);

    return List.generate(maps.length, (i) {
      final map = maps[i];
      final category = Category(
        id: map[columnType] as String,
        label: map['cat_label'] as String,
        colorValue: map['cat_color'] as int,
        icon: map['cat_icon'] as String,
      );
      return Expense.fromDbMap(map).copyWith(category: category);
    });
  }

  // Get total expenses by category label (using join)
  Future<Map<String, double>> getExpensesByType({
    String transactionType = 'expense',
  }) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.rawQuery(
      '''
      SELECT c.$catLabel as category_label, SUM(e.$columnPrice) as total
      FROM $tableExpenses e
      JOIN $tableCategories c ON e.$columnType = c.$catId
      WHERE e.$columnTransactionType = ?
      GROUP BY c.$catLabel
    ''',
      [transactionType],
    );

    Map<String, double> expensesByType = {};
    for (var row in result) {
      expensesByType[row['category_label'] as String] = row['total'] as double;
    }
    return expensesByType;
  }

  // Get total spent per category id within a date range (for budget tracking)
  Future<Map<String, double>> getSpendingByCategoryForRange(
    DateTime start,
    DateTime end, {
    String transactionType = 'expense',
  }) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.rawQuery(
      '''
      SELECT $columnType as category_id, SUM($columnPrice) as total
      FROM $tableExpenses
      WHERE $columnTransactionType = ? AND $columnDateTime BETWEEN ? AND ?
      GROUP BY $columnType
    ''',
      [transactionType, start.toIso8601String(), end.toIso8601String()],
    );

    Map<String, double> spendingByCategory = {};
    for (var row in result) {
      spendingByCategory[row['category_id'] as String] = (row['total'] as num)
          .toDouble();
    }
    return spendingByCategory;
  }

  Future<double> getTotalAmountByDateRange(
    DateTime start,
    DateTime end,
    String transactionType,
  ) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.rawQuery(
      '''
      SELECT SUM($columnPrice) as total
      FROM $tableExpenses
      WHERE $columnTransactionType = ? AND $columnDateTime BETWEEN ? AND ?
    ''',
      [transactionType, start.toIso8601String(), end.toIso8601String()],
    );

    return result.first['total'] as double? ?? 0.0;
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }

  Future<int> clearDatabase() async {
    Database db = await database;
    await db.delete(tableExpenses);
    return await db.delete(tableCategories);
  }
}
