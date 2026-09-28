@Tags(['qa', 'gerbang'])
library;

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:wister_lite/app/data/services/share_service.dart';
import 'package:wister_lite/app/modules/share_card/controllers/share_card_controller.dart';
import 'package:wister_lite/app/modules/share_card/views/share_card_view.dart';
import 'package:wister_lite/app/routes/app_pages.dart';
import 'package:wister_lite/app/ui/ui.dart';
import 'package:share_plus/share_plus.dart';

import 'support/harness.dart';

class _RecordingShare extends ShareService {
  final shared = <(Uint8List, String)>[];

  @override
  Future<ShareResultStatus> shareImages(List<(Uint8List, String)> images, {Rect? origin}) async {
    shared.addAll(images);
    return ShareResultStatus.success;
  }
}

/// Lebar & tinggi dari header IHDR PNG.
(int, int) _pngSize(Uint8List png) {
  final d = ByteData.sublistView(png);
  return (d.getUint32(16), d.getUint32(20));
}

/// Gambar yang benar-benar dibagikan: semua slide Feed (termasuk yang di luar
/// layar pratinjau) dan Story, di resolusi ekspor.
/// `QA_DUMP_DIR=/tmp/x flutter test test/qa/share_card_capture_test.dart` menyimpan PNG-nya.
void main() {
  setUpAll(setUpQa);

  for (final format in ShareCardFormat.values) {
    testWidgets('bagikan ${format.name}: semua gambar 1080 px', (tester) async {
      await pumpScreen(tester, QaScreen('bagikan-gambar', route: Routes.SHARE_CARD, arguments: DateTime(2026, 9)));
      final recorder = _RecordingShare();
      Get.put<ShareService>(recorder);
      final controller = Get.find<ShareCardController>();
      controller.format.value = format;
      await tester.pumpAndSettle();
      await tester.runAsync(() => ShareAppMark.precache(tester.element(find.byType(ShareCardView))));
      await tester.pumpAndSettle();

      await tester.runAsync(() => controller.share());

      final expected = format == ShareCardFormat.story ? 1 : 4; // data contoh punya anggaran → 4 slide
      expect(recorder.shared, hasLength(expected));
      for (final (png, name) in recorder.shared) {
        expect(_pngSize(png), (1080, (1080 * format.size.height / format.size.width).round()), reason: name);
      }
      final dump = Platform.environment['QA_DUMP_DIR'];
      if (dump != null) {
        for (final (png, name) in recorder.shared) {
          File('$dump/$name').writeAsBytesSync(png);
        }
      }
      await drainTimers(tester);
    });
  }
}
