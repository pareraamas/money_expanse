import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wister_lite/app/theme/app_theme.dart';
import 'package:wister_lite/app/ui/gallery/component_gallery_page.dart';
import 'package:wister_lite/app/ui/ui.dart';

import 'golden_helpers.dart';

void main() {
  group('AmountKeypad.apply', () {
    int run(List<KeypadInput> inputs, {int start = 0, int maxDigits = 12}) =>
        inputs.fold(start, (v, i) => AmountKeypad.apply(v, i, maxDigits: maxDigits));

    test('digit ditambahkan di kanan', () {
      expect(run(const [KeypadDigit(2), KeypadDigit(5)]), 25);
    });

    test('0 di awal diabaikan', () {
      expect(run(const [KeypadDigit(0), KeypadDigit(0), KeypadDigit(7)]), 7);
    });

    test('000 mengalikan 1000, tidak berefek saat 0', () {
      expect(run(const [KeypadDigit(2), KeypadDigit(5), KeypadTripleZero()]), 25000);
      expect(run(const [KeypadTripleZero()]), 0);
    });

    test('backspace membuang digit terakhir, clear mengosongkan', () {
      expect(run(const [KeypadBackspace()], start: 25000), 2500);
      expect(run(const [KeypadBackspace()], start: 7), 0);
      expect(run(const [KeypadBackspace()], start: 0), 0);
      expect(run(const [KeypadClear()], start: 987654), 0);
    });

    test('batas digit maksimum', () {
      expect(run(const [KeypadDigit(9)], start: 12345, maxDigits: 5), 12345);
      expect(run(const [KeypadTripleZero()], start: 123, maxDigits: 5), 12300);
      expect(run(const [KeypadTripleZero()], start: 999999999999), 999999999999);
    });
  });

  testWidgets('AmountKeypad memanggil onChanged dari tombol', (tester) async {
    var value = 0;
    await tester.pumpWidget(
      StatefulBuilder(
        builder: (context, setState) => harness(
          AmountKeypad(value: value, haptics: false, onChanged: (v) => setState(() => value = v)),
          AppTheme.light(),
        ),
      ),
    );
    await tester.tap(find.text('2'));
    await tester.pump();
    await tester.tap(find.text('5'));
    await tester.pump();
    await tester.tap(find.text('000'));
    await tester.pump();
    expect(value, 25000);
    await tester.tap(find.bySemanticsLabel('Hapus digit'));
    await tester.pump();
    expect(value, 2500);
    await tester.longPress(find.bySemanticsLabel('Hapus digit'));
    await tester.pump();
    expect(value, 0);

    // Target sentuh minimal 56 dp.
    expect(tester.getSize(find.ancestor(of: find.text('1'), matching: find.byType(InkWell))).height, greaterThanOrEqualTo(56));
  });

  group('AmountText', () {
    test('format dengan tanda wajib', () {
      expect(AmountText.format(25000, AmountKind.income), '+Rp 25.000');
      expect(AmountText.format(25000, AmountKind.expense), '−Rp 25.000');
      expect(AmountText.format(-25000, AmountKind.expense), '−Rp 25.000');
      expect(AmountText.format(1250000, AmountKind.neutral), 'Rp 1.250.000');
      expect(AmountText.format(-50000, AmountKind.neutral), '−Rp 50.000');
      expect(AmountText.format(24999.6, AmountKind.neutral), 'Rp 25.000');
    });

    testWidgets('label semantik dan warna', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        harness(
          const Column(
            children: [
              AmountText(25000, kind: AmountKind.income),
              AmountText(30000, kind: AmountKind.expense),
              AmountText(-5000),
            ],
          ),
          AppTheme.light(),
        ),
      );
      expect(find.bySemanticsLabel('Pemasukan 25.000 rupiah'), findsOneWidget);
      expect(find.bySemanticsLabel('Pengeluaran 30.000 rupiah'), findsOneWidget);
      expect(find.bySemanticsLabel('minus 5.000 rupiah'), findsOneWidget);

      final income = tester.widget<Text>(find.text('+Rp 25.000'));
      final expense = tester.widget<Text>(find.text('−Rp 30.000'));
      expect(income.style?.color, AppColors.light.income);
      expect(expense.style?.color, AppColors.light.expense);
      expect(income.style?.fontFeatures, AppTypography.tabular);
      handle.dispose();
    });
  });

  group('BudgetProgress', () {
    final tok = AppComponentTokens.from(AppColors.light).budgetProgress;

    test('ambang status: aman < 80% ≤ hampir habis ≤ 100% < lewat', () {
      expect(BudgetProgress.statusOf(0.5), BudgetStatus.safe);
      expect(BudgetProgress.statusOf(0.79), BudgetStatus.safe);
      expect(BudgetProgress.statusOf(0.8), BudgetStatus.warning);
      expect(BudgetProgress.statusOf(1.0), BudgetStatus.warning);
      expect(BudgetProgress.statusOf(1.01), BudgetStatus.over);
      expect(BudgetProgress.ratioOf(100, 0), double.infinity);
      expect(BudgetProgress.ratioOf(0, 0), 0);
    });

    test('pace dari tanggal', () {
      expect(BudgetProgress.paceOf(DateTime(2026, 9, 15)), 0.5);
      expect(BudgetProgress.paceOf(DateTime(2026, 2, 28)), 1);
    });

    for (final (ratio, expected) in [(0.5, tok.safe), (0.86, tok.warning), (1.2, tok.danger)]) {
      testWidgets('warna bar untuk rasio $ratio', (tester) async {
        await tester.pumpWidget(harness(BudgetProgress(ratio: ratio, label: 'Makan', pace: 0.5), AppTheme.light()));
        await tester.pumpAndSettle();
        final fill = tester.widget<AnimatedContainer>(find.byKey(BudgetProgress.fillKey));
        expect((fill.decoration! as BoxDecoration).color, expected);
      });
    }

    testWidgets('status teks + semantik saat lewat anggaran', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        harness(BudgetProgress.fromAmounts(label: 'Belanja', used: 620000, budget: 500000), AppTheme.light()),
      );
      await tester.pumpAndSettle();
      expect(find.text('Lewat Rp 120.000'), findsOneWidget);
      expect(find.text('124%'), findsOneWidget);
      expect(
        find.bySemanticsLabel(RegExp('Belanja, terpakai 620.000 dari 500.000 rupiah, 124 persen, lewat anggaran')),
        findsOneWidget,
      );
      handle.dispose();
    });
  });

  testWidgets('MonthSwitcher menampilkan bulan Indonesia dan memanggil callback', (tester) async {
    var prev = 0, next = 0;
    await tester.pumpWidget(
      harness(MonthSwitcher(month: DateTime(2026, 9), onPrev: () => prev++, onNext: () => next++), AppTheme.light()),
    );
    expect(find.text('September 2026'), findsOneWidget);
    await tester.tap(find.byTooltip('Bulan sebelumnya'));
    await tester.tap(find.byTooltip('Bulan berikutnya'));
    expect((prev, next), (1, 1));
  });

  testWidgets('ConfirmDialog.show mengembalikan true/false', (tester) async {
    late BuildContext ctx;
    await tester.pumpWidget(
      harness(
        Builder(
          builder: (context) {
            ctx = context;
            return const SizedBox();
          },
        ),
        AppTheme.light(),
      ),
    );
    var result = ConfirmDialog.show(ctx, title: 'Hapus?', message: 'Yakin?');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Hapus'));
    await tester.pumpAndSettle();
    expect(await result, isTrue);

    result = ConfirmDialog.show(ctx, title: 'Hapus?', message: 'Yakin?');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Batal'));
    await tester.pumpAndSettle();
    expect(await result, isFalse);
  });

  testWidgets('TransactionTile geser hapus memakai konfirmasi', (tester) async {
    var deleted = 0;
    var confirm = false;
    await tester.pumpWidget(
      harness(
        TransactionTile(
          title: 'Kopi',
          amount: 18000,
          kind: AmountKind.expense,
          categoryIcon: CategoryIcons.pizzaSlice,
          categoryColor: AppColors.light.expense,
          dismissKey: const ValueKey('t1'),
          confirmDelete: () async => confirm,
          onDelete: () => deleted++,
        ),
        AppTheme.light(),
      ),
    );
    await tester.drag(find.text('Kopi'), const Offset(-500, 0));
    await tester.pumpAndSettle();
    expect(deleted, 0);
    confirm = true;
    await tester.drag(find.text('Kopi'), const Offset(-500, 0));
    await tester.pumpAndSettle();
    expect(deleted, 1);
  });

  testWidgets('BalanceCard count-up berakhir di nilai akhir', (tester) async {
    await tester.pumpWidget(harness(const BalanceCard(amount: 125000), AppTheme.light(), reduced: false));
    await tester.pump(AppMotion.countUp ~/ 2);
    expect(find.text('Rp 125.000'), findsNothing);
    await tester.pumpAndSettle();
    expect(find.text('Rp 125.000'), findsOneWidget);
    expect(find.text('Saldo total'), findsOneWidget);
  });

  testWidgets('Animasi shimmer & empty state berjalan tanpa error', (tester) async {
    await tester.pumpWidget(
      harness(Column(children: [const SkeletonList(itemCount: 2), EmptyState.kategori()]), AppTheme.light(), reduced: false),
    );
    await tester.pump(SkeletonList.period);
    await tester.pump(SkeletonList.period);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('Gallery dapat dibangun di light & dark', (tester) async {
    tester.view.physicalSize = const Size(412 * 2, 915 * 2);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        builder: (context, child) => MediaQuery(data: MediaQuery.of(context).copyWith(disableAnimations: true), child: child!),
        home: const ComponentGalleryPage(),
      ),
    );
    await tester.pump();
    await tester.tap(find.byTooltip('Mode gelap'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.byTooltip('Mode terang'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
