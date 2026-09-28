import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'radius.dart';
import 'spacing.dart';

/// Lapis 3 — token komponen. Diturunkan dari [AppColors], jadi dark mode
/// ikut otomatis. Komponen di `lib/app/ui/` membaca dari sini.
@immutable
class AppComponentTokens extends ThemeExtension<AppComponentTokens> {
  const AppComponentTokens({
    required this.balanceCard,
    required this.amountText,
    required this.categoryBlob,
    required this.keypadKey,
    required this.budgetProgress,
  });

  factory AppComponentTokens.from(AppColors c) => AppComponentTokens(
    balanceCard: BalanceCardTokens(
      background: c.brand,
      foreground: c.onBrand,
      foregroundMuted: c.onBrand.withValues(alpha: 0.8),
      pattern: c.onBrand.withValues(alpha: 0.08),
      radius: AppRadius.card,
      padding: AppSpacing.s20,
    ),
    amountText: AmountTextTokens(income: c.income, expense: c.expense, neutral: c.ink),
    categoryBlob: const CategoryBlobTokens(tintOpacity: 0.15, sizeSmall: 32, sizeMedium: 40, sizeLarge: 56, iconScale: 0.55),
    keypadKey: KeypadKeyTokens(
      background: c.surfaceContainerLow,
      foreground: c.ink,
      pressed: c.surfaceContainerHighest,
      actionForeground: c.brand,
      radius: AppRadius.input,
      minSize: AppSpacing.keypadTouch,
    ),
    budgetProgress: BudgetProgressTokens(
      track: c.surfaceContainerHighest,
      safe: c.brand,
      warning: c.warningFill,
      danger: c.danger,
      paceMarker: c.ink,
      height: 8,
      warningThreshold: 0.8,
    ),
  );

  final BalanceCardTokens balanceCard;
  final AmountTextTokens amountText;
  final CategoryBlobTokens categoryBlob;
  final KeypadKeyTokens keypadKey;
  final BudgetProgressTokens budgetProgress;

  @override
  AppComponentTokens copyWith({
    BalanceCardTokens? balanceCard,
    AmountTextTokens? amountText,
    CategoryBlobTokens? categoryBlob,
    KeypadKeyTokens? keypadKey,
    BudgetProgressTokens? budgetProgress,
  }) => AppComponentTokens(
    balanceCard: balanceCard ?? this.balanceCard,
    amountText: amountText ?? this.amountText,
    categoryBlob: categoryBlob ?? this.categoryBlob,
    keypadKey: keypadKey ?? this.keypadKey,
    budgetProgress: budgetProgress ?? this.budgetProgress,
  );

  @override
  AppComponentTokens lerp(ThemeExtension<AppComponentTokens>? other, double t) {
    if (other is! AppComponentTokens) return this;
    return AppComponentTokens(
      balanceCard: balanceCard.lerp(other.balanceCard, t),
      amountText: amountText.lerp(other.amountText, t),
      categoryBlob: t < 0.5 ? categoryBlob : other.categoryBlob,
      keypadKey: keypadKey.lerp(other.keypadKey, t),
      budgetProgress: budgetProgress.lerp(other.budgetProgress, t),
    );
  }
}

Color _l(Color a, Color b, double t) => Color.lerp(a, b, t)!;

@immutable
class BalanceCardTokens {
  const BalanceCardTokens({
    required this.background,
    required this.foreground,
    required this.foregroundMuted,
    required this.pattern,
    required this.radius,
    required this.padding,
  });

  final Color background;
  final Color foreground;
  final Color foregroundMuted;

  /// Warna pola koin halus di pojok kartu.
  final Color pattern;
  final double radius;
  final double padding;

  BalanceCardTokens lerp(BalanceCardTokens o, double t) => BalanceCardTokens(
    background: _l(background, o.background, t),
    foreground: _l(foreground, o.foreground, t),
    foregroundMuted: _l(foregroundMuted, o.foregroundMuted, t),
    pattern: _l(pattern, o.pattern, t),
    radius: radius,
    padding: padding,
  );
}

@immutable
class AmountTextTokens {
  const AmountTextTokens({required this.income, required this.expense, required this.neutral});

  final Color income;
  final Color expense;
  final Color neutral;

  AmountTextTokens lerp(AmountTextTokens o, double t) =>
      AmountTextTokens(income: _l(income, o.income, t), expense: _l(expense, o.expense, t), neutral: _l(neutral, o.neutral, t));
}

@immutable
class CategoryBlobTokens {
  const CategoryBlobTokens({
    required this.tintOpacity,
    required this.sizeSmall,
    required this.sizeMedium,
    required this.sizeLarge,
    required this.iconScale,
  });

  /// Opacity warna kategori untuk wadah blob (15%).
  final double tintOpacity;
  final double sizeSmall;
  final double sizeMedium;
  final double sizeLarge;

  /// Ukuran ikon relatif terhadap blob.
  final double iconScale;

  /// Warna wadah blob untuk [categoryColor].
  Color tint(Color categoryColor) => categoryColor.withValues(alpha: tintOpacity);
}

@immutable
class KeypadKeyTokens {
  const KeypadKeyTokens({
    required this.background,
    required this.foreground,
    required this.pressed,
    required this.actionForeground,
    required this.radius,
    required this.minSize,
  });

  final Color background;
  final Color foreground;
  final Color pressed;

  /// Warna tombol "000" dan hapus.
  final Color actionForeground;
  final double radius;
  final double minSize;

  KeypadKeyTokens lerp(KeypadKeyTokens o, double t) => KeypadKeyTokens(
    background: _l(background, o.background, t),
    foreground: _l(foreground, o.foreground, t),
    pressed: _l(pressed, o.pressed, t),
    actionForeground: _l(actionForeground, o.actionForeground, t),
    radius: radius,
    minSize: minSize,
  );
}

@immutable
class BudgetProgressTokens {
  const BudgetProgressTokens({
    required this.track,
    required this.safe,
    required this.warning,
    required this.danger,
    required this.paceMarker,
    required this.height,
    required this.warningThreshold,
  });

  final Color track;
  final Color safe;
  final Color warning;
  final Color danger;

  /// Garis tegak posisi hari ini di bulan berjalan.
  final Color paceMarker;
  final double height;

  /// Rasio terpakai saat bar berubah ke [warning] (0,8 = 80%).
  final double warningThreshold;

  /// Warna bar untuk rasio [used] (terpakai / budget).
  Color colorFor(double used) {
    if (used > 1) return danger;
    if (used >= warningThreshold) return warning;
    return safe;
  }

  BudgetProgressTokens lerp(BudgetProgressTokens o, double t) => BudgetProgressTokens(
    track: _l(track, o.track, t),
    safe: _l(safe, o.safe, t),
    warning: _l(warning, o.warning, t),
    danger: _l(danger, o.danger, t),
    paceMarker: _l(paceMarker, o.paceMarker, t),
    height: height,
    warningThreshold: warningThreshold,
  );
}
