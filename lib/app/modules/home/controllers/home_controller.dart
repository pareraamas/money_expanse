import 'package:get/get.dart';
import 'package:money_expense/app/ults/clock.dart';
import 'package:money_expense/app/data/models/expense.dart';
import 'package:money_expense/app/data/repositories/expense_repository.dart';
import 'package:money_expense/app/modules/main_nav/controllers/main_nav_controller.dart';
import 'package:money_expense/app/routes/app_pages.dart';
import 'package:money_expense/app/widgets/app_snackbar.dart';

class HomeController extends GetxController {
  final ExpenseRepository _expenseRepository = Get.find<ExpenseRepository>();

  /// Beranda hanya menampilkan transaksi terbaru; sisanya di Riwayat Transaksi.
  static const recentCount = 10;

  final totalOutcomeDay = 0.0.obs;
  final totalOutcomeMonth = 0.0.obs;
  final totalIncomeMonth = 0.0.obs;
  final totalBalance = 0.0.obs;

  /// Load pertama (untuk skeleton).
  final isLoading = true.obs;

  final listExpenses = <DateTime, List<Expense>>{}.obs;

  /// Bulan yang diringkas di kartu Masuk/Keluar.
  DateTime get currentMonth => DateTime(Clock.now().year, Clock.now().month);

  /// Sapaan sesuai jam (tanpa nama; aplikasi tidak menyimpan nama user).
  String get greeting {
    final h = Clock.now().hour;
    if (h < 11) return 'Selamat pagi!';
    if (h < 15) return 'Selamat siang!';
    if (h < 18) return 'Selamat sore!';
    return 'Selamat malam!';
  }

  Future<void> openCreate() async {
    if (Get.isRegistered<MainNavController>()) return Get.find<MainNavController>().openCreateTransaction();
    final result = await Get.toNamed(Routes.EXPANSE_CREATE);
    if (result == true) MainNavController.refreshAll();
  }

  /// Riwayat lengkap dengan filter ada di halaman sendiri.
  void openHistory() => Get.toNamed(Routes.TRANSACTION_HISTORY);

  Future<void> openEdit(Expense expense) async {
    final result = await Get.toNamed(Routes.EXPANSE_CREATE, arguments: expense.id);
    if (result == true) MainNavController.refreshAll();
  }

  /// Hapus dari geser di riwayat (sudah dikonfirmasi oleh [TransactionTile]).
  Future<void> deleteExpense(Expense expense) async {
    final date = DateTime(expense.dateTime.year, expense.dateTime.month, expense.dateTime.day);
    // Langsung hilang dari list agar Dismissible tidak dibangun ulang.
    final rest = [...?listExpenses[date]]..removeWhere((e) => e.id == expense.id);
    rest.isEmpty ? listExpenses.remove(date) : listExpenses[date] = rest;
    try {
      await _expenseRepository.deleteExpense(expense.id!);
      showAppSnackBar('Transaksi dihapus');
    } catch (_) {
      showAppSnackBar('Gagal menghapus transaksi. Coba lagi, ya.');
    }
    MainNavController.refreshAll();
  }

  @override
  void onInit() {
    super.onInit();
    onRefresh();
  }

  Future<void> onRefresh() async {
    await Future.wait([onGetMonthlySummary(), onGetTotalOutcomeDay()]);
    final expenses = await _expenseRepository.getExpenses(limit: recentCount);
    listExpenses.clear();
    _addToGroups(expenses);
    isLoading.value = false;
  }

  Future<void> onGetTotalOutcomeDay() async {
    final now = Clock.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);

    totalOutcomeDay.value = await _expenseRepository.getTotalAmount(start, end, 'expense');
  }

  Future<void> onGetMonthlySummary() async {
    final now = Clock.now();
    totalOutcomeMonth.value = await _expenseRepository.getMonthlyTotal(now, 'expense');
    totalIncomeMonth.value = await _expenseRepository.getMonthlyTotal(now, 'income');

    final allIncome = await _expenseRepository.getTotalAmount(DateTime(2000), DateTime(2100), 'income');
    final allExpense = await _expenseRepository.getTotalAmount(DateTime(2000), DateTime(2100), 'expense');
    totalBalance.value = allIncome - allExpense;
  }

  void _addToGroups(List<Expense> expenses) {
    for (final expense in expenses) {
      final date = DateTime(expense.dateTime.year, expense.dateTime.month, expense.dateTime.day);
      final group = listExpenses[date];
      if (group == null) {
        listExpenses[date] = [expense];
      } else if (!group.any((e) => e.id == expense.id)) {
        listExpenses[date] = [...group, expense];
      }
    }
  }
}
