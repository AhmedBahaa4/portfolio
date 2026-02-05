import 'package:flutter/material.dart';

import '../../../../core/utils/launch.dart';
import '../../../../core/widgets/fade_slide_in.dart';
import '../../../../core/widgets/hover_surface.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/section_title.dart';
import '../../domain/entities/portfolio.dart';

class ContactSection extends StatelessWidget {
  final Contact contact;

  const ContactSection({
    super.key,
    required this.contact,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FadeSlideIn(
          delay: Duration(milliseconds: 260),
          child: SectionTitle(
            title: 'Contact',
            subtitle: "Let's build something together.",
          ),
        ),
        const SizedBox(height: 16),
        FadeSlideIn(
          delay: const Duration(milliseconds: 320),
          beginOffset: const Offset(0, 0.03),
          child: HoverSurface(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.mail_outline,
                      color: theme.colorScheme.onSurface.withAlpha((0.90 * 255).round()),
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        contact.email,
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    const SizedBox(width: 0),
                    FadeSlideIn(
                      delay: const Duration(milliseconds: 380),
                      beginOffset: const Offset(0, 0.02),
                      child: PrimaryButton(
                        label: 'Email',
                        icon: Icons.email_outlined,
                        onPressed: () => LaunchUtils.email(contact.email),
                      ),
                    ),
                    if (contact.phone != null)
                      FadeSlideIn(
                        delay: const Duration(milliseconds: 430),
                        beginOffset: const Offset(0, 0.02),
                        child: PrimaryButton(
                          label: 'Call',
                          icon: Icons.call_outlined,
                          outlined: true,
                          onPressed: () => LaunchUtils.url('tel:${contact.phone}'),
                        ),
                      ),
                    for (final (index, link) in contact.links.indexed)
                      FadeSlideIn(
                        delay: Duration(milliseconds: 430 + (index * 45)),
                        beginOffset: const Offset(0, 0.02),
                        child: PrimaryButton(
                          label: link.label,
                          icon: Icons.open_in_new,
                          outlined: true,
                          onPressed: () => LaunchUtils.url(link.url),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
