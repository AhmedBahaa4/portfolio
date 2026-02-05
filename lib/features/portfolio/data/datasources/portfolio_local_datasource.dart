import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../models/portfolio_model.dart';

abstract class PortfolioLocalDataSource {
  Future<PortfolioModel> getPortfolio();
}

class PortfolioLocalDataSourceImpl implements PortfolioLocalDataSource {
  final AssetBundle _bundle;
  final String assetPath;

  PortfolioLocalDataSourceImpl({
    AssetBundle? bundle,
    this.assetPath = 'assets/data/portfolio.json',
  }) : _bundle = bundle ?? rootBundle;

  @override
  Future<PortfolioModel> getPortfolio() async {
    final raw = await _loadJson();
    final json = jsonDecode(raw);
    if (json is! Map<String, dynamic>) {
      throw const FormatException('portfolio.json must be a JSON object');
    }
    return PortfolioModel.fromJson(json);
  }

  Future<String> _loadJson() async {
    try {
      return await _bundle.loadString(assetPath);
    } catch (_) {
      if (!kIsWeb) rethrow;

      // On Flutter Web, the engine typically fetches assets from `/assets/<key>`.
      // Some development setups can end up with an extra `assets/` prefix, which
      // makes requests like `assets/assets/...` return 404. This fallback tries
      // to fetch the asset directly from the web server.
      final networkBundle = NetworkAssetBundle(Uri.base);
      return networkBundle.loadString(assetPath);
    }
  }
}
