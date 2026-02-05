import '../entities/portfolio.dart';
import '../repositories/portfolio_repository.dart';

class GetPortfolio {
  final PortfolioRepository _repository;

  const GetPortfolio(this._repository);

  Future<Portfolio> call() => _repository.getPortfolio();
}
