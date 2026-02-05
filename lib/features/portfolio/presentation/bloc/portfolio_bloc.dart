import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_portfolio.dart';
import 'portfolio_event.dart';
import 'portfolio_state.dart';

class PortfolioBloc extends Bloc<PortfolioEvent, PortfolioState> {
  final GetPortfolio _getPortfolio;

  PortfolioBloc(this._getPortfolio) : super(const PortfolioInitial()) {
    on<PortfolioRequested>(_onRequested);
  }

  Future<void> _onRequested(
    PortfolioRequested event,
    Emitter<PortfolioState> emit,
  ) async {
    emit(const PortfolioLoadInProgress());
    try {
      final portfolio = await _getPortfolio();
      emit(PortfolioLoadSuccess(portfolio));
    } catch (error, stackTrace) {
      debugPrint('Portfolio load failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      emit(PortfolioLoadFailure(_messageFor(error)));
    }
  }

  String _messageFor(Object error) {
    if (error is FlutterError) {
      if (error.message.toLowerCase().contains('asset')) {
        return 'Missing asset: assets/data/portfolio.json. Stop the app and run flutter clean, flutter pub get, then flutter run again.';
      }
      return error.message;
    }

    if (error is FormatException) {
      return 'Invalid portfolio.json: ${error.message}';
    }

    return 'Failed to load portfolio.';
  }
}
