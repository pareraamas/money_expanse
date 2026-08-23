import 'package:get/get.dart';
import 'package:money_expense/app/modules/budget/controllers/budget_controller.dart';
import 'package:money_expense/app/modules/home/controllers/home_controller.dart';
import 'package:money_expense/app/modules/statistik/controllers/statistik_controller.dart';

import '../controllers/main_nav_controller.dart';

class MainNavBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainNavController>(() => MainNavController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<BudgetController>(() => BudgetController());
    Get.lazyPut<StatistikController>(() => StatistikController());
  }
}
