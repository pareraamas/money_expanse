import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:money_expense/app/data/models/expense.dart';
import 'package:money_expense/app/theme/app_theme.dart';
import 'package:money_expense/app/ui/ui.dart';
import 'package:money_expense/app/ults/date_formatter.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  /// Ruang bawah agar item terakhir tidak tertutup FAB tengah.
  static const _fabClearance = 96.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: controller.onRefresh,
          child: NotificationListener<ScrollNotification>(
            onNotification: (n) {
              if (n.metrics.extentAfter < 240) controller.onLoad();
              return false;
            },
            child: Obx(
              () => CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(AppSpacing.page, AppSpacing.s16, AppSpacing.page, 0),
                    sliver: SliverList.list(
                      children: [
                        _Header(controller: controller),
                        const SizedBox(height: AppSpacing.s20),
                        BalanceCard(
                          amount: controller.totalBalance.value,
                          caption: 'Semua pemasukan dikurangi pengeluaran',
                        ),
                        const SizedBox(height: AppSpacing.stack),
                        Row(
                          children: [
                            Expanded(
                              child: _MonthTotal(label: 'Masuk bulan ini', amount: controller.totalIncomeMonth.value, kind: AmountKind.income),
                            ),
                            const SizedBox(width: AppSpacing.stack),
                            Expanded(
                              child: _MonthTotal(label: 'Keluar bulan ini', amount: controller.totalOutcomeMonth.value, kind: AmountKind.expense),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.stack),
                        _TodayRow(amount: controller.totalOutcomeDay.value),
                        const SizedBox(height: AppSpacing.section),
                        Semantics(
                          header: true,
                          child: Text('Riwayat transaksi', style: context.text.titleLarge),
                        ),
                      ],
                    ),
                  ),
                  ..._history(context),
                  const SliverToBoxAdapter(child: SizedBox(height: _fabClearance)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _history(BuildContext context) {
    if (controller.isLoading.value) {
      return const [
        SliverToBoxAdapter(child: SkeletonList(itemCount: 4, padding: EdgeInsets.all(AppSpacing.page))),
      ];
    }
    if (controller.listExpenses.isEmpty) {
      return [
        SliverToBoxAdapter(child: EmptyState.beranda(onAction: controller.openCreate, illustrationSize: 140)),
      ];
    }

    final reduced = AppMotion.reduced(context);
    var start = 0;
    final groups = <Widget>[];
    for (final entry in controller.listExpenses.entries) {
      final offset = start;
      start += entry.value.length;
      groups.add(
        SliverMainAxisGroup(
          slivers: [
            PinnedHeaderSliver(child: _DateHeader(date: entry.key, expenses: entry.value)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
              sliver: SliverList.separated(
                itemCount: entry.value.length,
                separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.s8),
                itemBuilder: (context, i) {
                  final tile = _tile(context, entry.value[i]);
                  // Masuk bertahap 40 ms per item, hanya untuk layar pertama.
                  final order = offset + i;
                  if (reduced || order > 8) return tile;
                  return tile
                      .animate(delay: AppMotion.stagger * order)
                      .fadeIn(duration: AppMotion.medium, curve: AppMotion.standard)
                      .slideY(begin: 0.08, end: 0, duration: AppMotion.medium, curve: AppMotion.standard);
                },
              ),
            ),
          ],
        ),
      );
    }
    return groups;
  }

  Widget _tile(BuildContext context, Expense expense) {
    final category = expense.category;
    final isIncome = expense.transactionType == 'income';
    final hasNote = category == null || expense.name != category.label;
    return TransactionTile(
      dismissKey: ValueKey(expense.id),
      title: hasNote ? expense.name : category.label,
      categoryLabel: hasNote ? category?.label : null,
      amount: expense.price,
      kind: isIncome ? AmountKind.income : AmountKind.expense,
      categoryIcon: category?.icon ?? CategoryIcons.shoppingCart,
      categoryColor: category?.color ?? context.colors.inkMuted,
      onTap: () => controller.openEdit(expense),
      onDelete: () => controller.deleteExpense(expense),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(controller.greeting, style: context.text.headlineSmall),
              const SizedBox(height: AppSpacing.s2),
              Text('Jangan lupa catat keuanganmu hari ini.', style: context.text.bodyMedium?.copyWith(color: c.inkMuted)),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.s8),
        // Label bulan aktif: ringkasan Masuk/Keluar di bawah selalu bulan ini.
        Semantics(
          label: 'Ringkasan bulan ${AppFormat.monthYear(controller.currentMonth)}',
          excludeSemantics: true,
          child: Chip(
            avatar: Icon(AppIcons.calendarBlank, color: c.brand),
            label: Text(AppFormat.monthYearShort(controller.currentMonth)),
          ),
        ),
      ],
    );
  }
}

class _MonthTotal extends StatelessWidget {
  const _MonthTotal({required this.label, required this.amount, required this.kind});

  final String label;
  final double amount;
  final AmountKind kind;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final container = kind == AmountKind.income ? c.incomeContainer : c.expenseContainer;
    final onContainer = kind == AmountKind.income ? c.onIncomeContainer : c.onExpenseContainer;
    return Card(
      color: container,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.card),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: context.text.labelLarge?.copyWith(color: onContainer)),
            const SizedBox(height: AppSpacing.s4),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerStart,
              child: AmountText(amount, kind: kind, size: AmountSize.large, color: onContainer, semanticsPrefix: label),
            ),
          ],
        ),
      ),
    );
  }
}

/// Baris "Hari ini" — totalnya sudah dihitung controller sejak dulu, kini tampil.
class _TodayRow extends StatelessWidget {
  const _TodayRow({required this.amount});

  final double amount;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final empty = amount <= 0;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.card, vertical: AppSpacing.s12),
        child: Row(
          children: [
            if (empty) ...[
              const AppIllustration(AppIllustrations.hariIniKosong, size: 40),
              const SizedBox(width: AppSpacing.s12),
            ],
            Expanded(
              child: Text(
                empty ? 'Hari ini belum ada pengeluaran' : 'Keluar hari ini',
                style: context.text.bodyLarge?.copyWith(color: empty ? c.inkMuted : c.ink),
              ),
            ),
            if (!empty) AmountText(amount, kind: AmountKind.expense, semanticsPrefix: 'Keluar hari ini'),
          ],
        ),
      ),
    );
  }
}

/// Header tanggal yang lengket, dengan selisih harian di kanan.
class _DateHeader extends StatelessWidget {
  const _DateHeader({required this.date, required this.expenses});

  final DateTime date;
  final List<Expense> expenses;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final net = expenses.fold(0.0, (sum, e) => sum + (e.transactionType == 'income' ? e.price : -e.price));
    return ColoredBox(
      color: c.surface,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.page, AppSpacing.s16, AppSpacing.page, AppSpacing.s8),
        child: Row(
          children: [
            Expanded(
              child: Semantics(
                header: true,
                child: Text(date.toHumanReadable(), style: context.text.titleSmall?.copyWith(color: c.inkMuted)),
              ),
            ),
            AmountText(net, size: AmountSize.small, color: c.inkMuted, semanticsPrefix: 'Selisih'),
          ],
        ),
      ),
    );
  }
}
