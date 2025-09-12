import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:money_expense/app/modules/home/widgets/main_card.dart';
import 'package:money_expense/app/modules/home/widgets/main_tile.dart';
import 'package:money_expense/app/modules/home/widgets/secondary_card.dart';
import 'package:money_expense/app/routes/app_pages.dart';
import 'package:money_expense/app/theme/app_color.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      floatingActionButton: FloatingActionButton(
        clipBehavior: Clip.antiAlias,
        backgroundColor: AppColor.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        onPressed: () {
          Get.toNamed(Routes.EXPANSE_CREATE)?.then((value) {
            if (value == true) {
              controller.onRefresh();
            }
          });
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: SmartRefresher(
          controller: controller.refreshController,
          onRefresh: () => controller.onRefresh(),
          onLoading: () => controller.onLoad(),
          enablePullUp: true,
          enablePullDown: true,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20),
            children: [
              SizedBox(height: 8),
              //Halo, User!
              Text(
                "Halo, User!",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold, fontSize: 18, color: AppColor.gray1),
              ),
              //Jangan lupa catat keuanganmu setiap hari!
              Text("Jangan lupa catat keuanganmu setiap hari!", style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColor.gray3, fontSize: 14)),
              SizedBox(height: 20),

              Obx(
                () => Row(
                  spacing: 20,
                  children: [
                    MainCard(title: "Pengeluaranmu\nHari ini", amount: controller.totalOutcomeDay.value, color: AppColor.blue),
                    MainCard(title: "Pengeluaranmu\nBulan ini", amount: controller.totalOutcomeMonth.value, color: AppColor.teal),
                  ],
                ),
              ),

              SizedBox(height: 12),
              // Pengeluaran berdasarkan kategori
              Text("Pengeluaran berdasarkan kategori", style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold, fontSize: 14)),

              SizedBox(height: 12),
              Obx(
                () => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: controller.expenseTypes.entries.map((entry) => SecondaryCard(type: entry.key, amount: entry.value)).toList(),
                  ),
                ),
              ),
              SizedBox(height: 12),
              Obx(
                () => controller.listExpenses.isNotEmpty
                    ? Column(
                        children: controller.listExpenses.entries.map((entry) => MainTile(date: entry.key, expenses: entry.value)).toList(),
                      )
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 100),
                          child: Text("Belum ada pengeluaran", style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColor.gray3, fontSize: 14)),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
