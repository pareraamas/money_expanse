import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wister_lite/app/theme/app_theme.dart';

double _contrast(Color a, Color b) {
  final la = a.computeLuminance(), lb = b.computeLuminance();
  final hi = la > lb ? la : lb, lo = la > lb ? lb : la;
  return (hi + 0.05) / (lo + 0.05);
}

void main() {
  for (final (name, c) in [('light', AppColors.light), ('dark', AppColors.dark)]) {
    group('kontras $name', () {
      final surfaces = {
        'surface': c.surface,
        'surfaceContainerLowest': c.surfaceContainerLowest,
        'surfaceContainerLow': c.surfaceContainerLow,
        'surfaceContainer': c.surfaceContainer,
        'surfaceContainerHigh': c.surfaceContainerHigh,
        'surfaceContainerHighest': c.surfaceContainerHighest,
      };
      final textColors = {
        'ink': c.ink,
        'inkMuted': c.inkMuted,
        'brand': c.brand,
        'income': c.income,
        'expense': c.expense,
        'warning': c.warning,
        'danger': c.danger,
      };

      for (final t in textColors.entries) {
        for (final s in surfaces.entries) {
          test('${t.key} di ${s.key} >= 4.5', () {
            expect(_contrast(t.value, s.value), greaterThanOrEqualTo(4.5));
          });
        }
      }

      final pairs = {
        'onBrand/brand': (c.onBrand, c.brand),
        'onBrandContainer/brandContainer': (c.onBrandContainer, c.brandContainer),
        'brand/brandContainer': (c.brand, c.brandContainer),
        'onAccent/accent': (c.onAccent, c.accent),
        'onAccentContainer/accentContainer': (c.onAccentContainer, c.accentContainer),
        'income/incomeContainer': (c.income, c.incomeContainer),
        'onIncomeContainer/incomeContainer': (c.onIncomeContainer, c.incomeContainer),
        'expense/expenseContainer': (c.expense, c.expenseContainer),
        'onExpenseContainer/expenseContainer': (c.onExpenseContainer, c.expenseContainer),
        'warning/warningContainer': (c.warning, c.warningContainer),
        'onWarningContainer/warningContainer': (c.onWarningContainer, c.warningContainer),
        'danger/dangerContainer': (c.danger, c.dangerContainer),
        'onDanger/danger': (c.onDanger, c.danger),
        'onDangerContainer/dangerContainer': (c.onDangerContainer, c.dangerContainer),
        'onInverseSurface/inverseSurface': (c.onInverseSurface, c.inverseSurface),
      };
      for (final p in pairs.entries) {
        test('${p.key} >= 4.5', () {
          expect(_contrast(p.value.$1, p.value.$2), greaterThanOrEqualTo(4.5));
        });
      }

      // Non-teks (WCAG 1.4.11): batas input & grafik minimal 3:1 di surface.
      test('outline di surface >= 3', () => expect(_contrast(c.outline, c.surface), greaterThanOrEqualTo(3)));
      test('incomeFill di surface >= 3', () => expect(_contrast(c.incomeFill, c.surface), greaterThanOrEqualTo(3)));
      test('expenseFill di surface >= 3', () => expect(_contrast(c.expenseFill, c.surface), greaterThanOrEqualTo(3)));
    });
  }

  test('tema light & dark terbentuk dengan extension', () {
    for (final t in [AppTheme.light(), AppTheme.dark()]) {
      expect(t.extension<AppColors>(), isNotNull);
      expect(t.extension<AppComponentTokens>(), isNotNull);
      expect(t.textTheme.bodyMedium!.fontFamily, AppTypography.fontFamily);
    }
    expect(AppTheme.dark().colorScheme.brightness, Brightness.dark);
  });

  test('tidak ada teks di bawah 12 sp', () {
    final t = AppTypography.textTheme;
    for (final s in [
      t.displayLarge, t.displayMedium, t.displaySmall, t.headlineLarge, t.headlineMedium, t.headlineSmall,
      t.titleLarge, t.titleMedium, t.titleSmall, t.bodyLarge, t.bodyMedium, t.bodySmall,
      t.labelLarge, t.labelMedium, t.labelSmall,
    ]) {
      expect(s!.fontSize, greaterThanOrEqualTo(12));
    }
  });
}
