import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_expense/app/data/models/expense.dart';
import 'package:money_expense/app/data/models/expense_type.dart';
import 'package:money_expense/app/data/repositories/expense_repository.dart';
import 'package:money_expense/app/ults/string_currency_parsing.dart';

class ExpanseCreateController extends GetxController {
  // Form key for validation
  final formKey = GlobalKey<FormState>();

  final repository = ExpenseRepository();

  // Text editing controllers
  late TextEditingController nameController;
  late TextEditingController typeController;
  late TextEditingController dateController;
  late TextEditingController priceController;

  // Selected date
  final selectedDate = DateTime.now().obs;

  // expense type
  final expenseType = ExpenseType.FOOD.obs;

  // arg
  final arg = "".obs;

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

  Future<bool> deleteExpanse() async {
    try {
      await repository.deleteExpense(arg.value);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> onUpdateSubmit() async {
    if (formKey.currentState!.validate() && arg.value.isNotEmpty) {
      try {
        // Parse price from formatted Rupiah string
        final price = priceController.text.toDoubleFromRupiah();

        // Create updated expense
        final updatedExpense = Expense(
          id: arg.value,
          name: nameController.text.trim(),
          type: expenseType.value.toShortString(),
          dateTime: selectedDate.value,
          price: price,
        );

        // Update in database
        await repository.updateExpense(updatedExpense);

        log('Updating expense: ${updatedExpense.toDbMap()}');

        // Navigate back
        Get.back(result: true);

        // Show success message
        Get.snackbar(
          'Berhasil',
          'Data pengeluaran berhasil diperbarui',
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
        // Populate form fields with existing expense data
        nameController.text = expense.name;
        priceController.text = expense.price.toRupiahString();
        typeController.text = expense.expenseType.label;
        dateController.text = DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(expense.dateTime);
        selectedDate.value = expense.dateTime;
        expenseType.value = expense.expenseType;
      } else {
        Get.back();
        Get.snackbar('Error', 'Data pengeluaran tidak ditemukan', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      log('Error loading expense: $e');
      Get.back();
      Get.snackbar('Error', 'Gagal memuat data pengeluaran: $e', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
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
