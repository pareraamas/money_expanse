@Tags(['qa', 'gerbang'])
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/harness.dart';
import 'support/screens.dart';

/// Teks 200% di HP kecil (360×640): tidak boleh ada overflow. Error overflow
/// dilaporkan framework dan otomatis menggagalkan test.
void main() {
  setUpAll(setUpQa);

  for (final screen in qaScreens) {
    testWidgets('teks 200% tanpa overflow: ${screen.name}', (tester) async {
      await pumpScreen(tester, screen, device: Device.small, textScale: 2);
      // Gulir sampai bawah agar konten di luar layar awal ikut di-layout.
      for (final s in find.byType(Scrollable).evaluate().toList()) {
        if (!s.mounted) continue;
        final state = (s as StatefulElement).state as ScrollableState;
        state.position.jumpTo(state.position.maxScrollExtent);
        await tester.pump();
      }
      await settle(tester);
      await drainTimers(tester);
    });
  }
}
