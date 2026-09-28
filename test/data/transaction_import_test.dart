import 'package:flutter_test/flutter_test.dart';
import 'package:wister_lite/app/data/models/category_model.dart';
import 'package:wister_lite/app/data/models/expense.dart';
import 'package:wister_lite/app/data/services/transaction_csv.dart';
import 'package:wister_lite/app/data/services/transaction_import.dart';
import 'package:wister_lite/app/data/services/transaction_pdf.dart';
import 'package:wister_lite/app/data/services/transaction_report.dart';
import 'package:wister_lite/app/data/services/transaction_xlsx.dart';

void main() {
  final food = Category(id: 'food', label: 'Makanan', colorValue: 0xfff2c94c, icon: 'assets/icon_category/uil_pizza-slice.svg');
  final salary = Category(id: 'salary', label: 'Gaji', colorValue: 0xff27ae60, icon: 'assets/icon_category/uil_money.svg');

  Expense tx(String id, String name, Category c, String type, DateTime at, double price) =>
      Expense(id: id, name: name, type: c.id, category: c, transactionType: type, dateTime: at, price: price);

  final sample = [
    tx('tx-1', 'Gaji September', salary, 'income', DateTime(2026, 9, 1, 9), 8000000),
    tx('tx-2', 'Nasi padang', food, 'expense', DateTime(2026, 9, 5, 12, 30), 25000),
    tx('tx-3', 'Kopi; "susu"', food, 'expense', DateTime(2026, 9, 6, 16), 18500.5),
  ];

  var counter = 0;
  TransactionImporter importer({List<Expense> existing = const []}) =>
      TransactionImporter(categories: [food, salary], existing: existing, newId: () => 'new-${++counter}');

  group('parseAmount', () {
    final cases = <Object, double?>{
      25000: 25000,
      '25000': 25000,
      '25.000': 25000,
      'Rp 25.000': 25000,
      'Rp25.000': 25000,
      '1.250.000': 1250000,
      '1.250.000,50': 1250000.5,
      '1,250,000.50': 1250000.5,
      '8000000.5': 8000000.5,
      '12,5': 12.5,
      '-25.000': -25000,
      '−Rp 25.000': -25000,
      '(25.000)': -25000,
      'abc': null,
      '': null,
    };
    cases.forEach((input, expected) {
      test('"$input" → $expected', () => expect(TransactionImporter.parseAmount(input), expected));
    });
  });

  group('parseDate', () {
    final cases = <Object, DateTime?>{
      '2026-09-28 14:30': DateTime(2026, 9, 28, 14, 30),
      '2026-09-28': DateTime(2026, 9, 28),
      '2026-09-28T14:30:15.000': DateTime(2026, 9, 28, 14, 30, 15),
      '28/09/2026': DateTime(2026, 9, 28),
      '28-09-2026 07.05': DateTime(2026, 9, 28, 7, 5),
      46293.5: DateTime(2026, 9, 28, 12), // serial Excel
      '2026-02-31': null,
      '13/13/2026': null,
      'kemarin': null,
    };
    cases.forEach((input, expected) {
      test('"$input" → $expected', () => expect(TransactionImporter.parseDate(input), expected));
    });
  });

  test('CSV export → import: nilai kembali utuh', () {
    final rows = TransactionCsv.decode(TransactionCsv.encode(sample));
    final plan = importer().parse(rows);

    expect(plan.issues, isEmpty);
    expect(plan.newCategories, isEmpty);
    expect(plan.expenses.map((e) => (e.id, e.name, e.type, e.transactionType, e.dateTime, e.price)), [
      for (final e in sample) (e.id, e.name, e.type, e.transactionType, e.dateTime, e.price),
    ]);
  });

  test('Excel export → import: nilai kembali utuh', () {
    final bytes = TransactionXlsx.encode(TransactionSummary.of(sample), ReportPeriod.month(DateTime(2026, 9)));
    final plan = importer().parse(TransactionXlsx.decode(bytes));

    expect(plan.issues, isEmpty);
    expect(plan.expenses.map((e) => (e.id, e.name, e.type, e.transactionType, e.dateTime, e.price)), [
      for (final e in sample) (e.id, e.name, e.type, e.transactionType, e.dateTime, e.price),
    ]);
  });

  test('import ulang file yang sama: semua dilewati sebagai duplikat', () {
    final rows = TransactionCsv.decode(TransactionCsv.encode(sample));
    final plan = importer(existing: sample).parse(rows);
    expect(plan.expenses, isEmpty);
    expect(plan.duplicates, 3);
  });

  test('file luar: baris judul, header Inggris, kategori baru, error per baris', () {
    final rows = <List<Object?>>[
      ['Mutasi rekening September'],
      [],
      ['Date', 'Description', 'Category', 'Amount', 'Type'],
      ['2026-09-10', 'Bensin', 'transport', '150.000', 'expense'],
      ['2026-09-11', 'Parkir', 'Transport', 'Rp 5.000', ''],
      ['2026-09-12', 'Makan', 'makanan', '30000', 'Keluar'],
      ['bukan tanggal', 'X', 'Makanan', '1', 'expense'],
      ['2026-09-13', 'Y', 'Makanan', 'nol', 'expense'],
      ['2026-09-14', 'Z', 'Makanan', '1000', 'transfer'],
      ['2026-09-15', 'W', '', '1000', 'expense'],
      ['2026-09-12', 'Makan', 'Makanan', '30.000', 'expense'], // duplikat di dalam file
    ];
    final plan = importer().parse(rows);

    expect(plan.expenses.map((e) => e.name), ['Bensin', 'Parkir', 'Makan']);
    expect(plan.newCategories.map((c) => c.label), ['transport'], reason: 'satu kategori baru walau beda huruf besar');
    expect(plan.expenses[0].type, plan.newCategories.single.id);
    expect(plan.expenses[1].transactionType, 'expense', reason: 'jenis kosong = pengeluaran');
    expect(plan.expenses[2].type, 'food', reason: 'label dicocokkan tanpa beda huruf besar');
    expect(plan.duplicates, 1);
    expect(plan.issues.map((i) => i.row), [7, 8, 9, 10]);
  });

  test('kolom wajib hilang', () {
    final plan = importer().parse([
      ['Nama', 'Harga'],
      ['Kopi', '1000'],
    ]);
    expect(plan.missingColumns, [ImportColumn.date, ImportColumn.category]);
    expect(plan.isEmpty, isTrue);
  });

  test('PDF: dokumen valid dengan font ter-embed', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final bytes = await TransactionPdf.build(TransactionSummary.of(sample), const ReportPeriod.allTime(), generatedAt: DateTime(2026, 9, 28));
    expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
    expect(bytes.length, greaterThan(10000), reason: 'font Plus Jakarta Sans ikut ter-embed');
  });
}
