import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wister_lite/app/theme/app_theme.dart';

/// Memuat semua font dari FontManifest (Plus Jakarta Sans + font ikon
/// Phosphor dari package) agar golden menampilkan glyph asli.
Future<void> loadAppFonts() async {
  final manifest = json.decode(await rootBundle.loadString('FontManifest.json')) as List<dynamic>;
  for (final entry in manifest.cast<Map<String, dynamic>>()) {
    final loader = FontLoader(entry['family'] as String);
    for (final font in (entry['fonts'] as List<dynamic>).cast<Map<String, dynamic>>()) {
      loader.addFont(rootBundle.load(font['asset'] as String));
    }
    await loader.load();
  }
}

final themes = [('light', AppTheme.light()), ('dark', AppTheme.dark())];

/// Membungkus [child] di MaterialApp bertema, animasi dimatikan
/// (`disableAnimations`) agar golden deterministik.
Widget harness(Widget child, ThemeData theme, {bool reduced = true, bool scroll = false}) => MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: theme,
  builder: (context, app) => MediaQuery(
    data: MediaQuery.of(context).copyWith(disableAnimations: reduced),
    child: app!,
  ),
  home: Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(AppSpacing.page),
      child: scroll ? SingleChildScrollView(child: child) : child,
    ),
  ),
);

/// Pump [child], tunggu SVG selesai di-decode (isolate), lalu cocokkan golden.
Future<void> expectGolden(
  WidgetTester tester,
  Widget child, {
  required String name,
  required ThemeData theme,
  Size size = const Size(400, 300),
  bool settle = true,
}) async {
  tester.view.physicalSize = size * 2;
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(harness(child, theme));
  await waitForAssets(tester);
  if (settle) await tester.pumpAndSettle();
  await expectLater(find.byType(Scaffold), matchesGoldenFile('goldens/$name.png'));
}

/// SVG di-decode lewat `compute` (isolate nyata), jadi perlu waktu nyata.
Future<void> waitForAssets(WidgetTester tester) async {
  for (var i = 0; i < 3; i++) {
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 150)));
    await tester.pump();
  }
}
