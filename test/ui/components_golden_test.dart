import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:money_expense/app/theme/app_theme.dart';
import 'package:money_expense/app/ui/ui.dart';

import 'golden_helpers.dart';

void main() {
  setUpAll(loadAppFonts);

  final cases = <(String, Size, Widget Function(BuildContext))>[
    (
      'balance_card',
      const Size(400, 220),
      (_) => const BalanceCard(amount: 4250000, caption: 'Semua pemasukan dikurangi pengeluaran'),
    ),
    (
      'amount_text',
      const Size(400, 200),
      (_) => const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AmountText(25000, kind: AmountKind.income),
          AmountText(25000, kind: AmountKind.expense),
          AmountText(1250000),
          AmountText(-50000),
          AmountText(1200000, kind: AmountKind.expense, size: AmountSize.large),
        ],
      ),
    ),
    (
      'category_blob',
      const Size(400, 200),
      (context) {
        final c = context.colors;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                for (final s in CategoryBlobSize.values) ...[
                  CategoryBlob(iconAsset: CategoryIcons.pizzaSlice, color: c.expense, size: s),
                  const SizedBox(width: AppSpacing.s16),
                ],
              ],
            ),
            const SizedBox(height: AppSpacing.s16),
            Wrap(
              spacing: AppSpacing.s8,
              children: [
                for (final (i, icon) in CategoryIcons.legacy.indexed)
                  CategoryBlob(iconAsset: icon, color: [c.brand, c.income, c.warning, c.danger, c.expense][i % 5]),
              ],
            ),
          ],
        );
      },
    ),
    (
      'transaction_tile',
      const Size(400, 300),
      (context) => Column(
        children: [
          TransactionTile(
            title: 'Nasi padang',
            categoryLabel: 'Makan',
            amount: 25000,
            kind: AmountKind.expense,
            categoryIcon: CategoryIcons.pizzaSlice,
            categoryColor: context.colors.expense,
            dateLabel: '28 Sep',
            onTap: () {},
          ),
          const SizedBox(height: AppSpacing.stack),
          TransactionTile(
            title: 'Gaji September',
            categoryLabel: 'Pemasukan',
            amount: 8000000,
            kind: AmountKind.income,
            categoryIcon: CategoryIcons.gift,
            categoryColor: context.colors.income,
          ),
          const SizedBox(height: AppSpacing.stack),
          TransactionTile(
            title: 'Bensin',
            categoryLabel: 'Transport',
            note: 'Isi penuh sebelum mudik ke rumah nenek di Bandung',
            amount: 150000,
            kind: AmountKind.expense,
            categoryIcon: CategoryIcons.carSideview,
            categoryColor: context.colors.brand,
          ),
        ],
      ),
    ),
    (
      'budget_progress',
      const Size(400, 420),
      (_) => Column(
        children: [
          BudgetProgress.fromAmounts(label: 'Makan', used: 450000, budget: 1000000, pace: 0.93),
          const SizedBox(height: AppSpacing.s24),
          BudgetProgress.fromAmounts(label: 'Transport', used: 430000, budget: 500000, pace: 0.93),
          const SizedBox(height: AppSpacing.s24),
          BudgetProgress.fromAmounts(label: 'Belanja', used: 620000, budget: 500000, pace: 0.93),
          const SizedBox(height: AppSpacing.s24),
          const BudgetProgress(label: 'Hiburan', ratio: 0.3),
        ],
      ),
    ),
    (
      'amount_keypad',
      const Size(400, 400),
      (_) => Column(
        children: [
          const AmountText(25000, kind: AmountKind.expense, size: AmountSize.display),
          const SizedBox(height: AppSpacing.s16),
          AmountKeypad(value: 25000, onChanged: (_) {}, haptics: false),
        ],
      ),
    ),
    (
      'month_switcher',
      const Size(400, 100),
      (_) => Center(child: MonthSwitcher(month: DateTime(2026, 9), onPrev: () {}, onNext: () {}, onTap: () {})),
    ),
    (
      'app_sheet',
      const Size(400, 320),
      (context) => Align(
        alignment: Alignment.bottomCenter,
        child: AppSheet(
          title: 'Atur anggaran Makan',
          subtitle: 'Terpakai bulan ini Rp 450.000',
          leading: CategoryBlob(iconAsset: CategoryIcons.pizzaSlice, color: context.colors.expense, size: CategoryBlobSize.large),
          primaryLabel: 'Simpan',
          onPrimary: () {},
          child: Text('Isi sheet di sini.', style: context.text.bodyLarge?.copyWith(color: context.colors.inkMuted)),
        ),
      ),
    ),
    (
      'confirm_dialog',
      const Size(400, 400),
      (_) => const Center(
        child: ConfirmDialog(title: 'Hapus transaksi ini?', message: 'Catatan "Nasi padang" akan dihapus permanen.'),
      ),
    ),
    ('empty_state', const Size(400, 460), (_) => EmptyState.beranda(onAction: () {})),
    (
      'skeleton_list',
      const Size(400, 520),
      (_) => const Column(
        children: [
          SkeletonList(itemCount: 1, shape: SkeletonShape.card, padding: EdgeInsets.zero),
          SizedBox(height: AppSpacing.stack),
          SkeletonList(itemCount: 3, padding: EdgeInsets.zero),
          SizedBox(height: AppSpacing.stack),
          SkeletonList(itemCount: 1, shape: SkeletonShape.budget, padding: EdgeInsets.zero),
        ],
      ),
    ),
    (
      'illustrations',
      const Size(400, 360),
      (_) => Wrap(
        spacing: AppSpacing.s8,
        runSpacing: AppSpacing.s8,
        children: [
          for (final m in DompiMood.values) AppIllustration.dompi(m, size: 88),
          for (final a in AppIllustrations.empty) AppIllustration(a, size: 88),
          for (final a in AppIllustrations.micro) AppIllustration(a, size: 64),
        ],
      ),
    ),
  ];

  for (final (name, size, build) in cases) {
    for (final (mode, theme) in themes) {
      testWidgets('golden $name $mode', (tester) async {
        await expectGolden(tester, Builder(builder: build), name: '${name}_$mode', theme: theme, size: size);
      });
    }
  }
}
