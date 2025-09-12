import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_expense/app/data/models/expense.dart';
import 'package:money_expense/app/data/models/expense_type.dart';
import 'package:money_expense/app/data/repositories/expense_repository.dart';
import 'package:money_expense/app/ults/string_currency_parsing.dart';

class ExpanseCreateController extends GetxController {
  // Form key for validation
  final formKey = GlobalKey<FormState>();

  // Text editing controllers
  late TextEditingController nameController;
  late TextEditingController typeController;
  late TextEditingController dateController;
  late TextEditingController priceController;

  // Selected date
  final selectedDate = DateTime.now().obs;

  // expense type
  final expenseType = ExpenseType.FOOD.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize controllers
    nameController = TextEditingController();
    typeController = TextEditingController(text: ExpenseType.FOOD.label);
    dateController = TextEditingController();
    priceController = TextEditingController();
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
    if (formKey.currentState!.validate()) {
      try {
        final expense = Expense.create(
          name: nameController.text.trim(),
          type: expenseType.value,
          dateTime: selectedDate.value,
          price: priceController.text.toDoubleFromRupiah(),
        );

        // Save to database
        final repository = ExpenseRepository();
        repository.insertExpense(expense);

        log('Saving expense: ${expense.toDbMap()}');
        // Navigate back
        Get.back(result: true);
        // Show success message
        Get.snackbar(
          'Berhasil',
          'Data pengeluaran berhasil disimpan',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Clear form
        nameController.clear();
        priceController.clear();
        dateController.clear();
      } catch (e) {
        log('Error saving expense: $e');
        Get.snackbar('Error', 'Gagal menyimpan data: $e', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      }
    }
  }
}
