import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'transaction_export.dart';

/// Membagikan file lewat share sheet sistem (WhatsApp, Instagram, Drive,
/// "Simpan ke File", dll.). File ditulis ke direktori sementara, jadi tidak
/// butuh izin penyimpanan.
///
/// [origin] adalah posisi tombol pemicu; wajib di iPad agar popover punya jangkar.
class ShareService {
  Future<ShareResultStatus> shareExport(ExportFile file, {Rect? origin}) => _share([(file.bytes, file.fileName, file.mimeType)], origin: origin);

  /// Beberapa PNG sekaligus; Instagram menjadikannya satu carousel.
  Future<ShareResultStatus> shareImages(List<(Uint8List, String)> images, {Rect? origin}) =>
      _share([for (final (bytes, name) in images) (bytes, name, 'image/png')], origin: origin);

  Future<ShareResultStatus> _share(List<(Uint8List, String, String)> files, {Rect? origin}) async {
    final dir = await getTemporaryDirectory();
    final xFiles = <XFile>[];
    for (final (bytes, name, mimeType) in files) {
      // Tulis sebagai byte agar BOM & CRLF CSV tidak diubah.
      final file = await File(p.join(dir.path, name)).writeAsBytes(bytes, flush: true);
      xFiles.add(XFile(file.path, mimeType: mimeType));
    }
    final result = await SharePlus.instance.share(ShareParams(files: xFiles, sharePositionOrigin: origin));
    return result.status;
  }
}
