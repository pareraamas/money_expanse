import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';

/// Header bersama tiga halaman utama (Beranda, Anggaran, Statistik).
///
/// Judul dan aksi selalu satu baris. Di puncak judul besar (headlineMedium),
/// saat di-scroll menyusut ke titleLarge dan tetap lengket. Latar berganti ke
/// surfaceContainerLow begitu konten lewat di bawahnya.
class PageAppBar extends StatelessWidget {
  const PageAppBar({super.key, required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  static const _collapsed = 56.0;
  static const _expanded = 80.0;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _Delegate(title: title, trailing: trailing, topPadding: MediaQuery.paddingOf(context).top),
    );
  }
}

class _Delegate extends SliverPersistentHeaderDelegate {
  _Delegate({required this.title, required this.trailing, required this.topPadding});

  final String title;
  final Widget? trailing;
  final double topPadding;

  @override
  double get minExtent => topPadding + PageAppBar._collapsed;

  @override
  double get maxExtent => topPadding + PageAppBar._expanded;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final c = context.colors;
    final range = maxExtent - minExtent;
    final t = (shrinkOffset / range).clamp(0.0, 1.0);
    final scrolledUnder = overlapsContent || shrinkOffset > range;
    final style = TextStyle.lerp(context.text.headlineMedium, context.text.titleLarge, t)?.copyWith(color: c.ink);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppTheme.overlayStyle(Theme.of(context).brightness),
      child: AnimatedContainer(
        duration: AppMotion.of(context, AppMotion.short),
        color: scrolledUnder ? c.surfaceContainerLow : c.surface,
        alignment: AlignmentDirectional.centerStart,
        padding: EdgeInsets.fromLTRB(AppSpacing.page, topPadding, AppSpacing.page, 0),
        child: Row(
          children: [
            Expanded(
              child: Semantics(
                header: true,
                child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: style),
              ),
            ),
            if (trailing != null) ...[const SizedBox(width: AppSpacing.s8), trailing!],
          ],
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_Delegate old) => old.title != title || old.trailing != trailing || old.topPadding != topPadding;
}
