import 'package:csv/csv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wister_lite/app/data/models/category_model.dart';
import 'package:wister_lite/app/data/models/expense.dart';
import 'package:wister_lite/app/data/services/transaction_csv.dart';

void main() {
  final food = Category(id: 'food', label: 'Makanan', colorValue: 0xfff2c94c, icon: 'assets/uil_pizza-slice.svg');

  Expense tx(String id, String name, String type, DateTime at, double price) =>
      Expense(id: id, name: name, type: 'food', category: food, transactionType: type, dateTime: at, price: price);

  test('header, BOM, pemisah ; dan nilai mentah', () {
    final out = TransactionCsv.encode([
      tx('tx-1', 'Nasi padang', 'expense', DateTime(2026, 9, 5, 7, 3), 25000),
      tx('tx-2', 'Gaji', 'income', DateTime(2026, 9, 1), 8000000.5),
    ]);

    expect(out.startsWith('﻿'), isTrue, reason: 'BOM agar Excel membaca UTF-8');
    final lines = out.substring(1).split('\r\n');
    expect(lines[0], 'Tanggal;Jenis;Kategori;Nama;Jumlah;ID');
    expect(lines[1], '2026-09-05 07:03;Pengeluaran;Makanan;Nasi padang;25000;tx-1');
    expect(lines[2], '2026-09-01 00:00;Pemasukan;Makanan;Gaji;8000000.5;tx-2');
  });

  test('nama berisi ; " atau baris baru tetap utuh saat dibaca ulang', () {
    const tricky = 'Kopi; "susu"\nlarge';
    final out = TransactionCsv.encode([tx('tx-1', tricky, 'expense', DateTime(2026, 9, 5), 1)]);
    final rows = Csv(fieldDelimiter: ';', autoDetect: false).decode(out.substring(1));
    expect(rows[1][3], tricky);
  });
}
