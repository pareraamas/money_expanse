import 'dart:developer';

import 'package:get/get.dart';
import 'package:money_expense/app/data/models/expense.dart';
import 'package:money_expense/app/data/models/expense_type.dart';
import 'package:money_expense/app/data/repositories/expense_repository.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeController extends GetxController {
  final ExpenseRepository _expenseRepository = ExpenseRepository();
  late RefreshController refreshController;

  final totalOutcomeDay = 0.0.obs;
  final totalOutcomeMonth = 0.0.obs;
  final totalOutcomeYear = 0.0.obs;
  final page = 1.obs;

  final expenseTypes = <ExpenseType, double>{}.obs;

  final listExpenses = <DateTime, List<Expense>>{}.obs;

  @override
  void onInit() {
    refreshController = RefreshController(initialRefresh: true);
    super.onInit();
  }

  void onRefresh() async {
    page.value = 0;
    listExpenses.clear();
    await onGetTotalOutcomeDay();
    await onGetListExpenses();
    await onGetTotalOutcomeMonth();
    await onGetAllExpenseTypes();
    await onGetTotalOutcomeYear();
    await Future.delayed(Duration(seconds: 2));
    refreshController.refreshCompleted();
    refreshController.resetNoData();
  }

  onLoad() async {
    page.value += 1;
    await onGetListExpenses();
    await Future.delayed(Duration(seconds: 2));
    refreshController.loadComplete();
  }

  onGetAllExpenseTypes() async {
    final expensesByType = await _expenseRepository.getExpensesByType();
    expenseTypes.clear();
    for (var type in ExpenseType.values) {
      expenseTypes[type] = expensesByType[type.name] ?? 0.0;
    }

    log("Expense Types: $expenseTypes");
  }

  onGetTotalOutcomeDay() async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day); // 00:00:00
    final end = DateTime(now.year, now.month, now.day, 23, 59, 59, 999); // 23:59:59.999

    final expenses = await _expenseRepository.getExpensesByDateRange(start, end);

    totalOutcomeDay.value = expenses.fold(0.0, (sum, expense) => sum + expense.price);
    log("Total Outcome Day: ${expenses}");
  }

  onGetTotalOutcomeMonth() async {
    final expenses = await _expenseRepository.getExpensesForMonth(DateTime(DateTime.now().year, DateTime.now().month, 1));

    totalOutcomeMonth.value = expenses.fold(0.0, (sum, expense) => sum + expense.price);
    log("Total Outcome Month: ${totalOutcomeMonth.value}");
  }

  onGetTotalOutcomeYear() async {
    final now = DateTime.now();
    final start = DateTime(now.year, 1, 1); // January 1st, 00:00:00
    final end = DateTime(now.year, 12, 31, 23, 59, 59, 999); // December 31st, 23:59:
    final expenses = await _expenseRepository.getExpensesByDateRange(start, end);

    totalOutcomeYear.value = expenses.fold(0.0, (sum, expense) => sum + expense.price);
    log("Total Outcome Month: ${totalOutcomeYear.value}");
  }

  onGetListExpenses() async {
    final expenses = await _expenseRepository.getExpenses(offset: page.value);
    for (var expense in expenses) {
      final date = DateTime(expense.dateTime.year, expense.dateTime.month, expense.dateTime.day);
      if (listExpenses.containsKey(date)) {
        listExpenses[date]!.add(expense);
      } else {
        listExpenses[date] = [expense];
      }
    }
    log("List Expenses: $listExpenses");
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }
}
