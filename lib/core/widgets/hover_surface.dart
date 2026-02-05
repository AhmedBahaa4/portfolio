import 'package:flutter/material.dart';

class HoverSurface extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry borderRadius;
  final bool enabled;
  final double lift;
  final double scale;
  final Duration duration;
  final Curve curve;

  const HoverSurface({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.borderRadius = const BorderRadius.all(Radius.circular(18)),
    this.enabled = true,
    this.lift = 6,
    this.scale = 1.01,
    this.duration = const Duration(milliseconds: 160),
    this.curve = Curves.easeOutCubic,
  });

  @override
  State<HoverSurface> createState() => _HoverSurfaceState();
}

class _HoverSurfaceState extends State<HoverSurface> {
  bool _hovered = false;

  void _setHovered(bool value) {
    if (_hovered == value) return;
    setState(() => _hovered = value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final backgroundColor =
        (theme.cardTheme.color ?? scheme.surface).withAlpha((0.92 * 255).round());
    final borderColor = _hovered
        ? scheme.primary.withAlpha((0.35 * 255).round())
        : theme.dividerColor.withAlpha((0.95 * 255).round());

    final shadow = BoxShadow(
      color: Colors.black
          .withAlpha(((_hovered ? 0.36 : 0.22) * 255).round()),
      blurRadius: _hovered ? 26 : 16,
      spreadRadius: -2,
      offset: Offset(0, _hovered ? 14 : 10),
    );

    final scale = _hovered ? widget.scale : 1.0;
    final lift = _hovered ? -widget.lift : 0.0;
    final transform = Matrix4.translationValues(0.0, lift, 0.0)
      ..multiply(Matrix4.diagonal3Values(scale, scale, 1.0));

    final content = AnimatedContainer(
      duration: widget.duration,
      curve: widget.curve,
      transform: transform,
      transformAlignment: Alignment.center,
      padding: widget.padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: widget.borderRadius,
        border: Border.all(color: borderColor),
        boxShadow: [shadow],
      ),
      child: widget.child,
    );

    if (!widget.enabled) return content;

    return MouseRegion(
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      child: content,
    );
  }
}
