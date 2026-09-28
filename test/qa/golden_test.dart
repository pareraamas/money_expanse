@Tags(['qa', 'golden'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/harness.dart';
import 'support/screens.dart';

/// Golden semua layar di light & dark. Setelah perubahan UI yang disengaja:
/// `flutter test test/qa/golden_test.dart --update-goldens`, lalu review PNG
/// di test/qa/goldens/ sebagai screenshot sebelum/sesudah di PR.
void main() {
  setUpAll(setUpQa);

  for (final screen in qaScreens.where((s) => s.golden)) {
    for (final b in Brightness.values) {
      testWidgets('golden ${describe(screen, b)}', (tester) async {
        await pumpScreen(tester, screen, brightness: b);
        await expectLater(find.byType(MaterialApp), matchesGoldenFile('goldens/${screen.name}_${b.name}.png'));
        await drainTimers(tester);
      });
    }
  }
}
