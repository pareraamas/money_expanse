import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:money_expense/app/data/models/category_model.dart';
import 'package:money_expense/app/routes/app_pages.dart';
import 'package:money_expense/app/theme/app_color.dart';
import 'package:money_expense/app/ults/curency_formatter.dart';
import 'package:money_expense/app/ults/string_currency_parsing.dart';
import 'package:money_expense/app/widgets/month_year_picker_sheet.dart';

import '../controllers/budget_controller.dart';

class BudgetView extends GetView<BudgetController> {
  const BudgetView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        title: const Text(
          'Anggaran',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.black),
            tooltip: 'Filter Bulan',
            onPressed: () async {
              final picked = await showMonthYearPickerSheet(context, controller.selectedMonth.value);
              if (picked != null) controller.setMonth(picked);
            },
          ),
          IconButton(
            icon: const Icon(Icons.category_outlined, color: Colors.black),
            tooltip: 'Kelola Kategori',
            onPressed: () async {
              await Get.toNamed(Routes.CATEGORY_LIST);
              controller.loadData();
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _SummaryCard(controller: controller)),
            if (controller.categories.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: Text('Belum ada kategori')),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index.isOdd) return const SizedBox(height: 12);
                      final category = controller.categories[index ~/ 2];
                      return _CategoryBudgetTile(category: category, controller: controller);
                    },
                    childCount: controller.categories.length * 2 - 1,
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final BudgetController controller;
  const _SummaryCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final totalBudget = controller.totalBudget;
      final totalSpent = controller.totalSpent;
      final progress = totalBudget <= 0 ? 0.0 : (totalSpent / totalBudget).clamp(0.0, 1.0);
      final isOverBudget = totalBudget > 0 && totalSpent > totalBudget;

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColor.primary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColor.primary.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Anggaran Bulan Ini',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.9)),
            ),
            const SizedBox(height: 8),
            Text(
              totalBudget.toRupiahString(),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: totalBudget <= 0 ? 0 : progress,
                minHeight: 6,
                backgroundColor: Colors.white.withValues(alpha: 0.3),
                color: isOverBudget ? Colors.redAccent : Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Terpakai ${totalSpent.toRupiahString()}',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 12),
            ),
          ],
        ),
      );
    });
  }
}

class _CategoryBudgetTile extends StatelessWidget {
  final Category category;
  final BudgetController controller;
  const _CategoryBudgetTile({required this.category, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final budget = controller.budgetByCategory[category.id] ?? 0.0;
      final spent = controller.spendingByCategory[category.id] ?? 0.0;
      final hasBudget = budget > 0;
      final progress = hasBudget ? (spent / budget).clamp(0.0, 1.0) : 0.0;
      final isOverBudget = hasBudget && spent > budget;

      return InkWell(
        onTap: () => _showSetBudgetSheet(context, category, budget),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: category.color,
                    child: SvgPicture.asset(
                      category.icon,
                      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                      width: 20,
                      height: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(category.label, style: const TextStyle(fontWeight: FontWeight.w600)),
                        Text(
                          hasBudget ? '${spent.toRupiahString()} / ${budget.toRupiahString()}' : 'Belum ada anggaran',
                          style: TextStyle(
                            fontSize: 12,
                            color: isOverBudget ? Colors.red : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(hasBudget ? Icons.edit : Icons.add_circle_outline, color: Colors.grey),
                ],
              ),
              if (hasBudget) ...[
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: Colors.grey[300],
                    color: isOverBudget ? Colors.red : category.color,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    });
  }

  Future<void> _showSetBudgetSheet(BuildContext context, Category category, double currentBudget) async {
    final amountController = TextEditingController(
      text: currentBudget > 0 ? currentBudget.toRupiahString() : '',
    );

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Anggaran ${category.label}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: amountController,
                autofocus: true,
                keyboardType: TextInputType.number,
                inputFormatters: [CureencyFormatter()],
                decoration: InputDecoration(
                  hintText: 'Rp. 500.000',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  if (currentBudget > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          await controller.setBudget(category.id, 0);
                          if (context.mounted) Navigator.of(context).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Hapus'),
                      ),
                    ),
                  if (currentBudget > 0) const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final amount = amountController.text.toDoubleFromRupiah();
                        await controller.setBudget(category.id, amount);
                        if (context.mounted) Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Simpan', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
