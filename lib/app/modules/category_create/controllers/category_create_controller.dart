import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_expense/app/data/models/category_model.dart';
import 'package:money_expense/app/data/models/expense_type.dart';
import 'package:money_expense/app/data/repositories/expense_repository.dart';
import 'package:money_expense/app/modules/main_nav/controllers/main_nav_controller.dart';
import 'package:money_expense/app/ui/ui.dart';
import 'package:money_expense/app/widgets/app_snackbar.dart';

class CategoryCreateController extends GetxController {
  final labelController = TextEditingController();

  static const maxLabelLength = 24;

  /// 9 warna sama persis dengan kategori bawaan (disimpan di SQLite).
  static final availableColors = [for (final t in ExpenseType.values) t.color];
  static const availableIcons = CategoryIcons.all;

  late final Rx<Color> selectedColor;
  late final RxString selectedIcon;

  final isLoading = false.obs;
  final labelError = RxnString();
  final label = ''.obs;
  final ExpenseRepository _repository = Get.find<ExpenseRepository>();

  Category? editingCategory;
  bool get isEditing => editingCategory != null;

  @override
  void onInit() {
    super.onInit();
    final arg = Get.arguments;
    if (arg is Category) {
      editingCategory = arg;
      labelController.text = arg.label;
      selectedColor = arg.color.obs;
      selectedIcon = arg.icon.obs;
    } else {
      selectedColor = availableColors.first.obs;
      selectedIcon = availableIcons.first.obs;
    }
    label.value = labelController.text;
    labelController.addListener(_onLabelChanged);
  }

  @override
  void onClose() {
    labelController.dispose();
    super.onClose();
  }

  void _onLabelChanged() {
    label.value = labelController.text;
    if (labelError.value != null && label.value.trim().isNotEmpty) labelError.value = null;
  }

  void selectColor(Color color) => selectedColor.value = color;

  void selectIcon(String icon) => selectedIcon.value = icon;

  Future<void> saveCategory() async {
    final name = labelController.text.trim();
    if (name.isEmpty) {
      labelError.value = 'Beri nama kategorinya dulu';
      return;
    }

    try {
      isLoading.value = true;

      if (isEditing) {
        final updatedCategory = editingCategory!.copyWith(label: name, color: selectedColor.value, icon: selectedIcon.value);
        await _repository.updateCategory(updatedCategory);
        MainNavController.refreshAll();
        Get.back(result: true);
        showAppSnackBar('Kategori diperbarui');
      } else {
        final newCategory = Category.create(label: name, color: selectedColor.value, icon: selectedIcon.value);
        await _repository.insertCategory(newCategory);
        // Kembalikan kategori baru agar form transaksi bisa langsung memilihnya.
        Get.back(result: newCategory);
        showAppSnackBar('Kategori "$name" siap dipakai');
      }
    } catch (e) {
      showAppSnackBar('Gagal menyimpan kategori. Coba lagi, ya.');
    } finally {
      isLoading.value = false;
    }
  }

  /// Jumlah transaksi yang masih memakai kategori ini (0 = boleh dihapus).
  Future<int> usageCount() async => isEditing ? _repository.countExpensesByCategory(editingCategory!.id) : 0;

  Future<void> deleteCategory() async {
    if (!isEditing) return;

    try {
      isLoading.value = true;
      // Guard tetap di sini (bukan hanya di view) agar transaksi tidak jadi yatim.
      final used = await usageCount();
      if (used > 0) {
        showAppSnackBar('Kategori ini masih dipakai $used transaksi. Pindahkan dulu transaksinya, ya.');
        return;
      }
      await _repository.deleteCategory(editingCategory!.id);
      MainNavController.refreshAll();
      Get.back(result: true);
      showAppSnackBar('Kategori dihapus');
    } catch (e) {
      showAppSnackBar('Gagal menghapus kategori. Coba lagi, ya.');
    } finally {
      isLoading.value = false;
    }
  }
}
