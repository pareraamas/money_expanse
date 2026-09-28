import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_theme.dart';

enum CategoryBlobSize { small, medium, large }

/// Ikon kategori di wadah "blob" tonal (warna kategori 15%).
///
/// Bentuk blob sedikit organik, tidak bulat sempurna, dan variasinya
/// ditentukan dari [iconAsset] sehingga stabil untuk kategori yang sama.
class CategoryBlob extends StatelessWidget {
  const CategoryBlob({
    super.key,
    required this.iconAsset,
    required this.color,
    this.size = CategoryBlobSize.medium,
    this.semanticLabel,
  });

  /// Path SVG ikon kategori (`Category.icon`), mis. `assets/uil_gift.svg`.
  final String iconAsset;

  /// Warna kategori (`Category.color`).
  final Color color;
  final CategoryBlobSize size;

  /// Nama kategori untuk screen reader. Null = dekoratif (label sudah ada di dekatnya).
  final String? semanticLabel;

  static double dimensionOf(CategoryBlobTokens t, CategoryBlobSize size) => switch (size) {
    CategoryBlobSize.small => t.sizeSmall,
    CategoryBlobSize.medium => t.sizeMedium,
    CategoryBlobSize.large => t.sizeLarge,
  };

  @override
  Widget build(BuildContext context) {
    final t = context.components.categoryBlob;
    final d = dimensionOf(t, size);
    final icon = d * t.iconScale;
    final seed = iconAsset.codeUnits.fold<int>(0, (a, b) => (a * 31 + b) & 0x7fffffff);

    final blob = CustomPaint(
      painter: BlobPainter(color: t.tint(color), seed: seed),
      child: SizedBox.square(
        dimension: d,
        child: Center(
          child: SvgPicture.asset(
            iconAsset,
            width: icon,
            height: icon,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            excludeFromSemantics: true,
            placeholderBuilder: (_) => SizedBox.square(dimension: icon),
            errorBuilder: (_, _, _) => SizedBox.square(dimension: icon),
          ),
        ),
      ),
    );

    if (semanticLabel == null) return ExcludeSemantics(child: blob);
    return Semantics(label: semanticLabel, image: true, excludeSemantics: true, child: blob);
  }
}

/// Melukis blob organik: 8 titik di sekeliling lingkaran dengan jari-jari
/// sedikit bervariasi, dihaluskan dengan kurva Catmull-Rom.
class BlobPainter extends CustomPainter {
  const BlobPainter({required this.color, this.seed = 0});

  final Color color;
  final int seed;

  static const _variants = [
    [1.0, 0.95, 0.99, 0.94, 1.0, 0.96, 0.98, 0.93],
    [0.97, 1.0, 0.94, 0.99, 0.95, 1.0, 0.93, 0.98],
    [0.99, 0.94, 1.0, 0.96, 0.97, 0.93, 1.0, 0.95],
  ];

  static Path pathFor(Size size, int seed) {
    final radii = _variants[seed % _variants.length];
    final n = radii.length;
    final c = size.center(Offset.zero);
    final r = size.shortestSide / 2;
    final rot = (seed % 7) * math.pi / 14;
    final pts = [
      for (var i = 0; i < n; i++)
        c + Offset.fromDirection(rot + i * 2 * math.pi / n, r * radii[i]),
    ];
    final path = Path()..moveTo(pts[0].dx, pts[0].dy);
    for (var i = 0; i < n; i++) {
      final p0 = pts[(i - 1 + n) % n], p1 = pts[i], p2 = pts[(i + 1) % n], p3 = pts[(i + 2) % n];
      final c1 = p1 + (p2 - p0) / 6;
      final c2 = p2 - (p3 - p1) / 6;
      path.cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, p2.dx, p2.dy);
    }
    return path..close();
  }

  @override
  void paint(Canvas canvas, Size size) => canvas.drawPath(pathFor(size, seed), Paint()..color = color);

  @override
  bool shouldRepaint(BlobPainter oldDelegate) => oldDelegate.color != color || oldDelegate.seed != seed;
}
