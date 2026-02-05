import 'package:flutter/material.dart';

class PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool outlined;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.outlined = false,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _hovered = false;

  void _setHovered(bool value) {
    if (_hovered == value) return;
    setState(() => _hovered = value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final child = widget.icon == null
        ? Text(widget.label)
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon!, size: 18),
              const SizedBox(width: 10),
              Text(widget.label),
            ],
          );

    final enabled = widget.onPressed != null;
    final cursor = enabled ? SystemMouseCursors.click : SystemMouseCursors.basic;
    final scale = _hovered && enabled ? 1.03 : 1.0;

    if (widget.outlined) {
      final borderColor = _hovered
          ? scheme.primary.withAlpha((0.70 * 255).round())
          : theme.dividerColor.withAlpha((0.95 * 255).round());

      final backgroundColor =
          _hovered ? scheme.primary.withAlpha((0.10 * 255).round()) : Colors.transparent;

      return MouseRegion(
        cursor: cursor,
        onEnter: (_) => _setHovered(true),
        onExit: (_) => _setHovered(false),
        child: AnimatedScale(
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOutCubic,
          scale: scale,
          child: OutlinedButton(
            onPressed: widget.onPressed,
            style: OutlinedButton.styleFrom(
              backgroundColor: backgroundColor,
              side: BorderSide(color: borderColor),
            ),
            child: child,
          ),
        ),
      );
    }

    final hoverBackground = Color.alphaBlend(
      Colors.white.withAlpha((0.12 * 255).round()),
      scheme.primary,
    );

    return MouseRegion(
      cursor: cursor,
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOutCubic,
        scale: scale,
        child: ElevatedButton(
          onPressed: widget.onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: _hovered ? hoverBackground : scheme.primary,
            elevation: _hovered ? 10 : 0,
            shadowColor: Colors.black.withAlpha((0.35 * 255).round()),
          ),
          child: child,
        ),
      ),
    );
  }
}
