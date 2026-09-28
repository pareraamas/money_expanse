import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:money_expense/app/routes/app_pages.dart';
import 'package:money_expense/app/ui/gallery/component_gallery_page.dart';

import 'fixtures.dart';
import 'harness.dart';

Future<void> _tab(WidgetTester t, String label) => tapNavTab(t, label);

Future<void> _openCategorySheet(WidgetTester t) async {
  await tapAny(t, categorySheetTriggers(), what: 'pemicu sheet kategori');
}

Future<void> _openBudgetSheet(WidgetTester t) async {
  await _tab(t, 'Anggaran');
  await tapAny(t, [find.text('Makanan')], what: 'kategori Makanan di Anggaran');
}

Future<void> _openDelete(WidgetTester t) => tapAny(t, [
      find.byTooltip(deleteTooltip),
      find.byIcon(Icons.delete),
      find.byIcon(Icons.delete_outline),
    ], what: 'tombol hapus');

/// Semua layar & keadaan penting di rencana redesign (7 layar + sheet,
/// dialog, dan 4 empty state). Satu daftar dipakai golden, a11y, dan teks 200%.
final qaScreens = <QaScreen>[
  const QaScreen('beranda', route: Routes.MAIN_NAV),
  const QaScreen('beranda-kosong', route: Routes.MAIN_NAV, data: DataSet.noTransactions),
  const QaScreen('anggaran', route: Routes.MAIN_NAV, open: _anggaran),
  const QaScreen('anggaran-kosong', route: Routes.MAIN_NAV, data: DataSet.noTransactions, open: _anggaran),
  const QaScreen('sheet-atur-budget', route: Routes.MAIN_NAV, open: _openBudgetSheet),
  const QaScreen('statistik', route: Routes.MAIN_NAV, open: _statistik),
  const QaScreen('statistik-kosong', route: Routes.MAIN_NAV, data: DataSet.noTransactions, open: _statistik),
  // Tanggal default = hari ini (jam nyata), jadi tidak di-golden.
  const QaScreen('transaksi-tambah', route: Routes.EXPANSE_CREATE, golden: false),
  const QaScreen('transaksi-ubah', route: Routes.EXPANSE_CREATE, arguments: 'tx-05'),
  const QaScreen('sheet-kategori', route: Routes.EXPANSE_CREATE, arguments: 'tx-05', open: _openCategorySheet),
  const QaScreen('dialog-hapus-transaksi', route: Routes.EXPANSE_CREATE, arguments: 'tx-05', open: _openDelete),
  const QaScreen('kategori-kelola', route: Routes.CATEGORY_LIST),
  const QaScreen('kategori-kelola-kosong', route: Routes.CATEGORY_LIST, data: DataSet.empty),
  const QaScreen('kategori-buat', route: Routes.CATEGORY_CREATE),
  QaScreen('kategori-ubah', route: Routes.CATEGORY_CREATE, arguments: seedCategories().first),
  QaScreen('dialog-hapus-kategori', route: Routes.CATEGORY_CREATE, arguments: seedCategories().first, open: _openDelete),
  const QaScreen('sheet-export', route: Routes.MAIN_NAV, open: _openExportSheet),
  QaScreen('bagikan-gambar', route: Routes.SHARE_CARD, arguments: DateTime(2026, 9)),
  QaScreen('bagikan-gambar-feed', route: Routes.SHARE_CARD, arguments: DateTime(2026, 9), open: _feedHidden),
  // Fase 1: semua komponen inti sekaligus.
  QaScreen('galeri-komponen', page: () => const ComponentGalleryPage()),
];

Future<void> _anggaran(WidgetTester t) => _tab(t, 'Anggaran');
Future<void> _statistik(WidgetTester t) => _tab(t, 'Statistik');

Future<void> _openExportSheet(WidgetTester t) async {
  await _tab(t, 'Statistik');
  await tapAny(t, [find.text('Export & bagikan')], what: 'tombol Export & bagikan');
}

/// Format Feed + nominal disembunyikan.
Future<void> _feedHidden(WidgetTester t) async {
  await tapAny(t, [find.text('Feed')], what: 'segmen Feed');
  await tapAny(t, [find.text('Sembunyikan nominal')], what: 'toggle Sembunyikan nominal');
}

/// Nama tampilan ringkas untuk pesan kegagalan.
String describe(QaScreen s, Brightness b) => '${s.name} (${b.name})';
