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
  final page = 1.obs;

  final expenseTypes = <ExpenseType, double>{}.obs;

  final listExpenses = <DateTime, List<Expense>>{}.obs;

  @override
  void onInit() {
    refreshController = RefreshController(initialRefresh: true);
    super.onInit();
  }

  onRefresh() async {
    page.value = 1;
    listExpenses.clear();
    await onGetTotalOutcomeDay();
    await onGetListExpenses(DateTime.now().subtract(const Duration(days: 7)), DateTime.now());
    await onGetTotalOutcomeMonth();
    await onGetAllExpenseTypes();
    await Future.delayed(Duration(seconds: 2));
    refreshController.refreshCompleted();
    refreshController.resetNoData();
  }

  onLoad() async {
    page.value += 1;
    await onGetListExpenses(DateTime.now().subtract(Duration(days: 7 * page.value)), DateTime.now().subtract(Duration(days: 7 * (page.value - 1))));
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
    final expenses = await _expenseRepository.getExpensesByDateRange(DateTime.now().copyWith(hour: 0, minute: 0), DateTime.now());

    totalOutcomeDay.value = expenses.fold(0.0, (sum, expense) => sum + expense.price);
    log("Total Outcome Day: ${totalOutcomeDay.value}");
  }

  onGetTotalOutcomeMonth() async {
    final expenses = await _expenseRepository.getExpensesForMonth(DateTime(DateTime.now().year, DateTime.now().month, 1));

    totalOutcomeMonth.value = expenses.fold(0.0, (sum, expense) => sum + expense.price);
    log("Total Outcome Month: ${totalOutcomeMonth.value}");
  }

  onGetListExpenses(dateStart, dateEnd) async {
    final expenses = await _expenseRepository.getExpensesByDateRange(dateStart, dateEnd ?? DateTime.now());
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
