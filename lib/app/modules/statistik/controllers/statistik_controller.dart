import 'package:get/get.dart';
import 'package:money_expense/app/data/models/category_model.dart';
import 'package:money_expense/app/data/repositories/expense_repository.dart';

class StatistikController extends GetxController {
  final ExpenseRepository _repository = Get.find<ExpenseRepository>();

  final selectedMonth = DateTime(DateTime.now().year, DateTime.now().month).obs;
  final categories = <Category>[].obs;
  final spendingByCategory = <String, double>{}.obs;
  final totalIncome = 0.0.obs;
  final totalExpense = 0.0.obs;
  final isLoading = false.obs;

  double get balance => totalIncome.value - totalExpense.value;

  List<Category> get categoriesWithSpending {
    final result = categories.where((c) => (spendingByCategory[c.id] ?? 0) > 0).toList();
    result.sort((a, b) => (spendingByCategory[b.id] ?? 0).compareTo(spendingByCategory[a.id] ?? 0));
    return result;
  }

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;

    final fetchedCategories = await _repository.getCategories();
    final spending = await _repository.getCategorySpendingForMonth(selectedMonth.value);
    final income = await _repository.getMonthlyTotal(selectedMonth.value, 'income');
    final expense = await _repository.getMonthlyTotal(selectedMonth.value, 'expense');

    categories.assignAll(fetchedCategories);
    spendingByCategory.assignAll(spending);
    totalIncome.value = income;
    totalExpense.value = expense;

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
}
