import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:money_expense/app/data/repositories/expense_repository.dart';
import 'package:money_expense/app/data/services/share_service.dart';
import 'package:money_expense/app/ui/ui.dart';
import 'package:money_expense/app/ults/clock.dart';
import 'package:money_expense/app/widgets/app_snackbar.dart';

/// Pratinjau & ekspor kartu ringkasan bulanan sebagai PNG.
///
/// Argumen route: bulan (`DateTime`) yang diringkas; default bulan ini.
class ShareCardController extends GetxController {
  final ExpenseRepository _repository = Get.find<ExpenseRepository>();

  /// Kartu memuat maksimal 3 kategori terbesar + "Lainnya".
  static const maxRows = 3;

  late final DateTime month;
  final income = 0.0.obs;
  final expense = 0.0.obs;
  final slices = <ShareCardSlice>[].obs;
  final format = ShareCardFormat.story.obs;
  final hideAmounts = false.obs;
  final isLoading = true.obs;
  final isSharing = false.obs;

  /// Dipasang di `RepaintBoundary` yang membungkus kartu pratinjau.
  final cardKey = GlobalKey();

  @override
  void onInit() {
    super.onInit();
    final arg = Get.arguments;
    final base = arg is DateTime ? arg : Clock.now();
    month = DateTime(base.year, base.month);
    loadData();
  }

  Future<void> loadData() async {
    final categories = await _repository.getCategories();
    final spending = await _repository.getCategorySpendingForMonth(month);
    income.value = await _repository.getMonthlyTotal(month, 'income');
    expense.value = await _repository.getMonthlyTotal(month, 'expense');

    final ranked = categories.where((c) => (spending[c.id] ?? 0) > 0).toList()..sort((a, b) => spending[b.id]!.compareTo(spending[a.id]!));
    final rows = [for (final c in ranked.take(maxRows)) ShareCardSlice(label: c.label, amount: spending[c.id]!, color: c.color)];
    if (ranked.length > maxRows) {
      rows.add(ShareCardSlice(label: 'Lainnya', amount: ranked.skip(maxRows).fold(0.0, (sum, c) => sum + spending[c.id]!)));
    }
    slices.assignAll(rows);
    isLoading.value = false;
  }

  /// Tangkap kartu pratinjau jadi PNG 1080 px lalu buka share sheet.
  Future<void> share({Rect? origin}) async {
    if (isSharing.value) return;
    isSharing.value = true;
    try {
      final boundary = cardKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;
      // Ukuran boundary = ukuran logis kartu, tidak terpengaruh skala FittedBox pratinjau.
      final image = await boundary.toImage(pixelRatio: format.value.pixelRatio);
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      image.dispose();
      if (data == null) throw StateError('PNG kosong');

      final stamp = '${month.year}-${month.month.toString().padLeft(2, '0')}';
      await Get.find<ShareService>().shareImage(data.buffer.asUint8List(), 'ringkasan-$stamp-${format.value.name}.png', origin: origin);
    } catch (_) {
      showAppSnackBar('Gagal membuat gambar. Coba lagi.');
    } finally {
      isSharing.value = false;
    }
  }
}
