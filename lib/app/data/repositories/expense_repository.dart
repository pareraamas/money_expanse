import 'package:money_expense/app/data/local/database_helper.dart';
import 'package:money_expense/app/data/models/expense.dart';

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
  Future<List<Expense>> getExpensesByDateRange(DateTime start, DateTime end) async {
    return await _databaseHelper.getExpensesByDateRange(start, end);
  }

  // Get total expenses by type
  Future<Map<String, double>> getExpensesByType() async {
    return await _databaseHelper.getExpensesByType();
  }

  // Get total expenses amount
  // Future<double> getTotalExpenses() async {
  //   final expenses = await _databaseHelper.getExpenses();
  //   return expenses.fold(0, (sum, expense) => sum + expense.nominal);
  // }

  // Get expenses for a specific month
  Future<List<Expense>> getExpensesForMonth(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0, 23, 59, 59);
    return _databaseHelper.getExpensesByDateRange(firstDay, lastDay);
  }

  // Get total expenses for a specific month
  Future<Map<String, double>> getMonthlyExpensesByType(DateTime month) async {
    final expenses = await getExpensesForMonth(month);
    final result = <String, double>{};

    for (var expense in expenses) {
      result.update(expense.type, (value) => value + expense.price, ifAbsent: () => expense.price);
    }

    return result;
  }
}
