import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:money_expense/app/data/models/category_model.dart';
import 'package:money_expense/app/theme/app_color.dart';
import 'package:money_expense/app/ults/string_currency_parsing.dart';
import 'package:money_expense/app/widgets/month_year_picker_sheet.dart';

import '../controllers/statistik_controller.dart';

class StatistikView extends GetView<StatistikController> {
  const StatistikView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        title: const Text(
          'Statistik',
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
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: controller.loadData,
          child: ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              _SummaryCard(controller: controller),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'Pengeluaran per Kategori',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
              if (controller.categoriesWithSpending.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(child: Text('Belum ada pengeluaran bulan ini')),
                )
              else
                ...controller.categoriesWithSpending.map(
                  (category) => _CategoryStatTile(category: category, controller: controller),
                ),
            ],
          ),
        );
      }),
    );
  }
}

class _SummaryCard extends StatefulWidget {
  final StatistikController controller;
  const _SummaryCard({required this.controller});

  @override
  State<_SummaryCard> createState() => _SummaryCardState();
}

class _SummaryCardState extends State<_SummaryCard> {
  int? _touchedIndex;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final income = widget.controller.totalIncome.value;
      final expense = widget.controller.totalExpense.value;
      final balance = widget.controller.balance;
      final categories = widget.controller.categoriesWithSpending;
      final hasSpending = categories.isNotEmpty;

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
            Text('Saldo Bulan Ini', style: TextStyle(color: Colors.white.withValues(alpha: 0.9))),
            const SizedBox(height: 8),
            Text(
              balance.toRupiahString(),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 20),
            if (hasSpending) ...[
              SizedBox(
                height: 160,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    PieChart(
                      PieChartData(
                        sectionsSpace: 3,
                        centerSpaceRadius: 44,
                        pieTouchData: PieTouchData(
                          touchCallback: (event, response) {
                            if (!event.isInterestedForInteractions ||
                                response == null ||
                                response.touchedSection == null) {
                              setState(() => _touchedIndex = null);
                              return;
                            }
                            setState(() => _touchedIndex = response.touchedSection!.touchedSectionIndex);
                          },
                        ),
                        sections: List.generate(categories.length, (index) {
                          final category = categories[index];
                          final spent = widget.controller.spendingByCategory[category.id] ?? 0.0;
                          final percent = expense <= 0 ? 0.0 : spent / expense;
                          final isTouched = index == _touchedIndex;
                          final radius = isTouched ? 46.0 : 38.0;

                          return PieChartSectionData(
                            value: spent,
                            color: category.color,
                            radius: radius,
                            title: percent >= 0.08 ? '${(percent * 100).toStringAsFixed(0)}%' : '',
                            titleStyle: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        }),
                      ),
                      duration: const Duration(milliseconds: 300),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _touchedIndex != null && _touchedIndex! < categories.length
                              ? categories[_touchedIndex!].label
                              : 'Pengeluaran',
                          style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.9)),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          (_touchedIndex != null && _touchedIndex! < categories.length
                                  ? widget.controller.spendingByCategory[categories[_touchedIndex!].id] ?? 0.0
                                  : expense)
                              .toRupiahString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
            Row(
              children: [
                Expanded(
                  child: _SummaryItem(
                    icon: Icons.arrow_downward,
                    iconColor: Colors.greenAccent,
                    label: 'Pemasukan',
                    value: income,
                  ),
                ),
                Expanded(
                  child: _SummaryItem(
                    icon: Icons.arrow_upward,
                    iconColor: Colors.redAccent,
                    label: 'Pengeluaran',
                    value: expense,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final double value;

  const _SummaryItem({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(radius: 14, backgroundColor: Colors.white24, child: Icon(icon, color: iconColor, size: 16)),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 11)),
              Text(
                value.toRupiahString(),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CategoryStatTile extends StatelessWidget {
  final Category category;
  final StatistikController controller;
  const _CategoryStatTile({required this.category, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final spent = controller.spendingByCategory[category.id] ?? 0.0;
      final total = controller.totalExpense.value;
      final percent = total <= 0 ? 0.0 : (spent / total).clamp(0.0, 1.0);

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
                  child: Text(category.label, style: const TextStyle(fontWeight: FontWeight.w600)),
                ),
                Text(
                  spent.toRupiahString(),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: percent,
                minHeight: 6,
                backgroundColor: Colors.grey[300],
                color: category.color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${(percent * 100).toStringAsFixed(1)}% dari total pengeluaran',
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    });
  }
}
