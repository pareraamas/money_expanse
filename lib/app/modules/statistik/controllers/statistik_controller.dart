import 'package:get/get.dart';
import 'package:money_expense/app/ults/clock.dart';
import 'package:money_expense/app/data/models/category_model.dart';
import 'package:money_expense/app/data/repositories/expense_repository.dart';

class StatistikController extends GetxController {
  final ExpenseRepository _repository = Get.find<ExpenseRepository>();

  final selectedMonth = DateTime(Clock.now().year, Clock.now().month).obs;
  final categories = <Category>[].obs;
  final spendingByCategory = <String, double>{}.obs;
  final totalIncome = 0.0.obs;
  final totalExpense = 0.0.obs;
  final isLoading = true.obs;

  double get balance => totalIncome.value - totalExpense.value;

  List<Category> get categoriesWithSpending {
    final result = categories.where((c) => (spendingByCategory[c.id] ?? 0) > 0).toList();
    result.sort((a, b) => (spendingByCategory[b.id] ?? 0).compareTo(spendingByCategory[a.id] ?? 0));
    return result;
  }

  /// Irisan donut: maksimal 6 kategori terbesar + "Lainnya".
  static const maxSlices = 6;

  List<DonutSlice> get donutSlices {
    final sorted = categoriesWithSpending;
    final slices = [
      for (final c in sorted.take(maxSlices)) DonutSlice(category: c, amount: spendingByCategory[c.id] ?? 0),
    ];
    if (sorted.length > maxSlices) {
      final rest = sorted.skip(maxSlices).fold(0.0, (sum, c) => sum + (spendingByCategory[c.id] ?? 0));
      slices.add(DonutSlice(category: null, amount: rest));
    }
    return slices;
  }

  /// Persentase [amount] terhadap total pengeluaran bulan ini (0–1).
  double shareOf(double amount) => totalExpense.value <= 0 ? 0 : (amount / totalExpense.value).clamp(0.0, 1.0);

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  /// Skeleton hanya saat load pertama; refresh berikutnya diam-diam.
  Future<void> loadData() async {
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

/// Satu irisan donut. [category] null = gabungan "Lainnya".
class DonutSlice {
  const DonutSlice({required this.category, required this.amount});

  final Category? category;
  final double amount;

  bool get isOther => category == null;
  String get label => category?.label ?? 'Lainnya';
}
