import '../entities/portfolio.dart';

abstract class PortfolioRepository {
  Future<Portfolio> getPortfolio();
}
