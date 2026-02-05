import 'package:flutter/material.dart';

import '../../../../core/widgets/fade_slide_in.dart';
import '../../../../core/widgets/section_title.dart';

class SkillsSection extends StatelessWidget {
  final List<String> skills;

  const SkillsSection({
    super.key,
    required this.skills,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FadeSlideIn(
          delay: Duration(milliseconds: 140),
          child: SectionTitle(
            title: 'Skills',
            subtitle: 'Technologies I work with.',
          ),
        ),
        const SizedBox(height: 16),
        if (skills.isEmpty)
          FadeSlideIn(
            delay: const Duration(milliseconds: 200),
            beginOffset: const Offset(0, 0.03),
            child: Text(
              'Add your skills in assets/data/portfolio.json.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          )
        else
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final (index, skill) in skills.indexed)
                FadeSlideIn(
                  delay: Duration(milliseconds: 200 + (index * 35)),
                  beginOffset: const Offset(0, 0.02),
                  child: _SkillChip(label: skill),
                ),
            ],
          ),
      ],
    );
  }
}

class _SkillChip extends StatefulWidget {
  final String label;

  const _SkillChip({required this.label});

  @override
  State<_SkillChip> createState() => _SkillChipState();
}

class _SkillChipState extends State<_SkillChip> {
  bool _hovered = false;

  void _setHovered(bool value) {
    if (_hovered == value) return;
    setState(() => _hovered = value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final backgroundColor = _hovered
        ? scheme.surfaceContainerHighest.withAlpha((0.35 * 255).round())
        : Colors.transparent;
    final borderColor = _hovered
        ? scheme.primary.withAlpha((0.65 * 255).round())
        : theme.dividerColor.withAlpha((0.95 * 255).round());

    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: (_) => _setHovered(true),
      onExit: (_) => _setHovered(false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        scale: _hovered ? 1.05 : 1.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Text(widget.label, style: theme.textTheme.labelLarge),
          ),
        ),
      ),
    );
  }
}
