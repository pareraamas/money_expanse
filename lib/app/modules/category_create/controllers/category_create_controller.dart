import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_expense/app/data/models/category_model.dart';
import 'package:money_expense/app/data/models/expense_type.dart';
import 'package:money_expense/app/data/repositories/expense_repository.dart';

class CategoryCreateController extends GetxController {
  final labelController = TextEditingController();

  final availableColors = ExpenseType.values.map((e) => e.color).toList().obs;
  final availableIcons = ExpenseType.values.map((e) => e.icon).toList().obs;

  late final Rx<Color> selectedColor;
  late final RxString selectedIcon;

  final isLoading = false.obs;
  final ExpenseRepository _repository = ExpenseRepository();

  @override
  void onInit() {
    super.onInit();
    selectedColor = availableColors.first.obs;
    selectedIcon = availableIcons.first.obs;
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
      final newCategory = Category.create(
        label: labelController.text.trim(),
        color: selectedColor.value,
        icon: selectedIcon.value,
      );

      await _repository.insertCategory(newCategory);

      Get.back(result: true);
      Get.snackbar(
        'Sukses',
        'Kategori berhasil ditambahkan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menambahkan kategori. Silakan coba lagi.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
