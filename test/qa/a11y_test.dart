@Tags(['qa', 'gerbang'])
library;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/harness.dart';
import 'support/screens.dart';

/// Ukuran font terkecil (sebelum skala teks) di semua teks yang tampil.
List<String> _textsBelow(WidgetTester tester, double minSize) {
  final small = <String>{};
  void walk(InlineSpan span, TextStyle? inherited) {
    final style = inherited?.merge(span.style) ?? span.style;
    if (span is TextSpan) {
      final text = span.text?.trim() ?? '';
      final size = style?.fontSize ?? 14;
      if (text.isNotEmpty && size < minSize) small.add('"$text" ${size}sp');
      for (final c in span.children ?? const <InlineSpan>[]) {
        walk(c, style);
      }
    }
  }

  for (final e in find.byType(RichText).evaluate()) {
    final render = e.renderObject as RenderParagraph?;
    if (render == null || !render.attached || render.size.isEmpty) continue;
    // Font ikon (MaterialIcons, Phosphor) bukan teks bacaan.
    final root = (e.widget as RichText).text;
    final family = root.style?.fontFamily ?? '';
    if (family.contains('Icons') || family.contains('Phosphor')) continue;
    walk(root, null);
  }
  return small.toList();
}

double _ratio(Color a, Color b) {
  final la = a.computeLuminance(), lb = b.computeLuminance();
  return (la > lb ? la + 0.05 : lb + 0.05) / (la > lb ? lb + 0.05 : la + 0.05);
}

Color _over(Color top, Color bottom) => Color.alphaBlend(top, bottom);

/// Warna latar efektif di belakang [node]: naik di render tree dan
/// menumpuk warna DecoratedBox / Material (PhysicalShape/Model) sampai opak.
Color _backgroundOf(RenderObject node, Color fallback) {
  final layers = <Color>[];
  for (RenderObject? r = node.parent; r != null; r = r.parent) {
    Color? color;
    if (r is RenderDecoratedBox && r.decoration is BoxDecoration && r.position == DecorationPosition.background) {
      color = (r.decoration as BoxDecoration).color;
    } else if (r is RenderPhysicalShape) {
      color = r.color;
    } else if (r is RenderPhysicalModel) {
      color = r.color;
    }
    if (color == null || color.a == 0) continue;
    layers.add(color);
    if (color.a >= 1) break;
  }
  return layers.reversed.fold(fallback, (bg, c) => _over(c, bg));
}

/// Kontras dari warna token yang benar-benar dipakai (bukan sampel piksel).
/// Guideline bawaan Flutter mengambil piksel screenshot, sehingga gagal palsu
/// pada teks tipis 12 sp dan pada teks yang tergulir di bawah FAB.
/// Teks besar (>= 18 sp, atau >= 14 sp tebal) cukup 3:1 sesuai WCAG.
List<String> _contrastViolations(WidgetTester tester) {
  final bad = <String>{};
  final page = Theme.of(tester.element(find.byType(Scaffold).last)).colorScheme.surface;
  for (final e in find.byType(RichText).hitTestable().evaluate()) {
    final render = e.renderObject! as RenderParagraph;
    final root = (e.widget as RichText).text;
    final family = root.style?.fontFamily ?? '';
    if (family.contains('Icons') || family.contains('Phosphor')) continue;
    final bg = _backgroundOf(render, page);
    void walk(InlineSpan span, TextStyle? inherited) {
      final style = inherited?.merge(span.style) ?? span.style;
      if (span is TextSpan) {
        final text = span.text?.trim() ?? '';
        final color = style?.foreground?.color ?? style?.color;
        if (text.isNotEmpty && color != null) {
          final size = style?.fontSize ?? 14;
          final bold = (style?.fontWeight ?? FontWeight.normal).value >= 700;
          final min = size >= 18 || (bold && size >= 14) ? 3.0 : 4.5;
          final r = _ratio(_over(color, bg), bg);
          if (r < min) bad.add('"$text" ${r.toStringAsFixed(2)}:1 (min $min)');
        }
        for (final c in span.children ?? const <InlineSpan>[]) {
          walk(c, style);
        }
      }
    }

    walk(root, null);
  }
  return bad.toList();
}

/// Gerbang a11y: target sentuh 48dp, setiap tap target berlabel semantik,
/// kontras teks AA, dan tidak ada teks di bawah 12 sp.
void main() {
  setUpAll(setUpQa);

  for (final screen in qaScreens) {
    for (final b in Brightness.values) {
      group('a11y ${describe(screen, b)}', () {
        testWidgets('target sentuh >= 48dp', (tester) async {
          final handle = tester.ensureSemantics();
          await pumpScreen(tester, screen, brightness: b);
          await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
          await drainTimers(tester);
          handle.dispose();
        });

        testWidgets('tap target punya label', (tester) async {
          final handle = tester.ensureSemantics();
          await pumpScreen(tester, screen, brightness: b);
          await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
          await drainTimers(tester);
          handle.dispose();
        });

        testWidgets('kontras teks AA', (tester) async {
          await pumpScreen(tester, screen, brightness: b);
          final bad = _contrastViolations(tester);
          expect(bad, isEmpty, reason: bad.join('\n'));
          await drainTimers(tester);
        });

        if (b == Brightness.light) {
          testWidgets('tidak ada teks di bawah 12 sp', (tester) async {
            await pumpScreen(tester, screen, brightness: b);
            final small = _textsBelow(tester, 12);
            expect(small, isEmpty, reason: small.join('\n'));
            await drainTimers(tester);
          });
        }
      });
    }
  }
}
