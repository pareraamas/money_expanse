import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:money_expense/app/ui/ui.dart';

import 'golden_helpers.dart';

ShareSummaryData _data(int budgets) => ShareSummaryData(
  month: DateTime(2026, 9),
  income: 12500000,
  expense: 9800000,
  categories: const [ShareCardSlice(label: 'Makan', amount: 3200000, color: Colors.orange)],
  budgets: [
    for (var i = 0; i < budgets; i++)
      ShareCardBudget(label: 'Kategori anggaran panjang $i', color: Colors.teal, spent: 1250000.0 + i * 1000, limit: 1500000),
  ],
);

void main() {
  test('slide anggaran bertambah tiap 6 anggaran', () {
    expect(ShareFeedSlide.countFor(_data(0)), 3);
    expect(ShareFeedSlide.countFor(_data(1)), 4);
    expect(ShareFeedSlide.countFor(_data(6)), 4);
    expect(ShareFeedSlide.countFor(_data(7)), 5);
    expect(ShareFeedSlide.countFor(_data(13)), 6);
  });

  testWidgets('6 anggaran per slide muat tanpa overflow', (tester) async {
    await loadAppFonts();
    final data = _data(13);
    for (final (_, theme) in themes) {
      for (var i = 3; i < ShareFeedSlide.countFor(data); i++) {
        for (final hide in [false, true]) {
          await tester.pumpWidget(harness(Center(child: FittedBox(child: ShareFeedSlide(data: data, index: i, hideAmounts: hide))), theme));
          await tester.pump();
          expect(tester.takeException(), isNull);
        }
      }
    }
    await tester.pumpWidget(harness(Center(child: ShareFeedSlide(data: data, index: 3)), themes.first.$2));
    expect(find.textContaining('Kategori anggaran panjang'), findsNWidgets(6));
    expect(find.text('Rp 1,3jt / 1,5jt'), findsWidgets);
  });
}
