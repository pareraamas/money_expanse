import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_expense/app/data/models/expense.dart';
import 'package:money_expense/app/data/models/category_model.dart';
import 'package:money_expense/app/data/repositories/expense_repository.dart';
import 'package:money_expense/app/ults/string_currency_parsing.dart';

class ExpanseCreateController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final ExpenseRepository repository = Get.find<ExpenseRepository>();

  // Text editing controllers
  late TextEditingController nameController;
  late TextEditingController typeController;
  late TextEditingController dateController;
  late TextEditingController priceController;

  // Selected date
  final selectedDate = DateTime.now().obs;

  // Selected category
  final selectedCategory = Rxn<Category>();
  
  // Available categories
  final categories = <Category>[].obs;

  // transaction type
  final transactionType = 'expense'.obs; // 'income' or 'expense'

  // arg
  final arg = "".obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize controllers
    nameController = TextEditingController();
    typeController = TextEditingController();
    dateController = TextEditingController();
    priceController = TextEditingController();
    
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final fetchedCategories = await repository.getCategories();
    categories.assignAll(fetchedCategories);
    if (categories.isNotEmpty && selectedCategory.value == null) {
      selectedCategory.value = categories.first;
      typeController.text = categories.first.label;
    }
  }

  @override
  void onClose() {
    // Dispose controllers to prevent memory leaks
    nameController.dispose();
    typeController.dispose();
    dateController.dispose();
    priceController.dispose();
    super.onClose();
  }

  // Method to handle form submission
  void submitForm() {
    if (formKey.currentState!.validate() && selectedCategory.value != null) {
      try {
        final expense = Expense.create(
          name: nameController.text.trim(),
          categoryId: selectedCategory.value!.id,
          transactionType: transactionType.value,
          dateTime: selectedDate.value,
          price: priceController.text.toDoubleFromRupiah(),
        );

        repository.insertExpense(expense);

        log('Saving expense: ${expense.toDbMap()}');
        Get.back(result: true);
        Get.snackbar(
          'Berhasil',
          'Data transaksi berhasil disimpan',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } catch (e) {
        log('Error saving expense: $e');
        Get.snackbar('Error', 'Gagal menyimpan data: $e', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      }
    }
  }

  Future<bool> deleteExpanse() async {
    try {
      await repository.deleteExpense(arg.value);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> onUpdateSubmit() async {
    if (formKey.currentState!.validate() && arg.value.isNotEmpty && selectedCategory.value != null) {
      try {
        final price = priceController.text.toDoubleFromRupiah();

        final updatedExpense = Expense(
          id: arg.value,
          name: nameController.text.trim(),
          type: selectedCategory.value!.id,
          transactionType: transactionType.value,
          dateTime: selectedDate.value,
          price: price,
        );

        await repository.updateExpense(updatedExpense);

        log('Updating expense: ${updatedExpense.toDbMap()}');
        Get.back(result: true);
        Get.snackbar(
          'Berhasil',
          'Data transaksi berhasil diperbarui',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } catch (e) {
        log('Error updating expense: $e');
        Get.snackbar('Error', 'Gagal memperbarui data: $e', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      }
    }
  }

  Future<void> onGetByid(String id) async {
    try {
      final expense = await repository.getExpense(id);
      if (expense != null) {
        nameController.text = expense.name;
        priceController.text = expense.price.toRupiahString();
        
        // Wait for categories to load if not already
        if (categories.isEmpty) await _loadCategories();
        
        final cat = categories.firstWhereOrNull((c) => c.id == expense.type);
        if (cat != null) {
          selectedCategory.value = cat;
          typeController.text = cat.label;
        }
        
        dateController.text = DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(expense.dateTime);
        selectedDate.value = expense.dateTime;
        transactionType.value = expense.transactionType;
      } else {
        Get.back();
        Get.snackbar('Error', 'Data transaksi tidak ditemukan', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      log('Error loading expense: $e');
      Get.back();
      Get.snackbar('Error', 'Gagal memuat data transaksi: $e', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  void onReady() {
    final data = Get.arguments as String?;
    if (data != null) {
      arg.value = data;
      onGetByid(data);
    }
    super.onReady();
  }
}
