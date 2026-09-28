import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:wister_lite/app/data/models/expense.dart';
import 'package:wister_lite/app/theme/app_theme.dart';
import 'package:wister_lite/app/ui/ui.dart';
import 'package:wister_lite/app/ults/date_formatter.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  /// Ruang bawah agar item terakhir tidak tertutup FAB tengah.
  static const _fabClearance = 96.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: controller.onRefresh,
        child: Obx(
          () => CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              PageAppBar(
                title: controller.greeting,
                trailing: _MonthChip(month: controller.currentMonth),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.page, 0, AppSpacing.page, 0),
                sliver: SliverList.list(
                  children: [
                    Text('Jangan lupa catat keuanganmu hari ini.', style: context.text.bodyMedium?.copyWith(color: context.colors.inkMuted)),
                    const SizedBox(height: AppSpacing.s20),
                    BalanceCard(amount: controller.totalBalance.value, caption: 'Semua pemasukan dikurangi pengeluaran'),
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
                    _HistoryHeader(onTap: controller.openHistory),
                  ],
                ),
              ),
              ..._history(context),
              const SliverToBoxAdapter(child: SizedBox(height: _fabClearance)),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _history(BuildContext context) {
    if (controller.isLoading.value) {
      return const [SliverToBoxAdapter(child: SkeletonList(itemCount: 4, padding: EdgeInsets.all(AppSpacing.page)))];
    }
    if (controller.listExpenses.isEmpty) {
      return [SliverToBoxAdapter(child: EmptyState.beranda(onAction: controller.openCreate, illustrationSize: 140))];
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
            PinnedHeaderSliver(
              child: DateGroupHeader(
                label: entry.key.toHumanReadable(),
                net: entry.value.fold(0.0, (sum, e) => sum + (e.transactionType == 'income' ? e.price : -e.price)),
              ),
            ),
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

/// Label bulan aktif: ringkasan Masuk/Keluar di bawah selalu bulan ini.
class _MonthChip extends StatelessWidget {
  const _MonthChip({required this.month});

  final DateTime month;

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Ringkasan bulan ${AppFormat.monthYear(month)}',
    excludeSemantics: true,
    child: Chip(
      avatar: Icon(AppIcons.calendarBlank, color: context.colors.brand),
      label: Text(AppFormat.monthYearShort(month)),
    ),
  );
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
            if (empty) ...[const AppIllustration(AppIllustrations.hariIniKosong, size: 40), const SizedBox(width: AppSpacing.s12)],
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

/// Judul "Riwayat transaksi" dengan tombol ">" ke halaman riwayat lengkap.
class _HistoryHeader extends StatelessWidget {
  const _HistoryHeader({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Semantics(header: true, child: Text('Riwayat transaksi', style: context.text.titleLarge)),
      ),
      IconButton(
        onPressed: onTap,
        tooltip: 'Lihat semua riwayat',
        icon: const Icon(AppIcons.caretRight, semanticLabel: 'Lihat semua riwayat'),
      ),
    ],
  );
}
