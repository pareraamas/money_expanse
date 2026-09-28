@Tags(['qa', 'gerbang'])
library;

import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:wister_lite/app/theme/app_theme.dart';

double _ratio(Color fg, Color bg) {
  final f = Color.alphaBlend(fg, bg);
  final la = f.computeLuminance(), lb = bg.computeLuminance();
  return (la > lb ? la + 0.05 : lb + 0.05) / (la > lb ? lb + 0.05 : la + 0.05);
}

/// Pasangan warna di token komponen (lapis 3) yang tidak dicakup
/// test/theme/contrast_test.dart. Warna ber-alpha di-blend dulu ke latarnya.
void main() {
  for (final (name, theme) in [('light', AppTheme.light()), ('dark', AppTheme.dark())]) {
    final c = theme.extension<AppColors>()!;
    final k = theme.extension<AppComponentTokens>()!;
    group('token komponen $name', () {
      final text = {
        'balanceCard.foreground': (k.balanceCard.foreground, k.balanceCard.background),
        'balanceCard.foregroundMuted': (k.balanceCard.foregroundMuted, k.balanceCard.background),
        'keypad.foreground': (k.keypadKey.foreground, k.keypadKey.background),
        'keypad.actionForeground': (k.keypadKey.actionForeground, k.keypadKey.background),
        'amount.income di surface': (k.amountText.income, c.surface),
        'amount.expense di surface': (k.amountText.expense, c.surface),
        'amount.neutral di surface': (k.amountText.neutral, c.surface),
      };
      for (final e in text.entries) {
        test('${e.key} >= 4.5', () => expect(_ratio(e.value.$1, e.value.$2), greaterThanOrEqualTo(4.5)));
      }
      // Non-teks (WCAG 1.4.11): isian bar & penanda pace di track.
      final bar = k.budgetProgress;
      final fills = {'safe': bar.safe, 'warning': bar.warning, 'danger': bar.danger, 'paceMarker': bar.paceMarker};
      for (final e in fills.entries) {
        test('budgetProgress.${e.key} di track >= 3', () => expect(_ratio(e.value, Color.alphaBlend(bar.track, c.surface)), greaterThanOrEqualTo(3)));
      }
    });
  }
}
