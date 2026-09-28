import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:money_expense/app/modules/budget/controllers/budget_controller.dart';
import 'package:money_expense/app/modules/home/controllers/home_controller.dart';
import 'package:money_expense/app/modules/statistik/controllers/statistik_controller.dart';
import 'package:money_expense/app/routes/app_pages.dart';

class MainNavController extends GetxController {
  final selectedIndex = 0.obs;

  /// FAB kanan bawah disembunyikan saat konten digulir ke bawah.
  final fabVisible = true.obs;

  void onUserScroll(ScrollDirection direction, {required bool atTop}) {
    // Notifikasi hanya datang saat arah berubah; posisi atas dicek saat berhenti.
    if (direction == ScrollDirection.forward || (direction == ScrollDirection.idle && atTop)) {
      fabVisible.value = true;
    } else if (direction == ScrollDirection.reverse) {
      fabVisible.value = false;
    }
  }

  void changeTab(int index) {
    if (index == selectedIndex.value) return;
    selectedIndex.value = index;
    fabVisible.value = true;
    // Tab Anggaran & Statistik dulu hanya load saat onInit, jadi angkanya basi.
    if (index == 1 && Get.isRegistered<BudgetController>()) Get.find<BudgetController>().loadData();
    if (index == 2 && Get.isRegistered<StatistikController>()) Get.find<StatistikController>().loadData();
  }

  /// FAB tambah: buka form tambah transaksi, lalu segarkan semua tab.
  Future<void> openCreateTransaction() async {
    final result = await Get.toNamed(Routes.EXPANSE_CREATE);
    if (result == true) refreshAll();
  }

  /// Dipanggil setelah transaksi/kategori/budget berubah dari layar mana pun.
  static void refreshAll() {
    if (Get.isRegistered<HomeController>()) Get.find<HomeController>().onRefresh();
    if (Get.isRegistered<BudgetController>()) Get.find<BudgetController>().loadData();
    if (Get.isRegistered<StatistikController>()) Get.find<StatistikController>().loadData();
  }
}
