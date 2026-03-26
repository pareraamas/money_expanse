import 'package:get/get.dart';
import 'package:money_expense/app/data/models/category_model.dart';
import 'package:money_expense/app/data/models/expense.dart';
import 'package:money_expense/app/data/repositories/expense_repository.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeController extends GetxController {
  final ExpenseRepository _expenseRepository = Get.find<ExpenseRepository>();
  late RefreshController refreshController;

  final totalOutcomeDay = 0.0.obs;
  final totalOutcomeMonth = 0.0.obs;
  final totalIncomeMonth = 0.0.obs;
  final totalBalance = 0.0.obs;
  final page = 1.obs;

  // Key is category label, value is total amount
  final expenseTypes = <String, double>{}.obs;
  final categories = <Category>[].obs;

  final listExpenses = <DateTime, List<Expense>>{}.obs;

  @override
  void onInit() {
    refreshController = RefreshController(initialRefresh: true);
    super.onInit();
  }

  void onRefresh() async {
    page.value = 0;
    listExpenses.clear();
    await onGetMonthlySummary();
    await onGetTotalOutcomeDay();
    await _loadCategories();
    await onGetListExpenses();
    await onGetAllExpenseTypes();
    refreshController.refreshCompleted();
    refreshController.resetNoData();
  }

  onLoad() async {
    page.value += 1;
    await onGetListExpenses();
    refreshController.loadComplete();
  }

  Future<void> _loadCategories() async {
    final fetched = await _expenseRepository.getCategories();
    categories.assignAll(fetched);
  }

  onGetAllExpenseTypes() async {
    final expensesByType = await _expenseRepository.getExpensesByType(transactionType: 'expense');
    expenseTypes.assignAll(expensesByType);
  }

  onGetTotalOutcomeDay() async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);

    totalOutcomeDay.value = await _expenseRepository.getTotalAmount(start, end, 'expense');
  }

  onGetMonthlySummary() async {
    final now = DateTime.now();
    totalOutcomeMonth.value = await _expenseRepository.getMonthlyTotal(now, 'expense');
    totalIncomeMonth.value = await _expenseRepository.getMonthlyTotal(now, 'income');
    
    final allIncome = await _expenseRepository.getTotalAmount(DateTime(2000), DateTime(2100), 'income');
    final allExpense = await _expenseRepository.getTotalAmount(DateTime(2000), DateTime(2100), 'expense');
    totalBalance.value = allIncome - allExpense;
  }

  onGetListExpenses() async {
    final expenses = await _expenseRepository.getExpenses(offset: page.value);
    for (var expense in expenses) {
      final date = DateTime(expense.dateTime.year, expense.dateTime.month, expense.dateTime.day);
      if (listExpenses.containsKey(date)) {
        if (!listExpenses[date]!.any((e) => e.id == expense.id)) {
          listExpenses[date]!.add(expense);
        }
      } else {
        listExpenses[date] = [expense];
      }
    }
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }
}
