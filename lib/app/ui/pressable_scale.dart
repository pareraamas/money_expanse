import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Mengecilkan [child] ke [AppMotion.pressScale] saat ditekan.
/// Tanpa efek bila [enabled] false atau animasi sistem dimatikan.
class PressableScale extends StatefulWidget {
  const PressableScale({super.key, required this.child, this.enabled = true});

  final Widget child;
  final bool enabled;

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  bool _down = false;

  void _set(bool v) {
    if (_down != v) setState(() => _down = v);
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled || AppMotion.reduced(context)) return widget.child;
    return Listener(
      onPointerDown: (_) => _set(true),
      onPointerUp: (_) => _set(false),
      onPointerCancel: (_) => _set(false),
      child: AnimatedScale(
        scale: _down ? AppMotion.pressScale : 1,
        duration: AppMotion.short,
        curve: AppMotion.standard,
        child: widget.child,
      ),
    );
  }
}
