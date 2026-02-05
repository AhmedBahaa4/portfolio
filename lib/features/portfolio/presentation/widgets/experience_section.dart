import 'package:flutter/material.dart';

import '../../../../core/widgets/fade_slide_in.dart';
import '../../../../core/widgets/hover_surface.dart';
import '../../../../core/widgets/section_title.dart';
import '../../domain/entities/portfolio.dart';

class ExperienceSection extends StatelessWidget {
  final List<ExperienceItem> items;

  const ExperienceSection({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FadeSlideIn(
          delay: Duration(milliseconds: 200),
          child: SectionTitle(
            title: 'Experience',
            subtitle: "Where I've worked and what I did.",
          ),
        ),
        const SizedBox(height: 16),
        if (items.isEmpty)
          FadeSlideIn(
            delay: const Duration(milliseconds: 260),
            beginOffset: const Offset(0, 0.03),
            child: Text(
              'Add your experience in assets/data/portfolio.json.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          )
        else
          for (final (index, item) in items.indexed)
            FadeSlideIn(
              delay: Duration(milliseconds: 260 + (index * 90)),
              beginOffset: const Offset(0, 0.03),
              child: _ExperienceCard(item: item),
            ),
      ],
    );
  }
}

class _ExperienceCard extends StatelessWidget {
  final ExperienceItem item;

  const _ExperienceCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: HoverSurface(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 10,
              runSpacing: 6,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(item.role, style: theme.textTheme.titleLarge),
                Text('\u2022', style: theme.textTheme.bodyMedium),
                Text(item.company, style: theme.textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 6),
            Text(item.period, style: theme.textTheme.bodyMedium),
            if (item.highlights.isNotEmpty) ...[
              const SizedBox(height: 12),
              for (final h in item.highlights)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('\u2022 '),
                      Expanded(child: Text(h, style: theme.textTheme.bodyMedium)),
                    ],
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
