import 'package:wister_lite/app/data/models/budget_model.dart';
import 'package:wister_lite/app/data/models/category_model.dart';
import 'package:wister_lite/app/data/models/expense.dart';
import 'package:wister_lite/app/data/models/expense_type.dart';

import 'fake_repository.dart';

/// 9 kategori bawaan, persis seperti seed `DatabaseHelper._onCreate`.
List<Category> seedCategories() => [
      for (final t in ExpenseType.values)
        Category(id: t.toShortString().toLowerCase(), label: t.label, colorValue: t.color.toARGB32(), icon: t.icon),
    ];

Expense _tx(String id, String name, String cat, String type, DateTime at, double price) =>
    Expense(id: id, name: name, type: cat, transactionType: type, dateTime: at, price: price);

/// Data bulan acuan (September 2026) + satu bulan sebelumnya.
/// Tanggal sengaja <= 25 September agar label "Hari ini"/"Kemarin" di UI
/// tidak pernah muncul dan golden tetap stabil setelah hari acuan lewat.
List<Expense> sampleExpenses() => [
      _tx('tx-01', 'Gaji September', 'shopping', 'income', DateTime(2026, 9, 1, 9), 8000000),
      _tx('tx-02', 'Freelance logo', 'gift', 'income', DateTime(2026, 9, 12, 14), 1500000),
      _tx('tx-03', 'Belanja bulanan', 'shopping', 'expense', DateTime(2026, 9, 2, 10, 30), 1250000),
      _tx('tx-04', 'Paket internet', 'internet', 'expense', DateTime(2026, 9, 3, 8), 350000),
      _tx('tx-05', 'Makan siang', 'food', 'expense', DateTime(2026, 9, 25, 12, 15), 45000),
      _tx('tx-06', 'Kopi', 'food', 'expense', DateTime(2026, 9, 25, 16), 28000),
      _tx('tx-07', 'Ojek ke kantor', 'transportation', 'expense', DateTime(2026, 9, 24, 7, 45), 25000),
      _tx('tx-08', 'Bensin', 'transportation', 'expense', DateTime(2026, 9, 20, 18), 150000),
      _tx('tx-09', 'Nonton bioskop', 'entertainment', 'expense', DateTime(2026, 9, 19, 20), 100000),
      _tx('tx-10', 'Buku desain', 'education', 'expense', DateTime(2026, 9, 15, 11), 220000),
      _tx('tx-11', 'Kado ulang tahun', 'gift', 'expense', DateTime(2026, 9, 14, 17), 300000),
      _tx('tx-12', 'Futsal', 'sport', 'expense', DateTime(2026, 9, 10, 19), 75000),
      _tx('tx-13', 'Sapu & pel', 'home_appliances', 'expense', DateTime(2026, 9, 8, 9), 90000),
      _tx('tx-14', 'Makan malam', 'food', 'expense', DateTime(2026, 9, 5, 19, 30), 85000),
      _tx('tx-15', 'Gaji Agustus', 'shopping', 'income', DateTime(2026, 8, 1, 9), 8000000),
      _tx('tx-16', 'Sewa kos', 'home_appliances', 'expense', DateTime(2026, 8, 3, 10), 1800000),
    ];

/// Budget September: satu aman, satu hampir habis (>80%), satu over.
List<Budget> sampleBudgets() => [
      Budget(id: 'b-food', categoryId: 'food', yearMonth: '2026-09', amount: 1000000),
      Budget(id: 'b-trans', categoryId: 'transportation', yearMonth: '2026-09', amount: 200000),
      Budget(id: 'b-shop', categoryId: 'shopping', yearMonth: '2026-09', amount: 1000000),
      Budget(id: 'b-ent', categoryId: 'entertainment', yearMonth: '2026-08', amount: 300000),
    ];

/// Set data yang dipakai layar.
enum DataSet {
  /// Kategori bawaan + transaksi + budget.
  full,

  /// Kategori bawaan saja: empty state Beranda, Anggaran, Statistik.
  noTransactions,

  /// Tanpa kategori sama sekali: empty state Kelola Kategori.
  empty,
}

FakeExpenseRepository repositoryFor(DataSet set) => switch (set) {
      DataSet.full => FakeExpenseRepository(categories: seedCategories(), expenses: sampleExpenses(), budgets: sampleBudgets()),
      DataSet.noTransactions => FakeExpenseRepository(categories: seedCategories()),
      DataSet.empty => FakeExpenseRepository(),
    };
