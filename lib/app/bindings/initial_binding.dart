import 'package:get/get.dart';
import 'package:money_expense/app/data/repositories/expense_repository.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ExpenseRepository>(ExpenseRepository(), permanent: true);
  }
}
