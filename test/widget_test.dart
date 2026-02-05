import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio/app.dart';
import 'package:portfolio/core/widgets/section_title.dart';
import 'package:portfolio/features/portfolio/domain/entities/portfolio.dart';
import 'package:portfolio/features/portfolio/domain/entities/project.dart';
import 'package:portfolio/features/portfolio/domain/repositories/portfolio_repository.dart';

class _FakePortfolioRepository implements PortfolioRepository {
  @override
  Future<Portfolio> getPortfolio() async {
    return const Portfolio(
      name: 'Test',
      headline: 'Flutter Developer',
      location: 'Test City',
      summary: 'Test summary.',
      skills: ['Flutter', 'Dart'],
      experience: [
        ExperienceItem(
          company: 'Company',
          role: 'Role',
          period: '2024 — Present',
          highlights: ['Did something.'],
        ),
      ],
      projects: [
        Project(
          title: 'Project',
          description: 'Description',
          tags: ['Flutter'],
        ),
      ],
      contact: Contact(
        email: 'test@example.com',
        links: [ContactLink(label: 'GitHub', url: 'https://example.com')],
      ),
    );
  }
}

void main() {
  testWidgets('App loads HomePage content', (WidgetTester tester) async {
    await tester.pumpWidget(App(portfolioRepository: _FakePortfolioRepository()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.text('Projects'), findsOneWidget);
    expect(find.text('Skills'), findsOneWidget);
    expect(find.text('Experience'), findsOneWidget);
    expect(find.widgetWithText(SectionTitle, 'Contact'), findsOneWidget);
  });
}
