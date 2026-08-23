import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_expense/app/data/models/category_model.dart';
import 'package:money_expense/app/data/repositories/expense_repository.dart';
import 'package:money_expense/gen/assets.gen.dart';

class CategoryCreateController extends GetxController {
  final labelController = TextEditingController();

  static const availableColors = <Color>[
    Color(0xfff2c94c),
    Color(0xff56CCF2),
    Color(0xffF2994A),
    Color(0xffEB5757),
    Color(0xff9B51E0),
    Color(0xff27AE60),
    Color(0xffBB6BD9),
    Color(0xff2D9CDB),
    Color(0xff2F80ED),
  ];

  static const availableIcons = <String>[
    Assets.uilPizzaSlice,
    Assets.uilRssAlt,
    Assets.uilBookOpen,
    Assets.uilGift,
    Assets.uilCarSideview,
    Assets.uilShoppingCart,
    Assets.uilHome,
    Assets.uilBasketball,
    Assets.uilClapperBoard,
  ];

  late final Rx<Color> selectedColor;
  late final RxString selectedIcon;

  final isLoading = false.obs;
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
  }

  @override
  void onClose() {
    labelController.dispose();
    super.onClose();
  }

  void selectColor(Color color) {
    selectedColor.value = color;
  }

  void selectIcon(String icon) {
    selectedIcon.value = icon;
    update();
  }

  Future<void> saveCategory() async {
    if (labelController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Nama Kategori tidak boleh kosong',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      if (isEditing) {
        final updatedCategory = editingCategory!.copyWith(
          label: labelController.text.trim(),
          color: selectedColor.value,
          icon: selectedIcon.value,
        );
        await _repository.updateCategory(updatedCategory);
      } else {
        final newCategory = Category.create(
          label: labelController.text.trim(),
          color: selectedColor.value,
          icon: selectedIcon.value,
        );
        await _repository.insertCategory(newCategory);
      }

      Get.back(result: true);
      Get.snackbar(
        'Sukses',
        isEditing ? 'Kategori berhasil diperbarui' : 'Kategori berhasil ditambahkan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menyimpan kategori. Silakan coba lagi.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteCategory() async {
    if (!isEditing) return;

    try {
      isLoading.value = true;
      final usageCount = await _repository.countExpensesByCategory(editingCategory!.id);
      if (usageCount > 0) {
        Get.snackbar(
          'Tidak Bisa Dihapus',
          'Kategori ini masih digunakan oleh $usageCount transaksi',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      await _repository.deleteCategory(editingCategory!.id);
      Get.back(result: true);
      Get.snackbar(
        'Sukses',
        'Kategori berhasil dihapus',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menghapus kategori. Silakan coba lagi.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
