import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:money_expense/app/modules/home/widgets/main_card.dart';
import 'package:money_expense/app/modules/home/widgets/main_tile.dart';
import 'package:money_expense/app/modules/home/widgets/secondary_card.dart';
import 'package:money_expense/app/routes/app_pages.dart';
import 'package:money_expense/app/theme/app_color.dart';
import 'package:money_expense/app/ults/string_currency_parsing.dart';
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
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: SmartRefresher(
          controller: controller.refreshController,
          onRefresh: () => controller.onRefresh(),
          onLoading: () => controller.onLoad(),
          enablePullUp: true,
          enablePullDown: true,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              const SizedBox(height: 12),
              //Halo, User!
              Text(
                "Halo, User!",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold, fontSize: 18, color: AppColor.gray1),
              ),
              //Jangan lupa catat keuanganmu setiap hari!
              Text("Jangan lupa catat keuanganmu setiap hari!",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColor.gray3, fontSize: 14)),
              const SizedBox(height: 20),

              // Total Balance Card
              Obx(
                () => Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColor.primary,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.primary.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Saldo Saat Ini",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white.withOpacity(0.9)),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        controller.totalBalance.value.toRupiahString(),
                        style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Obx(
                () => Row(
                  mainAxisSize: MainAxisSize.max,
                  spacing: 12,
                  children: [
                    MainCard(
                      title: "Pemasukan\nBulan ini",
                      amount: controller.totalIncomeMonth.value,
                      color: AppColor.teal,
                    ),
                    MainCard(
                      title: "Pengeluaran\nBulan ini",
                      amount: controller.totalOutcomeMonth.value,
                      color: Colors.redAccent,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              // Pengeluaran berdasarkan kategori
              Text("Pengeluaran berdasarkan kategori",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold, fontSize: 14)),

              const SizedBox(height: 12),
              Obx(
                () => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: controller.expenseTypes.entries.map((entry) {
                      final category = controller.categories.firstWhereOrNull((c) => c.label == entry.key);
                      return SecondaryCard(
                        label: entry.key,
                        amount: entry.value,
                        icon: category?.icon ?? "assets/svg/shopping-bag.svg",
                        color: category?.color ?? Colors.grey,
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text("Riwayat Transaksi",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 12),
              Obx(
                () => controller.listExpenses.isNotEmpty
                    ? Column(
                        children: controller.listExpenses.entries
                            .map((entry) => MainTile(
                                  date: entry.key,
                                  expenses: entry.value,
                                  onUpdate: () => controller.onRefresh(),
                                ))
                            .toList(),
                      )
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Text("Belum ada transaksi",
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColor.gray3, fontSize: 14)),
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
