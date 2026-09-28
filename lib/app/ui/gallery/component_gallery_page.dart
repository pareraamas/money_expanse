import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../ui.dart';
import '../../widgets/app_snackbar.dart';

/// Halaman debug untuk me-review semua komponen inti di light & dark.
///
/// Buka dengan `Get.to(() => const ComponentGalleryPage())` atau
/// `Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ComponentGalleryPage()))`.
class ComponentGalleryPage extends StatefulWidget {
  const ComponentGalleryPage({super.key});

  @override
  State<ComponentGalleryPage> createState() => _ComponentGalleryPageState();
}

class _ComponentGalleryPageState extends State<ComponentGalleryPage> {
  bool? _dark;
  int _amount = 25000;
  DateTime _month = DateTime(2026, 9);
  int _successKey = 0;

  @override
  Widget build(BuildContext context) {
    final dark = _dark ?? Theme.of(context).brightness == Brightness.dark;
    return AnimatedTheme(
      data: dark ? AppTheme.dark() : AppTheme.light(),
      child: Builder(builder: (context) => _buildPage(context, dark)),
    );
  }

  Widget _buildPage(BuildContext context, bool dark) {
    final c = context.colors;
    final t = context.text;
    final demo = [
      ('Makan', CategoryIcons.pizzaSlice, c.expense),
      ('Langganan', CategoryIcons.rssAlt, c.brand),
      ('Buku', CategoryIcons.bookOpen, c.income),
      ('Hadiah', CategoryIcons.gift, c.warning),
      ('Transport', CategoryIcons.carSideview, c.onBrandContainer),
      ('Belanja', CategoryIcons.shoppingCart, c.danger),
      ('Rumah', CategoryIcons.home, c.onAccentContainer),
      ('Olahraga', CategoryIcons.basketball, c.onIncomeContainer),
      ('Hiburan', CategoryIcons.clapperBoard, c.onExpenseContainer),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Galeri komponen'),
        actions: [
          IconButton(
            tooltip: dark ? 'Mode terang' : 'Mode gelap',
            onPressed: () => setState(() => _dark = !dark),
            icon: Icon(
              dark ? AppIcons.sun : AppIcons.moon,
              semanticLabel: dark ? 'Mode terang' : 'Mode gelap',
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.page, AppSpacing.s8, AppSpacing.page, AppSpacing.s48),
        children: [
          const _Section('BalanceCard'),
          BalanceCard(
            amount: 4250000,
            caption: 'Semua pemasukan dikurangi pengeluaran',
            onTap: () {},
            footer: Row(
              children: [
                Expanded(child: _MiniStat(label: 'Masuk', amount: 8000000, kind: AmountKind.income)),
                const SizedBox(width: AppSpacing.s12),
                Expanded(child: _MiniStat(label: 'Keluar', amount: 3750000, kind: AmountKind.expense)),
              ],
            ),
          ),

          const _Section('AmountText'),
          const Wrap(
            spacing: AppSpacing.s16,
            runSpacing: AppSpacing.s8,
            children: [
              AmountText(25000, kind: AmountKind.income),
              AmountText(25000, kind: AmountKind.expense),
              AmountText(1250000),
              AmountText(-50000),
            ],
          ),
          const SizedBox(height: AppSpacing.s8),
          const AmountText(1200000, kind: AmountKind.expense, size: AmountSize.large),

          const _Section('CategoryBlob'),
          Row(
            children: [
              for (final s in CategoryBlobSize.values) ...[
                CategoryBlob(iconAsset: demo[0].$2, color: demo[0].$3, size: s, semanticLabel: demo[0].$1),
                const SizedBox(width: AppSpacing.s16),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.s16),
          Wrap(
            spacing: AppSpacing.s12,
            runSpacing: AppSpacing.s12,
            children: [
              for (final d in demo)
                SizedBox(
                  width: 64,
                  child: Column(
                    children: [
                      CategoryBlob(iconAsset: d.$2, color: d.$3, size: CategoryBlobSize.large),
                      const SizedBox(height: AppSpacing.s4),
                      Text(d.$1, maxLines: 1, overflow: TextOverflow.ellipsis, style: t.labelMedium?.copyWith(color: c.inkMuted)),
                    ],
                  ),
                ),
            ],
          ),

          const _Section('TransactionTile'),
          TransactionTile(
            title: 'Nasi padang',
            categoryLabel: 'Makan',
            amount: 25000,
            kind: AmountKind.expense,
            categoryIcon: demo[0].$2,
            categoryColor: demo[0].$3,
            dateLabel: '28 Sep',
            onTap: () {},
            onDelete: () {},
            dismissKey: const ValueKey('demo-1'),
          ),
          const SizedBox(height: AppSpacing.stack),
          TransactionTile(
            title: 'Gaji September',
            categoryLabel: 'Pemasukan',
            amount: 8000000,
            kind: AmountKind.income,
            categoryIcon: demo[3].$2,
            categoryColor: demo[3].$3,
            onTap: () {},
          ),
          const SizedBox(height: AppSpacing.stack),
          TransactionTile(
            title: 'Bensin',
            categoryLabel: 'Transport',
            note: 'Isi penuh sebelum mudik ke rumah nenek di Bandung',
            amount: 150000,
            kind: AmountKind.expense,
            categoryIcon: demo[4].$2,
            categoryColor: demo[4].$3,
            onTap: () {},
          ),

          const _Section('BudgetProgress'),
          _Card(
            child: Column(
              children: [
                BudgetProgress.fromAmounts(label: 'Makan', used: 450000, budget: 1000000, pace: 0.93),
                const SizedBox(height: AppSpacing.s24),
                BudgetProgress.fromAmounts(label: 'Transport', used: 430000, budget: 500000, pace: 0.93),
                const SizedBox(height: AppSpacing.s24),
                BudgetProgress.fromAmounts(label: 'Belanja', used: 620000, budget: 500000, pace: 0.93),
                const SizedBox(height: AppSpacing.s24),
                const BudgetProgress(label: 'Tanpa nominal & pace', ratio: 0.3),
              ],
            ),
          ),

          const _Section('AmountKeypad'),
          Center(child: AmountText(_amount, kind: AmountKind.expense, size: AmountSize.display)),
          const SizedBox(height: AppSpacing.s16),
          AmountKeypad(value: _amount, onChanged: (v) => setState(() => _amount = v)),

          const _Section('MonthSwitcher'),
          Center(
            child: MonthSwitcher(
              month: _month,
              onPrev: () => setState(() => _month = DateTime(_month.year, _month.month - 1)),
              onNext: () => setState(() => _month = DateTime(_month.year, _month.month + 1)),
              onTap: () {},
            ),
          ),

          const _Section('AppSheet'),
          AppSheet(
            title: 'Atur anggaran Makan',
            subtitle: 'Terpakai bulan ini Rp 450.000',
            leading: CategoryBlob(iconAsset: demo[0].$2, color: demo[0].$3, size: CategoryBlobSize.large),
            primaryLabel: 'Simpan',
            onPrimary: () {},
            child: Text('Isi sheet di sini.', style: t.bodyLarge?.copyWith(color: c.inkMuted)),
          ),
          const SizedBox(height: AppSpacing.s12),
          OutlinedButton(
            onPressed: () => AppSheet.show<void>(
              context,
              title: 'Contoh sheet',
              subtitle: 'Radius 28, handle, satu tombol utama',
              primaryLabel: 'Mengerti',
              onPrimary: () => Navigator.of(context).pop(),
              child: Text('Tarik ke bawah untuk menutup.', style: t.bodyLarge?.copyWith(color: c.inkMuted)),
            ),
            child: const Text('Buka AppSheet'),
          ),

          const _Section('ConfirmDialog'),
          const ConfirmDialog(title: 'Hapus transaksi ini?', message: 'Catatan "Nasi padang" akan dihapus permanen.'),
          const SizedBox(height: AppSpacing.s12),
          OutlinedButton(
            onPressed: () async {
              final ok = await ConfirmDialog.show(context, title: 'Hapus kategori?', message: 'Kategori "Makan" akan dihapus.');
              if (context.mounted) {
                showAppSnackBar(ok ? 'Dihapus' : 'Dibatalkan');
              }
            },
            child: const Text('Buka ConfirmDialog'),
          ),

          const _Section('EmptyState'),
          for (final e in [
            EmptyState.beranda(onAction: () {}, illustrationSize: 120),
            EmptyState.anggaran(onAction: () {}, illustrationSize: 120),
            EmptyState.statistik(onAction: () {}, illustrationSize: 120),
            EmptyState.kategori(onAction: () {}, illustrationSize: 120),
          ]) ...[_Card(child: e), const SizedBox(height: AppSpacing.stack)],

          const _Section('SkeletonList'),
          const SkeletonList(itemCount: 1, shape: SkeletonShape.card, padding: EdgeInsets.zero),
          const SizedBox(height: AppSpacing.stack),
          const SkeletonList(itemCount: 3, padding: EdgeInsets.zero),
          const SizedBox(height: AppSpacing.stack),
          const SkeletonList(itemCount: 2, shape: SkeletonShape.budget, padding: EdgeInsets.zero),

          const _Section('Ilustrasi & Dompi'),
          Wrap(
            spacing: AppSpacing.s12,
            runSpacing: AppSpacing.s12,
            children: [
              for (final m in DompiMood.values)
                _Labeled(label: m.name, child: AppIllustration.dompi(m, size: 96, semanticLabel: m.label)),
              for (final a in AppIllustrations.micro)
                _Labeled(label: a.split('/').last.replaceAll('.svg', ''), child: AppIllustration(a, size: 64)),
            ],
          ),
          const SizedBox(height: AppSpacing.s16),
          Row(
            children: [
              SuccessCheck(key: ValueKey(_successKey)),
              const SizedBox(width: AppSpacing.s16),
              TextButton(onPressed: () => setState(() => _successKey++), child: const Text('Putar ulang')),
            ],
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.title);

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: AppSpacing.section, bottom: AppSpacing.s12),
    child: Semantics(
      header: true,
      child: Text(title, style: context.text.titleLarge?.copyWith(color: context.colors.ink)),
    ),
  );
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(color: context.colors.surfaceContainerLowest, borderRadius: AppRadius.cardAll),
    child: Padding(padding: const EdgeInsets.all(AppSpacing.card), child: child),
  );
}

class _Labeled extends StatelessWidget {
  const _Labeled({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      child,
      Text(label, style: context.text.labelMedium?.copyWith(color: context.colors.inkMuted)),
    ],
  );
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.amount, required this.kind});

  final String label;
  final num amount;
  final AmountKind kind;

  @override
  Widget build(BuildContext context) {
    final t = context.components.balanceCard;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12, vertical: AppSpacing.s8),
      decoration: BoxDecoration(color: t.pattern, borderRadius: AppRadius.inputAll),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: context.text.labelMedium?.copyWith(color: t.foregroundMuted)),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: AmountText(amount, kind: kind, size: AmountSize.small, color: t.foreground),
          ),
        ],
      ),
    );
  }
}
