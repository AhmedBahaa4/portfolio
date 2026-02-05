import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/download.dart';
import '../../../../core/utils/responsive.dart';
import '../bloc/portfolio_bloc.dart';
import '../bloc/portfolio_state.dart';

class PortfolioAppBar extends StatelessWidget implements PreferredSizeWidget {
  static const double height = 72;

  final bool scrolled;
  final VoidCallback onTapProjects;
  final VoidCallback onTapSkills;
  final VoidCallback onTapExperience;
  final VoidCallback onTapContact;

  const PortfolioAppBar({
    super.key,
    required this.scrolled,
    required this.onTapProjects,
    required this.onTapSkills,
    required this.onTapExperience,
    required this.onTapContact,
  });

  @override
  Size get preferredSize => const Size.fromHeight(height);

  void _openMenu(BuildContext context, {String? cvUrl}) {
    final theme = Theme.of(context);

    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: theme.cardTheme.color ?? theme.colorScheme.surface,
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (cvUrl != null)
                ListTile(
                  title: const Text('Download CV'),
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    DownloadUtils.file(cvUrl);
                  },
                ),
              ListTile(
                title: const Text('Projects'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  onTapProjects();
                },
              ),
              ListTile(
                title: const Text('Skills'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  onTapSkills();
                },
              ),
              ListTile(
                title: const Text('Experience'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  onTapExperience();
                },
              ),
              ListTile(
                title: const Text('Contact'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  onTapContact();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final state = context.watch<PortfolioBloc>().state;
    final title = switch (state) {
      PortfolioLoadSuccess(:final portfolio) => portfolio.name,
      _ => 'Portfolio',
    };
    final cvUrl = switch (state) {
      PortfolioLoadSuccess(:final portfolio) => portfolio.cvUrl,
      _ => null,
    };

    final backgroundColor =
        scrolled ? scheme.surface.withAlpha((0.72 * 255).round()) : Colors.transparent;
    final borderColor =
        scrolled ? theme.dividerColor.withAlpha((0.95 * 255).round()) : Colors.transparent;
    final blur = scrolled ? 14.0 : 0.0;

    return Material(
      color: Colors.transparent,
      child: ClipRect(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border(bottom: BorderSide(color: borderColor)),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _Brand(title: title),
                    const Spacer(),
                    if (Responsive.isDesktop(context))
                      Row(
                        children: [
                          _NavButton(label: 'Projects', onTap: onTapProjects),
                          _NavButton(label: 'Skills', onTap: onTapSkills),
                          _NavButton(
                            label: 'Experience',
                            onTap: onTapExperience,
                          ),
                          _NavButton(label: 'Contact', onTap: onTapContact),
                          if (cvUrl != null)
                            _NavButton(
                              label: 'CV',
                              onTap: () => DownloadUtils.file(cvUrl),
                            ),
                        ],
                      )
                    else
                      IconButton(
                        tooltip: 'Menu',
                        onPressed: () => _openMenu(context, cvUrl: cvUrl),
                        icon: const Icon(Icons.menu),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  final String title;

  const _Brand({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [scheme.primary, scheme.secondary],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}

class _NavButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _NavButton({
    required this.label,
    required this.onTap,
  });

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> {
  bool _hovered = false;

  void _setHovered(bool value) {
    if (_hovered == value) return;
    setState(() => _hovered = value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final foregroundColor = _hovered
        ? scheme.primary
        : theme.colorScheme.onSurface.withAlpha((0.92 * 255).round());
    final backgroundColor =
        _hovered ? scheme.primary.withAlpha((0.10 * 255).round()) : Colors.transparent;
    final borderColor =
        _hovered ? scheme.primary.withAlpha((0.25 * 255).round()) : Colors.transparent;

    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          onHover: _setHovered,
          borderRadius: BorderRadius.circular(999),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: borderColor),
            ),
            child: Text(
              widget.label,
              style: theme.textTheme.labelLarge?.copyWith(color: foregroundColor),
            ),
          ),
        ),
      ),
    );
  }
}
