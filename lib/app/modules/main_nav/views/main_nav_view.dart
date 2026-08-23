import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_expense/app/modules/budget/views/budget_view.dart';
import 'package:money_expense/app/modules/home/views/home_view.dart';
import 'package:money_expense/app/modules/statistik/views/statistik_view.dart';
import 'package:money_expense/app/theme/app_color.dart';

import '../controllers/main_nav_controller.dart';

class MainNavView extends GetView<MainNavController> {
  const MainNavView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: controller.selectedIndex.value,
          children: const [
            HomeView(),
            BudgetView(),
            StatistikView(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeTab,
          selectedItemColor: AppColor.primary,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.pie_chart_outline), activeIcon: Icon(Icons.pie_chart), label: 'Anggaran'),
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), activeIcon: Icon(Icons.bar_chart), label: 'Statistik'),
          ],
        ),
      ),
    );
  }
}
