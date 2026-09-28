import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wister_lite/app/theme/app_theme.dart';

Future<void> _loadFonts() async {
  final loader = FontLoader(AppTypography.fontFamily);
  for (final w in ['Regular', 'Medium', 'SemiBold', 'Bold', 'ExtraBold']) {
    final bytes = File('assets/fonts/PlusJakartaSans-$w.ttf').readAsBytesSync();
    loader.addFont(Future.value(ByteData.sublistView(bytes)));
  }
  await loader.load();
}

class _Preview extends StatelessWidget {
  const _Preview();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final t = context.text;
    final card = context.components.balanceCard;
    final bp = context.components.budgetProgress;
    return Scaffold(
      appBar: AppBar(title: const Text('Beranda'), actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.calendar_month))]),
      floatingActionButton: FloatingActionButton(onPressed: () {}, child: const Icon(Icons.add)),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.account_balance_wallet), label: 'Beranda'),
          NavigationDestination(icon: Icon(Icons.track_changes), label: 'Anggaran'),
          NavigationDestination(icon: Icon(Icons.donut_large), label: 'Statistik'),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.page),
        children: [
          Container(
            padding: EdgeInsets.all(card.padding),
            decoration: BoxDecoration(color: card.background, borderRadius: BorderRadius.circular(card.radius)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Saldo total', style: t.labelLarge?.copyWith(color: card.foregroundMuted)),
                Text('Rp 12.450.000', style: AppTypography.amountDisplay.copyWith(color: card.foreground)),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.stack),
          Row(
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.card),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Masuk', style: t.bodyMedium?.copyWith(color: c.inkMuted)),
                      Text('+Rp 8.000.000', style: AppTypography.amountMedium.copyWith(color: c.income)),
                    ]),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.stack),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.card),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('Keluar', style: t.bodyMedium?.copyWith(color: c.inkMuted)),
                      Text('−Rp 3.250.000', style: AppTypography.amountMedium.copyWith(color: c.expense)),
                    ]),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.section),
          Text('Anggaran', style: t.titleLarge),
          const SizedBox(height: AppSpacing.s8),
          for (final used in [0.45, 0.86, 1.1])
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.s8),
              child: ClipRRect(
                borderRadius: AppRadius.fullAll,
                child: LinearProgressIndicator(value: used.clamp(0, 1), color: bp.colorFor(used), backgroundColor: bp.track, minHeight: bp.height),
              ),
            ),
          Wrap(spacing: AppSpacing.s8, children: [
            FilterChip(label: const Text('Makan'), selected: true, onSelected: (_) {}),
            FilterChip(label: const Text('Transport'), selected: false, onSelected: (_) {}),
            Chip(label: Text('Over-budget', style: t.labelLarge?.copyWith(color: c.onDangerContainer)), backgroundColor: c.dangerContainer),
          ]),
          const SizedBox(height: AppSpacing.stack),
          const TextField(decoration: InputDecoration(labelText: 'Catatan', hintText: 'Opsional')),
          const SizedBox(height: AppSpacing.stack),
          SegmentedButton<int>(
            segments: const [ButtonSegment(value: 0, label: Text('Keluar')), ButtonSegment(value: 1, label: Text('Masuk'))],
            selected: const {0},
            onSelectionChanged: (_) {},
          ),
          const SizedBox(height: AppSpacing.stack),
          Row(children: [
            Expanded(child: OutlinedButton(onPressed: () {}, child: const Text('Batal'))),
            const SizedBox(width: AppSpacing.stack),
            Expanded(child: FilledButton(onPressed: () {}, child: const Text('Simpan'))),
          ]),
        ],
      ),
    );
  }
}

void main() {
  setUpAll(_loadFonts);

  for (final (name, theme) in [('light', AppTheme.light()), ('dark', AppTheme.dark())]) {
    testWidgets('pratinjau tema $name', (tester) async {
      tester.view.physicalSize = const Size(412 * 2, 915 * 2);
      tester.view.devicePixelRatio = 2;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(MaterialApp(debugShowCheckedModeBanner: false, theme: theme, home: const _Preview()));
      await expectLater(find.byType(_Preview), matchesGoldenFile('goldens/theme_preview_$name.png'));
    });
  }
}
