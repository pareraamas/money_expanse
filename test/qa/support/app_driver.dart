import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'harness.dart';

/// Semua pengetahuan "cara memakai UI" untuk uji paritas ada di sini.
/// Saat layar ditulis ulang, cukup file ini yang diperbarui; ekspektasi data
/// di data_parity_test.dart tetap.
///
/// Setiap langkah mendukung UI lama (field teks) dan UI redesign (keypad).
class AppDriver {
  AppDriver(this.tester);
  final WidgetTester tester;

  Finder _field(String label) => find.widgetWithText(TextField, label);
  bool _has(Finder f) => f.evaluate().isNotEmpty;

  /// Keypad redesign: tombol digit berupa teks '0'–'9' dan '000'.
  bool get _hasKeypad => _has(find.text('000'));

  Future<void> enterAmount(int amount, {String fieldLabel = 'Nominal'}) async {
    if (_hasKeypad) {
      // Kosongkan dulu (mode ubah sudah berisi nominal).
      final backspace = find.byTooltip(RegExp('^Hapus digit'));
      for (var i = 0; i < 16 && _has(backspace); i++) {
        await tester.tap(backspace.first);
        await tester.pump();
      }
      for (final ch in amount.toString().split('')) {
        await tester.tap(find.text(ch).last);
        await tester.pump();
      }
      await settle(tester);
      return;
    }
    final field = _has(_field(fieldLabel)) ? _field(fieldLabel) : find.byType(TextField).first;
    await tester.enterText(field.first, amount.toString());
    await settle(tester);
  }

  Future<void> enterNote(String text) async {
    final field = firstOf([_field('Catatan'), _field('Keterangan')], what: 'field catatan/keterangan');
    await tester.enterText(field, text);
    await settle(tester);
  }

  Future<void> chooseType(String type) => tapAny(
        tester,
        type == 'income' ? [find.text('Masuk'), find.text('Pemasukan')] : [find.text('Keluar'), find.text('Pengeluaran')],
        what: 'toggle tipe $type',
      );

  Future<void> chooseCategory(String label) async {
    await tapAny(tester, categorySheetTriggers(), what: 'pemicu sheet kategori');
    // Item teratas = yang ada di sheet.
    await tester.tap(find.text(label).last);
    await settle(tester);
  }

  /// UI lama: tanggal kosong dan wajib dipilih. Redesign: default hari ini.
  Future<void> ensureDate() async {
    final field = _field('Tanggal');
    if (!_has(field)) return;
    final controller = tester.widget<TextField>(field.first).controller;
    if (controller != null && controller.text.isNotEmpty) return;
    await tapAny(tester, [field], what: 'field tanggal');
    await tapAny(tester, [find.text('OKE'), find.text('Oke'), find.text('OK')], what: 'tombol OK date picker');
  }

  // "Simpan", "Simpan Kategori", "Simpan anggaran", ...
  Future<void> save() => tapAny(tester, [find.text('Simpan'), find.textContaining(RegExp(r'^Simpan\b'))], what: 'tombol Simpan');

  Future<void> deleteAndConfirm() async {
    await tapAny(tester, [find.byTooltip(deleteTooltip), find.byIcon(Icons.delete), find.byIcon(Icons.delete_outline)], what: 'tombol hapus');
    // Tombol konfirmasi di dialog (paling atas).
    await tester.tap(find.text('Hapus').last);
    await settle(tester);
  }

  Future<void> openTab(String label) => tapNavTab(tester, label);

  Future<void> tapText(String text) => tapAny(tester, [find.text(text)], what: text);
}
