import 'package:get/get.dart';
import 'package:money_expense/app/data/models/category_model.dart';
import 'package:money_expense/app/data/repositories/expense_repository.dart';

class BudgetController extends GetxController {
  final ExpenseRepository _repository = Get.find<ExpenseRepository>();

  final selectedMonth = DateTime(DateTime.now().year, DateTime.now().month).obs;
  final categories = <Category>[].obs;
  final budgetByCategory = <String, double>{}.obs;
  final spendingByCategory = <String, double>{}.obs;
  final isLoading = false.obs;

  double get totalBudget => budgetByCategory.values.fold(0.0, (a, b) => a + b);
  double get totalSpent => spendingByCategory.values.fold(0.0, (a, b) => a + b);

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;

    final fetchedCategories = await _repository.getCategories();
    final budgets = await _repository.getBudgetsForMonth(selectedMonth.value);
    final spending = await _repository.getCategorySpendingForMonth(selectedMonth.value);

    categories.assignAll(fetchedCategories);
    budgetByCategory
      ..clear()
      ..addEntries(budgets.map((b) => MapEntry(b.categoryId, b.amount)));
    spendingByCategory.assignAll(spending);

    isLoading.value = false;
  }

  void goToPreviousMonth() {
    final m = selectedMonth.value;
    selectedMonth.value = DateTime(m.year, m.month - 1);
    loadData();
  }

  void goToNextMonth() {
    final m = selectedMonth.value;
    selectedMonth.value = DateTime(m.year, m.month + 1);
    loadData();
  }

  void setMonth(DateTime month) {
    selectedMonth.value = DateTime(month.year, month.month);
    loadData();
  }

  Future<void> setBudget(String categoryId, double amount) async {
    if (amount <= 0) {
      await _repository.deleteBudget(categoryId, selectedMonth.value);
      budgetByCategory.remove(categoryId);
    } else {
      await _repository.setBudget(categoryId, selectedMonth.value, amount);
      budgetByCategory[categoryId] = amount;
    }
  }
}
