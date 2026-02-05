import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class AnimatedBackground extends StatefulWidget {
  final Widget child;

  const AnimatedBackground({
    super.key,
    required this.child,
  });

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  static const _twoPi = pi * 2;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Stack(
      children: [
        const _BaseGradient(),
        LayoutBuilder(
          builder: (context, constraints) {
            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final t = _controller.value;
                final w = constraints.maxWidth;
                final h = constraints.maxHeight;

                final dx1 = sin(t * _twoPi) * 0.06;
                final dy1 = cos(t * _twoPi) * 0.05;
                final dx2 = cos(t * _twoPi) * 0.07;
                final dy2 = sin(t * _twoPi) * 0.06;
                final dx3 = sin((t + 0.35) * _twoPi) * 0.05;
                final dy3 = cos((t + 0.35) * _twoPi) * 0.05;

                return RepaintBoundary(
                  child: Stack(
                    children: [
                      Positioned(
                        left: w * (-0.15 + dx1),
                        top: h * (-0.18 + dy1),
                        child: _GlowBlob(
                          diameter: 520,
                          color: scheme.primary
                              .withAlpha(((isDark ? 0.20 : 0.12) * 255).round()),
                        ),
                      ),
                      Positioned(
                        right: w * (-0.12 + dx2),
                        top: h * (0.02 + dy2),
                        child: _GlowBlob(
                          diameter: 460,
                          color: scheme.secondary
                              .withAlpha(((isDark ? 0.16 : 0.10) * 255).round()),
                        ),
                      ),
                      Positioned(
                        left: w * (0.18 + dx3),
                        bottom: h * (-0.22 + dy3),
                        child: _GlowBlob(
                          diameter: 620,
                          color: scheme.primary
                              .withAlpha(((isDark ? 0.10 : 0.06) * 255).round()),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
        const _Vignette(),
        widget.child,
      ],
    );
  }
}

class _BaseGradient extends StatelessWidget {
  const _BaseGradient();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final background = theme.scaffoldBackgroundColor;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            background,
            Color.alphaBlend(
              scheme.primary.withAlpha((0.06 * 255).round()),
              background,
            ),
            background,
          ],
        ),
      ),
      child: const SizedBox.expand(),
    );
  }
}

class _Vignette extends StatelessWidget {
  const _Vignette();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final strength = isDark ? 0.40 : 0.14;

    return IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.15,
            colors: [
              Colors.transparent,
              Colors.black.withAlpha((strength * 255).round()),
            ],
            stops: const [0.0, 1.0],
          ),
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _GlowBlob extends StatelessWidget {
  final double diameter;
  final Color color;

  const _GlowBlob({
    required this.diameter,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
        child: Container(
          width: diameter,
          height: diameter,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
