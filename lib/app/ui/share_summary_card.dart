import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'app_format.dart';
import 'app_illustration.dart';

/// Ukuran kanvas kartu bagikan. [size] dalam logical pixel; diekspor dengan
/// `pixelRatio` = [exportWidth] / lebar, jadi Story = 1080×1920, Feed = 1080×1350.
enum ShareCardFormat {
  story('Story', Size(360, 640)),
  feed('Feed', Size(360, 450));

  const ShareCardFormat(this.label, this.size);

  final String label;
  final Size size;

  static const double exportWidth = 1080;

  double get pixelRatio => exportWidth / size.width;
}

/// Satu baris kategori di kartu. [color] null = gabungan "Lainnya".
class ShareCardSlice {
  const ShareCardSlice({required this.label, required this.amount, this.color});

  final String label;
  final double amount;
  final Color? color;
}

/// Kartu ringkasan bulanan untuk dibagikan ke media sosial.
///
/// Selalu dirender dengan tema terang dan tanpa skala teks sistem agar gambar
/// yang dibagikan sama di semua perangkat. [hideAmounts] mengganti semua
/// nominal dengan "Rp •••" sehingga hanya persentase yang tampil.
class ShareSummaryCard extends StatelessWidget {
  const ShareSummaryCard({
    super.key,
    required this.month,
    required this.income,
    required this.expense,
    required this.slices,
    this.format = ShareCardFormat.story,
    this.hideAmounts = false,
  });

  final DateTime month;
  final double income;
  final double expense;
  final List<ShareCardSlice> slices;
  final ShareCardFormat format;
  final bool hideAmounts;

  static final _theme = AppTheme.light();

  double get balance => income - expense;

  /// "Hemat 32% dari pemasukan" — tetap bermakna walau nominal disembunyikan.
  String? get highlight {
    if (income <= 0) return null;
    if (balance < 0) return 'Pengeluaran melebihi pemasukan';
    return 'Hemat ${(balance / income * 100).round()}% dari pemasukan';
  }

  String _money(num amount) => hideAmounts ? 'Rp •••' : AppFormat.rupiah(amount);

  double _share(double amount) => expense <= 0 ? 0 : (amount / expense).clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _theme,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
        child: Builder(builder: _build),
      ),
    );
  }

  Widget _build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final story = format == ShareCardFormat.story;
    final onBrand = t.labelLarge?.copyWith(color: c.onBrand);

    return SizedBox.fromSize(
      size: format.size,
      child: DecoratedBox(
        decoration: BoxDecoration(color: c.brand),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ringkasan keuangan', style: onBrand),
                        const SizedBox(height: AppSpacing.s4),
                        Text(AppFormat.monthYear(month), style: t.headlineMedium?.copyWith(color: c.onBrand)),
                      ],
                    ),
                  ),
                  // Dompi hanya untuk momen ringan, bukan saat tekor.
                  if (story && balance >= 0) AppIllustration.dompi(DompiMood.bangga, size: 88),
                ],
              ),
              SizedBox(height: story ? AppSpacing.s24 : AppSpacing.s16),
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(color: c.surfaceContainerLowest, borderRadius: AppRadius.cardAll),
                  child: Padding(padding: const EdgeInsets.all(AppSpacing.s20), child: _body(context, story)),
                ),
              ),
              SizedBox(height: story ? AppSpacing.s20 : AppSpacing.s12),
              Text('Dicatat dengan Money Expense', textAlign: TextAlign.center, style: onBrand),
            ],
          ),
        ),
      ),
    );
  }

  Widget _body(BuildContext context, bool story) {
    final c = context.colors;
    final t = context.text;

    final total = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Total pengeluaran', style: t.labelMedium?.copyWith(color: c.inkMuted)),
        Text(_money(expense), style: AppTypography.amountLarge.copyWith(color: c.ink)),
      ],
    );

    final Widget breakdown;
    if (slices.isEmpty) {
      breakdown = Center(
        child: Text('Belum ada pengeluaran bulan ini.', style: t.bodyMedium?.copyWith(color: c.inkMuted)),
      );
    } else if (story) {
      breakdown = Column(
        children: [
          Expanded(child: Center(child: _donut(context, 168))),
          const SizedBox(height: AppSpacing.s16),
          ..._rows(context, withAmount: !hideAmounts),
        ],
      );
    } else {
      breakdown = Row(
        children: [
          _donut(context, 120),
          const SizedBox(width: AppSpacing.s16),
          Expanded(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: _rows(context, withAmount: false)),
          ),
        ],
      );
    }

    final note = highlight;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        total,
        const SizedBox(height: AppSpacing.s12),
        Expanded(child: breakdown),
        if (note != null) ...[
          const SizedBox(height: AppSpacing.s12),
          DecoratedBox(
            decoration: BoxDecoration(color: balance < 0 ? c.warningContainer : c.brandContainer, borderRadius: AppRadius.inputAll),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s12, vertical: AppSpacing.s8),
              child: Text(
                note,
                textAlign: TextAlign.center,
                style: t.labelLarge?.copyWith(color: balance < 0 ? c.onWarningContainer : c.onBrandContainer),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _donut(BuildContext context, double size) {
    final c = context.colors;
    return SizedBox.square(
      dimension: size,
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: size * 0.3,
          startDegreeOffset: -90,
          pieTouchData: PieTouchData(enabled: false),
          sections: [
            for (final s in slices) PieChartSectionData(value: s.amount, color: s.color ?? c.outline, radius: size * 0.18, showTitle: false),
          ],
        ),
        duration: Duration.zero,
      ),
    );
  }

  /// Di Feed kolom nominal tidak muat di samping donut, jadi hanya persentase.
  List<Widget> _rows(BuildContext context, {required bool withAmount}) {
    final c = context.colors;
    final t = context.text;
    return [
      for (final s in slices)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.s4),
          child: Row(
            children: [
              SizedBox.square(
                dimension: 12,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: s.color ?? c.outline, shape: BoxShape.circle),
                ),
              ),
              const SizedBox(width: AppSpacing.s8),
              Expanded(
                child: Text(
                  s.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: t.bodyMedium?.copyWith(color: c.ink),
                ),
              ),
              Text(
                '${(_share(s.amount) * 100).round()}%',
                style: t.labelLarge?.copyWith(color: c.ink, fontFeatures: AppTypography.tabular),
              ),
              if (withAmount) ...[
                const SizedBox(width: AppSpacing.s8),
                Text(AppFormat.rupiah(s.amount), style: AppTypography.amountSmall.copyWith(color: c.inkMuted)),
              ],
            ],
          ),
        ),
    ];
  }
}
