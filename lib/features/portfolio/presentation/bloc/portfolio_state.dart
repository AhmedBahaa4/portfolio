import 'package:equatable/equatable.dart';

import '../../domain/entities/portfolio.dart';

sealed class PortfolioState extends Equatable {
  const PortfolioState();

  @override
  List<Object?> get props => [];
}

final class PortfolioInitial extends PortfolioState {
  const PortfolioInitial();
}

final class PortfolioLoadInProgress extends PortfolioState {
  const PortfolioLoadInProgress();
}

final class PortfolioLoadSuccess extends PortfolioState {
  final Portfolio portfolio;

  const PortfolioLoadSuccess(this.portfolio);

  @override
  List<Object?> get props => [portfolio];
}

final class PortfolioLoadFailure extends PortfolioState {
  final String message;

  const PortfolioLoadFailure(this.message);

  @override
  List<Object?> get props => [message];
}
