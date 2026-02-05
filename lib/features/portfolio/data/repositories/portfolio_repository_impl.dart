import '../../domain/entities/portfolio.dart';
import '../../domain/repositories/portfolio_repository.dart';
import '../datasources/portfolio_local_datasource.dart';

class PortfolioRepositoryImpl implements PortfolioRepository {
  final PortfolioLocalDataSource _localDataSource;

  const PortfolioRepositoryImpl(this._localDataSource);

  @override
  Future<Portfolio> getPortfolio() async {
    final model = await _localDataSource.getPortfolio();
    return model.toDomain();
  }
}
