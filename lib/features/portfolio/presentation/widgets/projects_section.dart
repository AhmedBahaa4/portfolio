import 'package:flutter/material.dart';

import '../../../../core/utils/launch.dart';
import '../../../../core/widgets/fade_slide_in.dart';
import '../../../../core/widgets/hover_scale.dart';
import '../../../../core/widgets/hover_surface.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/section_title.dart';
import '../../domain/entities/project.dart';

class ProjectsSection extends StatelessWidget {
  final List<Project> projects;

  const ProjectsSection({
    super.key,
    required this.projects,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FadeSlideIn(
          delay: Duration(milliseconds: 80),
          child: SectionTitle(
            title: 'Projects',
            subtitle: "Some things I've built recently.",
          ),
        ),
        const SizedBox(height: 16),
        if (projects.isEmpty)
          FadeSlideIn(
            delay: const Duration(milliseconds: 140),
            beginOffset: const Offset(0, 0.03),
            child: Text(
              'No projects yet. Update assets/data/portfolio.json to add your work.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          )
        else
          for (final (index, project) in projects.indexed)
            FadeSlideIn(
              delay: Duration(milliseconds: 140 + (index * 90)),
              beginOffset: const Offset(0, 0.03),
              child: _ProjectCard(project: project),
            ),
      ],
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final Project project;

  const _ProjectCard({required this.project});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: HoverSurface(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (project.imageAsset != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.asset(
                    project.imageAsset!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox.shrink(),
                  ),
                ),
              ),
              const SizedBox(height: 14),
            ],
            Text(project.title, style: theme.textTheme.titleLarge),
            const SizedBox(height: 6),
            Text(project.description, style: theme.textTheme.bodyMedium),
            if (project.tags.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final tag in project.tags) _Tag(tag),
                ],
              ),
            ],
            if (project.repoUrl != null || project.liveUrl != null) ...[
              const SizedBox(height: 14),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  if (project.liveUrl != null)
                    PrimaryButton(
                      label: 'Live',
                      icon: Icons.open_in_new,
                      onPressed: () => LaunchUtils.url(project.liveUrl!),
                    ),
                  if (project.repoUrl != null)
                    PrimaryButton(
                      label: 'Code',
                      icon: Icons.code,
                      outlined: true,
                      onPressed: () => LaunchUtils.url(project.repoUrl!),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;

  const _Tag(this.label);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return HoverScale(
      cursor: SystemMouseCursors.basic,
      scale: 1.06,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest
              .withAlpha((0.35 * 255).round()),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: theme.dividerColor.withAlpha((0.80 * 255).round())),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Text(label, style: theme.textTheme.labelLarge),
        ),
      ),
    );
  }
}
