import 'package:flutter/material.dart';

import 'palette.dart';

/// Lapis 2 — warna semantik. Satu-satunya lapis yang berganti saat dark mode.
///
/// Aturan pakai:
/// - `income` / `expense` / `warning` adalah warna **teks & ikon** (lolos 4,5:1
///   di semua surface). Varian `*Fill` hanya untuk grafik: irisan donut, bar
///   progress, titik indikator — selalu dipasangkan dengan tanda +/− atau ikon.
/// - Warna semantik dipatok, tidak ikut dynamic color.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.brand,
    required this.onBrand,
    required this.brandContainer,
    required this.onBrandContainer,
    required this.accent,
    required this.onAccent,
    required this.accentContainer,
    required this.onAccentContainer,
    required this.surface,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
    required this.inverseSurface,
    required this.onInverseSurface,
    required this.ink,
    required this.inkMuted,
    required this.outline,
    required this.outlineVariant,
    required this.income,
    required this.incomeFill,
    required this.incomeContainer,
    required this.onIncomeContainer,
    required this.expense,
    required this.expenseFill,
    required this.expenseContainer,
    required this.onExpenseContainer,
    required this.warning,
    required this.warningFill,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.danger,
    required this.onDanger,
    required this.dangerContainer,
    required this.onDangerContainer,
    required this.scrim,
  });

  final Color brand;
  final Color onBrand;
  final Color brandContainer;
  final Color onBrandContainer;

  final Color accent;
  final Color onAccent;
  final Color accentContainer;
  final Color onAccentContainer;

  /// Latar halaman (krem / malam, bukan putih/hitam murni).
  final Color surface;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
  final Color inverseSurface;
  final Color onInverseSurface;

  /// Teks utama.
  final Color ink;

  /// Teks sekunder.
  final Color inkMuted;
  final Color outline;
  final Color outlineVariant;

  final Color income;
  final Color incomeFill;
  final Color incomeContainer;
  final Color onIncomeContainer;

  final Color expense;
  final Color expenseFill;
  final Color expenseContainer;
  final Color onExpenseContainer;

  /// Budget di atas 80%.
  final Color warning;
  final Color warningFill;
  final Color warningContainer;
  final Color onWarningContainer;

  /// Over-budget dan aksi hapus.
  final Color danger;
  final Color onDanger;
  final Color dangerContainer;
  final Color onDangerContainer;

  final Color scrim;

  static const light = AppColors(
    brand: AppPalette.teal700,
    onBrand: AppPalette.white,
    brandContainer: AppPalette.teal100,
    onBrandContainer: AppPalette.teal900,
    accent: AppPalette.mango400,
    onAccent: AppPalette.ink900,
    accentContainer: AppPalette.mango100,
    onAccentContainer: AppPalette.mango900,
    surface: AppPalette.cream50,
    surfaceContainerLowest: AppPalette.cream0,
    surfaceContainerLow: AppPalette.cream100,
    surfaceContainer: AppPalette.cream200,
    surfaceContainerHigh: AppPalette.cream300,
    surfaceContainerHighest: AppPalette.cream400,
    inverseSurface: AppPalette.night400,
    onInverseSurface: AppPalette.cream700,
    ink: AppPalette.ink900,
    inkMuted: AppPalette.ink600,
    outline: AppPalette.cream600,
    outlineVariant: AppPalette.cream500,
    income: AppPalette.green700,
    incomeFill: AppPalette.green600,
    incomeContainer: AppPalette.green100,
    onIncomeContainer: AppPalette.green800,
    expense: AppPalette.coral700,
    expenseFill: AppPalette.coral500,
    expenseContainer: AppPalette.coral100,
    onExpenseContainer: AppPalette.coral800,
    warning: AppPalette.amber700,
    warningFill: AppPalette.amber500,
    warningContainer: AppPalette.amber100,
    onWarningContainer: AppPalette.amber800,
    danger: AppPalette.red700,
    onDanger: AppPalette.white,
    dangerContainer: AppPalette.red100,
    onDangerContainer: AppPalette.red800,
    scrim: AppPalette.black,
  );

  static const dark = AppColors(
    brand: AppPalette.teal400,
    onBrand: AppPalette.teal950,
    brandContainer: AppPalette.teal800,
    onBrandContainer: AppPalette.teal300,
    accent: AppPalette.mango300,
    onAccent: AppPalette.ink900,
    accentContainer: AppPalette.mango800,
    onAccentContainer: AppPalette.mango200,
    surface: AppPalette.night900,
    surfaceContainerLowest: AppPalette.night950,
    surfaceContainerLow: AppPalette.night850,
    surfaceContainer: AppPalette.night800,
    surfaceContainerHigh: AppPalette.night750,
    surfaceContainerHighest: AppPalette.night700,
    inverseSurface: AppPalette.ink100,
    onInverseSurface: AppPalette.night900,
    ink: AppPalette.ink100,
    inkMuted: AppPalette.ink300,
    outline: AppPalette.night500,
    outlineVariant: AppPalette.night600,
    income: AppPalette.green400,
    incomeFill: AppPalette.green400,
    incomeContainer: AppPalette.green900,
    onIncomeContainer: AppPalette.green200,
    expense: AppPalette.coral400,
    expenseFill: AppPalette.coral400,
    expenseContainer: AppPalette.coral900,
    onExpenseContainer: AppPalette.coral200,
    warning: AppPalette.amber400,
    warningFill: AppPalette.amber400,
    warningContainer: AppPalette.amber900,
    onWarningContainer: AppPalette.amber200,
    danger: AppPalette.red400,
    onDanger: AppPalette.night900,
    dangerContainer: AppPalette.red900,
    onDangerContainer: AppPalette.red200,
    scrim: AppPalette.black,
  );

  /// Pemetaan ke M3 agar widget Material bawaan ikut palet yang sama.
  ColorScheme toColorScheme(Brightness brightness) => ColorScheme(
    brightness: brightness,
    primary: brand,
    onPrimary: onBrand,
    primaryContainer: brandContainer,
    onPrimaryContainer: onBrandContainer,
    secondary: accent,
    onSecondary: onAccent,
    secondaryContainer: accentContainer,
    onSecondaryContainer: onAccentContainer,
    tertiary: income,
    onTertiary: surface,
    tertiaryContainer: incomeContainer,
    onTertiaryContainer: onIncomeContainer,
    error: danger,
    onError: onDanger,
    errorContainer: dangerContainer,
    onErrorContainer: onDangerContainer,
    surface: surface,
    onSurface: ink,
    onSurfaceVariant: inkMuted,
    surfaceDim: surfaceContainerHigh,
    surfaceBright: surfaceContainerLowest,
    surfaceContainerLowest: surfaceContainerLowest,
    surfaceContainerLow: surfaceContainerLow,
    surfaceContainer: surfaceContainer,
    surfaceContainerHigh: surfaceContainerHigh,
    surfaceContainerHighest: surfaceContainerHighest,
    outline: outline,
    outlineVariant: outlineVariant,
    shadow: AppPalette.black,
    scrim: scrim,
    inverseSurface: inverseSurface,
    onInverseSurface: onInverseSurface,
    inversePrimary: brightness == Brightness.light ? AppPalette.teal400 : AppPalette.teal700,
    surfaceTint: AppPalette.transparent,
  );

  @override
  AppColors copyWith({
    Color? brand,
    Color? onBrand,
    Color? brandContainer,
    Color? onBrandContainer,
    Color? accent,
    Color? onAccent,
    Color? accentContainer,
    Color? onAccentContainer,
    Color? surface,
    Color? surfaceContainerLowest,
    Color? surfaceContainerLow,
    Color? surfaceContainer,
    Color? surfaceContainerHigh,
    Color? surfaceContainerHighest,
    Color? inverseSurface,
    Color? onInverseSurface,
    Color? ink,
    Color? inkMuted,
    Color? outline,
    Color? outlineVariant,
    Color? income,
    Color? incomeFill,
    Color? incomeContainer,
    Color? onIncomeContainer,
    Color? expense,
    Color? expenseFill,
    Color? expenseContainer,
    Color? onExpenseContainer,
    Color? warning,
    Color? warningFill,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? danger,
    Color? onDanger,
    Color? dangerContainer,
    Color? onDangerContainer,
    Color? scrim,
  }) {
    return AppColors(
      brand: brand ?? this.brand,
      onBrand: onBrand ?? this.onBrand,
      brandContainer: brandContainer ?? this.brandContainer,
      onBrandContainer: onBrandContainer ?? this.onBrandContainer,
      accent: accent ?? this.accent,
      onAccent: onAccent ?? this.onAccent,
      accentContainer: accentContainer ?? this.accentContainer,
      onAccentContainer: onAccentContainer ?? this.onAccentContainer,
      surface: surface ?? this.surface,
      surfaceContainerLowest: surfaceContainerLowest ?? this.surfaceContainerLowest,
      surfaceContainerLow: surfaceContainerLow ?? this.surfaceContainerLow,
      surfaceContainer: surfaceContainer ?? this.surfaceContainer,
      surfaceContainerHigh: surfaceContainerHigh ?? this.surfaceContainerHigh,
      surfaceContainerHighest: surfaceContainerHighest ?? this.surfaceContainerHighest,
      inverseSurface: inverseSurface ?? this.inverseSurface,
      onInverseSurface: onInverseSurface ?? this.onInverseSurface,
      ink: ink ?? this.ink,
      inkMuted: inkMuted ?? this.inkMuted,
      outline: outline ?? this.outline,
      outlineVariant: outlineVariant ?? this.outlineVariant,
      income: income ?? this.income,
      incomeFill: incomeFill ?? this.incomeFill,
      incomeContainer: incomeContainer ?? this.incomeContainer,
      onIncomeContainer: onIncomeContainer ?? this.onIncomeContainer,
      expense: expense ?? this.expense,
      expenseFill: expenseFill ?? this.expenseFill,
      expenseContainer: expenseContainer ?? this.expenseContainer,
      onExpenseContainer: onExpenseContainer ?? this.onExpenseContainer,
      warning: warning ?? this.warning,
      warningFill: warningFill ?? this.warningFill,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      danger: danger ?? this.danger,
      onDanger: onDanger ?? this.onDanger,
      dangerContainer: dangerContainer ?? this.dangerContainer,
      onDangerContainer: onDangerContainer ?? this.onDangerContainer,
      scrim: scrim ?? this.scrim,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppColors(
      brand: l(brand, other.brand),
      onBrand: l(onBrand, other.onBrand),
      brandContainer: l(brandContainer, other.brandContainer),
      onBrandContainer: l(onBrandContainer, other.onBrandContainer),
      accent: l(accent, other.accent),
      onAccent: l(onAccent, other.onAccent),
      accentContainer: l(accentContainer, other.accentContainer),
      onAccentContainer: l(onAccentContainer, other.onAccentContainer),
      surface: l(surface, other.surface),
      surfaceContainerLowest: l(surfaceContainerLowest, other.surfaceContainerLowest),
      surfaceContainerLow: l(surfaceContainerLow, other.surfaceContainerLow),
      surfaceContainer: l(surfaceContainer, other.surfaceContainer),
      surfaceContainerHigh: l(surfaceContainerHigh, other.surfaceContainerHigh),
      surfaceContainerHighest: l(surfaceContainerHighest, other.surfaceContainerHighest),
      inverseSurface: l(inverseSurface, other.inverseSurface),
      onInverseSurface: l(onInverseSurface, other.onInverseSurface),
      ink: l(ink, other.ink),
      inkMuted: l(inkMuted, other.inkMuted),
      outline: l(outline, other.outline),
      outlineVariant: l(outlineVariant, other.outlineVariant),
      income: l(income, other.income),
      incomeFill: l(incomeFill, other.incomeFill),
      incomeContainer: l(incomeContainer, other.incomeContainer),
      onIncomeContainer: l(onIncomeContainer, other.onIncomeContainer),
      expense: l(expense, other.expense),
      expenseFill: l(expenseFill, other.expenseFill),
      expenseContainer: l(expenseContainer, other.expenseContainer),
      onExpenseContainer: l(onExpenseContainer, other.onExpenseContainer),
      warning: l(warning, other.warning),
      warningFill: l(warningFill, other.warningFill),
      warningContainer: l(warningContainer, other.warningContainer),
      onWarningContainer: l(onWarningContainer, other.onWarningContainer),
      danger: l(danger, other.danger),
      onDanger: l(onDanger, other.onDanger),
      dangerContainer: l(dangerContainer, other.dangerContainer),
      onDangerContainer: l(onDangerContainer, other.onDangerContainer),
      scrim: l(scrim, other.scrim),
    );
  }
}
