import 'package:flutter/material.dart';

import '../../../../core/utils/download.dart';
import '../../../../core/utils/launch.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/fade_slide_in.dart';
import '../../../../core/widgets/hover_scale.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/entities/portfolio.dart';

class HeroHeader extends StatelessWidget {
  final Portfolio portfolio;
  final VoidCallback onTapProjects;
  final VoidCallback onTapContact;

  const HeroHeader({
    super.key,
    required this.portfolio,
    required this.onTapProjects,
    required this.onTapContact,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDesktop = Responsive.isDesktop(context);
    final headlineStyle = isDesktop
        ? theme.textTheme.titleLarge
        : theme.textTheme.titleMedium;
    final nameStyle =
        (isDesktop ? theme.textTheme.displayLarge : theme.textTheme.displayMedium)
            ?.copyWith(height: 1.0);

    final avatarAsset = portfolio.avatarAsset;

    Widget buildTextColumn({required bool includeInlineAvatar}) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (portfolio.skills.isNotEmpty) ...[
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final skill in portfolio.skills.take(isDesktop ? 5 : 3))
                  _MiniPill(label: skill),
              ],
            ),
            const SizedBox(height: 16),
          ],
          if (includeInlineAvatar && avatarAsset != null) ...[
            Align(
              alignment: Alignment.center,
              child: _HeroAvatar(
                asset: avatarAsset,
                size: Responsive.isMobile(context) ? 150 : 190,
              ),
            ),
            const SizedBox(height: 18),
          ],
          _GradientText(
            portfolio.name,
            style: nameStyle ?? theme.textTheme.displayMedium!,
            colors: [scheme.primary, scheme.secondary],
          ),
          const SizedBox(height: 10),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 10,
            runSpacing: 6,
            children: [
              Text(
                portfolio.headline,
                style: headlineStyle,
              ),
              _Dot(color: theme.colorScheme.primary),
              Text(
                portfolio.location,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 14),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isDesktop ? 820 : double.infinity),
            child: Text(portfolio.summary, style: theme.textTheme.bodyLarge),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              PrimaryButton(
                label: 'View projects',
                icon: Icons.work_outline,
                onPressed: onTapProjects,
              ),
              if (portfolio.cvUrl case final cvUrl?)
                PrimaryButton(
                  label: 'Download CV',
                  icon: Icons.description_outlined,
                  outlined: true,
                  onPressed: () async {
                    final ok = await DownloadUtils.file(cvUrl);
                    if (!context.mounted || ok) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'CV file not found. Check assets/files and cvUrl in portfolio.json.',
                        ),
                      ),
                    );
                  },
                ),
              PrimaryButton(
                label: 'Contact',
                icon: Icons.mail_outline,
                outlined: true,
                onPressed: onTapContact,
              ),
              if (portfolio.contact.links.isNotEmpty) ...[
                const SizedBox(width: 4),
                for (final link in portfolio.contact.links.take(isDesktop ? 4 : 2))
                  _IconLink(label: link.label, url: link.url),
              ],
            ],
          ),
        ],
      );
    }

    return FadeSlideIn(
      beginOffset: const Offset(0, 0.04),
      child: (isDesktop && avatarAsset != null)
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: buildTextColumn(includeInlineAvatar: false)),
                const SizedBox(width: 26),
                _HeroAvatar(asset: avatarAsset, size: 260),
              ],
            )
          : buildTextColumn(includeInlineAvatar: true),
    );
  }
}

class _Dot extends StatelessWidget {
  final Color color;

  const _Dot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _MiniPill extends StatelessWidget {
  final String label;

  const _MiniPill({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return HoverScale(
      cursor: SystemMouseCursors.basic,
      scale: 1.05,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest.withAlpha((0.35 * 255).round()),
          border: Border.all(color: theme.dividerColor.withAlpha((0.90 * 255).round())),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          child: Text(label, style: theme.textTheme.labelLarge),
        ),
      ),
    );
  }
}

class _GradientText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final List<Color> colors;

  const _GradientText(
    this.text, {
    required this.style,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds);
      },
      child: Text(text, style: style.copyWith(color: Colors.white)),
    );
  }
}

class _IconLink extends StatelessWidget {
  final String label;
  final String url;

  const _IconLink({
    required this.label,
    required this.url,
  });

  IconData _iconFor(String label, String url) {
    final v = '${label.toLowerCase()} $url'.toLowerCase();
    if (v.contains('github')) return Icons.code;
    if (v.contains('linkedin')) return Icons.work_outline;
    if (v.contains('behance')) return Icons.brush_outlined;
    if (v.contains('dribbble')) return Icons.sports_basketball_outlined;
    if (v.contains('medium')) return Icons.article_outlined;
    if (v.contains('x.com') || v.contains('twitter')) return Icons.alternate_email;
    if (v.contains('youtube')) return Icons.play_circle_outline;
    if (v.contains('figma')) return Icons.design_services_outlined;
    if (v.contains('resume') || v.contains('cv')) return Icons.description_outlined;
    return Icons.link;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return HoverScale(
      cursor: SystemMouseCursors.click,
      scale: 1.06,
      child: Tooltip(
        message: label,
        child: InkWell(
          onTap: () => LaunchUtils.url(url),
          borderRadius: BorderRadius.circular(14),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest.withAlpha((0.20 * 255).round()),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: theme.dividerColor.withAlpha((0.90 * 255).round())),
            ),
            child: Icon(
              _iconFor(label, url),
              size: 18,
              color: theme.colorScheme.onSurface.withAlpha((0.90 * 255).round()),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroAvatar extends StatefulWidget {
  final String asset;
  final double size;

  const _HeroAvatar({
    required this.asset,
    required this.size,
  });

  @override
  State<_HeroAvatar> createState() => _HeroAvatarState();
}

class _HeroAvatarState extends State<_HeroAvatar> {
  bool _hovered = false;

  void _setHovered(bool value) {
    if (_hovered == value) return;
    setState(() => _hovered = value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final radius = widget.size * 0.20;
    final innerRadius = widget.size * 0.18;

    final glow = BoxShadow(
      color: scheme.primary.withAlpha(((_hovered ? 0.30 : 0.20) * 255).round()),
      blurRadius: _hovered ? 46 : 34,
      spreadRadius: -10,
      offset: Offset(0, _hovered ? 18 : 14),
    );

    final dropShadowAlpha =
        isDark ? (_hovered ? 0.34 : 0.24) : (_hovered ? 0.18 : 0.12);
    final drop = BoxShadow(
      color: Colors.black.withAlpha((dropShadowAlpha * 255).round()),
      blurRadius: _hovered ? 28 : 18,
      spreadRadius: -8,
      offset: Offset(0, _hovered ? 18 : 14),
    );

    final scale = _hovered ? 1.02 : 1.0;
    final lift = _hovered ? -4.0 : 0.0;
    final transform = Matrix4.translationValues(0.0, lift, 0.0)
      ..multiply(Matrix4.diagonal3Values(scale, scale, 1.0));

    final content = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      transform: transform,
      transformAlignment: Alignment.center,
      width: widget.size,
      height: widget.size,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            scheme.primary.withAlpha((0.90 * 255).round()),
            scheme.secondary.withAlpha((0.90 * 255).round()),
          ],
        ),
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [glow, drop],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(innerRadius),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              widget.asset,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest,
                  ),
                  child: Icon(
                    Icons.person_outline,
                    size: widget.size * 0.42,
                    color: scheme.onSurface.withAlpha((0.75 * 255).round()),
                  ),
                );
              },
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withAlpha(((isDark ? 0.22 : 0.14) * 255).round()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      child: content,
    );
  }
}
