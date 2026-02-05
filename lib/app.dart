import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'features/portfolio/data/datasources/portfolio_local_datasource.dart';
import 'features/portfolio/data/repositories/portfolio_repository_impl.dart';
import 'features/portfolio/domain/repositories/portfolio_repository.dart';
import 'features/portfolio/domain/usecases/get_portfolio.dart';
import 'features/portfolio/presentation/bloc/portfolio_bloc.dart';
import 'features/portfolio/presentation/pages/home_page.dart';

class App extends StatelessWidget {
  final PortfolioRepository portfolioRepository;
  final GoRouter _router;

  App({
    super.key,
    PortfolioRepository? portfolioRepository,
  })  : portfolioRepository = portfolioRepository ??
            PortfolioRepositoryImpl(PortfolioLocalDataSourceImpl()),
        _router = GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const HomePage(),
            ),
          ],
        );

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: portfolioRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ThemeCubit()),
          BlocProvider(
            create: (_) => PortfolioBloc(GetPortfolio(portfolioRepository)),
          ),
        ],
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, mode) {
            return MaterialApp.router(
              title: 'Ahmed Bahaa',
              theme: AppTheme.light(),
              darkTheme: AppTheme.dark(),
              themeMode: mode,
              routerConfig: _router,
              debugShowCheckedModeBanner: false,
            );
          },
        ),
      ),
    );
  }
}
