import 'package:flutter/widgets.dart';

class HoverScale extends StatefulWidget {
  final Widget child;
  final double scale;
  final Duration duration;
  final Curve curve;
  final bool enabled;
  final MouseCursor cursor;

  const HoverScale({
    super.key,
    required this.child,
    this.scale = 1.03,
    this.duration = const Duration(milliseconds: 140),
    this.curve = Curves.easeOutCubic,
    this.enabled = true,
    this.cursor = SystemMouseCursors.basic,
  });

  @override
  State<HoverScale> createState() => _HoverScaleState();
}

class _HoverScaleState extends State<HoverScale> {
  bool _hovered = false;

  void _setHovered(bool value) {
    if (_hovered == value) return;
    setState(() => _hovered = value);
  }

  @override
  Widget build(BuildContext context) {
    final scaled = AnimatedScale(
      scale: _hovered ? widget.scale : 1,
      duration: widget.duration,
      curve: widget.curve,
      child: widget.child,
    );

    if (!widget.enabled) return scaled;

    return MouseRegion(
      cursor: widget.cursor,
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      child: scaled,
    );
  }
}
