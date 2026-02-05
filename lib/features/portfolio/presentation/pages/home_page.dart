import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/animated_background.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/entities/portfolio.dart';
import '../bloc/portfolio_bloc.dart';
import '../bloc/portfolio_event.dart';
import '../bloc/portfolio_state.dart';
import '../widgets/contact_section.dart';
import '../widgets/experience_section.dart';
import '../widgets/hero_header.dart';
import '../widgets/portfolio_app_bar.dart';
import '../widgets/projects_section.dart';
import '../widgets/skills_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _projectsKey = GlobalKey();
  final _skillsKey = GlobalKey();
  final _experienceKey = GlobalKey();
  final _contactKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  bool _scrolled = false;

  @override
  void initState() {
    super.initState();
    context.read<PortfolioBloc>().add(const PortfolioRequested());
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final next = _scrollController.hasClients && _scrollController.offset > 8;
    if (next == _scrolled) return;
    setState(() => _scrolled = next);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollTo(GlobalKey key) {
    final targetContext = key.currentContext;
    if (targetContext == null) return;
    Scrollable.ensureVisible(
      targetContext,
      duration: const Duration(milliseconds: 550),
      curve: Curves.easeOutCubic,
      alignment: 0.1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: PortfolioAppBar(
        scrolled: _scrolled,
        onTapProjects: () => _scrollTo(_projectsKey),
        onTapSkills: () => _scrollTo(_skillsKey),
        onTapExperience: () => _scrollTo(_experienceKey),
        onTapContact: () => _scrollTo(_contactKey),
      ),
      body: AnimatedBackground(
        child: SafeArea(
          top: false,
          child: BlocBuilder<PortfolioBloc, PortfolioState>(
            builder: (context, state) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 240),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                child: switch (state) {
                  PortfolioInitial() || PortfolioLoadInProgress() => const Center(
                      key: ValueKey('loading'),
                      child: SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(strokeWidth: 3),
                      ),
                    ),
                  PortfolioLoadFailure(:final message) => _ErrorView(
                      key: const ValueKey('error'),
                      message: message,
                      onRetry: () => context
                          .read<PortfolioBloc>()
                          .add(const PortfolioRequested()),
                    ),
                  PortfolioLoadSuccess(:final portfolio) => _Content(
                      key: const ValueKey('content'),
                      portfolio: portfolio,
                      controller: _scrollController,
                      projectsKey: _projectsKey,
                      skillsKey: _skillsKey,
                      experienceKey: _experienceKey,
                      contactKey: _contactKey,
                      onTapProjects: () => _scrollTo(_projectsKey),
                      onTapSkills: () => _scrollTo(_skillsKey),
                      onTapExperience: () => _scrollTo(_experienceKey),
                      onTapContact: () => _scrollTo(_contactKey),
                    ),
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final Portfolio portfolio;
  final ScrollController controller;
  final GlobalKey projectsKey;
  final GlobalKey skillsKey;
  final GlobalKey experienceKey;
  final GlobalKey contactKey;
  final VoidCallback onTapProjects;
  final VoidCallback onTapSkills;
  final VoidCallback onTapExperience;
  final VoidCallback onTapContact;

  const _Content({
    super.key,
    required this.portfolio,
    required this.controller,
    required this.projectsKey,
    required this.skillsKey,
    required this.experienceKey,
    required this.contactKey,
    required this.onTapProjects,
    required this.onTapSkills,
    required this.onTapExperience,
    required this.onTapContact,
  });

  @override
  Widget build(BuildContext context) {
    final padding = Responsive.pagePadding(context);
    final contentPadding = padding.copyWith(
      top: padding.top + PortfolioAppBar.height + 18,
    );

    return Scrollbar(
      controller: controller,
      thumbVisibility: Responsive.isDesktop(context),
      child: SelectionArea(
        child: SingleChildScrollView(
          controller: controller,
          child: Center(
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(maxWidth: Breakpoints.maxContentWidth),
              child: Padding(
                padding: contentPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeroHeader(
                      portfolio: portfolio,
                      onTapProjects: onTapProjects,
                      onTapContact: onTapContact,
                    ),
                    const SizedBox(height: 32),
                    ProjectsSection(key: projectsKey, projects: portfolio.projects),
                    const SizedBox(height: 32),
                    SkillsSection(key: skillsKey, skills: portfolio.skills),
                    const SizedBox(height: 32),
                    ExperienceSection(
                      key: experienceKey,
                      items: portfolio.experience,
                    ),
                    const SizedBox(height: 32),
                    ContactSection(key: contactKey, contact: portfolio.contact),
                    const SizedBox(height: 28),
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

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              PrimaryButton(label: 'Retry', onPressed: onRetry),
            ],
          ),
        ),
      ),
    );
  }
}
