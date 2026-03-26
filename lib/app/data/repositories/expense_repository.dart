import 'package:money_expense/app/data/local/database_helper.dart';
import 'package:money_expense/app/data/models/expense.dart';
import 'package:money_expense/app/data/models/category_model.dart';

class ExpenseRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  // Insert a new expense
  Future<int> insertExpense(Expense expense) async {
    return await _databaseHelper.insertExpense(expense);
  }

  // Clear the database
  Future<int> clearDatabase() async {
    return await _databaseHelper.clearDatabase();
  }

  // Get expenses with pagination
  Future<List<Expense>> getExpenses({int limit = 10, int offset = 0}) async {
    return await _databaseHelper.getExpenses(limit: limit, offset: offset);
  }

  // Get a single expense by id
  Future<Expense?> getExpense(String id) async {
    return await _databaseHelper.getExpense(id);
  }

  // Update an expense
  Future<int> updateExpense(Expense expense) async {
    return await _databaseHelper.updateExpense(expense);
  }

  // Delete an expense
  Future<int> deleteExpense(String id) async {
    return await _databaseHelper.deleteExpense(id);
  }

  // Get expenses by date range
  Future<List<Expense>> getExpensesByDateRange(DateTime start, DateTime end, {String? transactionType}) async {
    return await _databaseHelper.getExpensesByDateRange(start, end, transactionType: transactionType);
  }

  // Get total expenses by type
  Future<Map<String, double>> getExpensesByType({String transactionType = 'expense'}) async {
    return await _databaseHelper.getExpensesByType(transactionType: transactionType);
  }

  // Get total amount for a date range and type
  Future<double> getTotalAmount(DateTime start, DateTime end, String transactionType) async {
    return await _databaseHelper.getTotalAmountByDateRange(start, end, transactionType);
  }

  // Get expenses for a specific month
  Future<List<Expense>> getExpensesForMonth(DateTime month, {String? transactionType}) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0, 23, 59, 59);
    return _databaseHelper.getExpensesByDateRange(firstDay, lastDay, transactionType: transactionType);
  }

  // Get monthly summary
  Future<double> getMonthlyTotal(DateTime month, String transactionType) async {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0, 23, 59, 59);
    return _databaseHelper.getTotalAmountByDateRange(firstDay, lastDay, transactionType);
  }

  // --- Category Methods ---

  Future<List<Category>> getCategories() async {
    return await _databaseHelper.getCategories();
  }

  Future<int> insertCategory(Category category) async {
    return await _databaseHelper.insertCategory(category);
  }
}
