import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/api_keys.dart';

/// Service for fetching stock market data using the Alpha Vantage API.
///
/// Retrieves stock trends including top gainers and losers, market data,
/// intraday quotes, and historical pricing. Integrates with Alpha Vantage's
/// free tier API to provide up-to-date financial information.
class StockApiService {
  // Using Alpha Vantage API (free tier available)
  static const String _baseUrl = 'https://www.alphavantage.co/query';
  static final String _apiKey = ApiKeys.alphaVantageApiKey;

  /// Fetch top gainers/losers from market data
  /// Returns a list of stock data (symbol, price, change %, etc.)
  static Future<List<Map<String, dynamic>>> fetchTopGainers() async {
    try {
      final params = {
        'function': 'TOP_GAINERS_LOSERS',
        'apikey': _apiKey,
      };

      final uri = Uri.parse(_baseUrl).replace(queryParameters: params);
      final response = await http.get(uri).timeout(
            const Duration(seconds: 15),
            onTimeout: () => throw Exception('Stock API request timed out'),
          );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final topGainers = data['top_gainers'] as List<dynamic>? ?? [];

        return topGainers.map((stock) {
          return {
            'symbol': stock['ticker'] ?? 'UNKNOWN',
            'price': stock['price'] ?? '0.00',
            'changeAmount': stock['change_amount'] ?? '0.00',
            'changePercentage': stock['change_percentage'] ?? '0.00%',
            'volume': stock['volume'] ?? '0',
          };
        }).toList();
      } else {
        throw Exception('Failed to fetch top gainers: ${response.statusCode}');
      }
    } catch (e) {
      // ignore: avoid_print
      print('StockApiService.fetchTopGainers error: $e');
      rethrow;
    }
  }

  /// Fetch stock quote for a specific symbol
  static Future<Map<String, dynamic>> getStockQuote(String symbol) async {
    try {
      final params = {
        'function': 'GLOBAL_QUOTE',
        'symbol': symbol.toUpperCase(),
        'apikey': _apiKey,
      };

      final uri = Uri.parse(_baseUrl).replace(queryParameters: params);
      final response = await http.get(uri).timeout(
            const Duration(seconds: 15),
            onTimeout: () => throw Exception('Stock API request timed out'),
          );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final quote = data['Global Quote'] ?? {};

        if (quote.isEmpty) {
          throw Exception('Symbol not found: $symbol');
        }

        return {
          'symbol': quote['01. symbol'] ?? symbol,
          'price': quote['05. price'] ?? '0.00',
          'change': quote['09. change'] ?? '0.00',
          'changePercent': quote['10. change percent'] ?? '0.00%',
          'volume': quote['06. volume'] ?? '0',
          'timestamp': DateTime.now().toIso8601String(),
        };
      } else {
        throw Exception('Failed to get stock quote: ${response.statusCode}');
      }
    } catch (e) {
      // ignore: avoid_print
      print('StockApiService.getStockQuote error: $e');
      rethrow;
    }
  }

  /// Fetch intraday time series for a stock
  static Future<List<Map<String, dynamic>>> getIntradayTimeSeries(
    String symbol, {
    String interval = '5min',
  }) async {
    try {
      final params = {
        'function': 'TIME_SERIES_INTRADAY',
        'symbol': symbol.toUpperCase(),
        'interval': interval,
        'apikey': _apiKey,
      };

      final uri = Uri.parse(_baseUrl).replace(queryParameters: params);
      final response = await http.get(uri).timeout(
            const Duration(seconds: 15),
            onTimeout: () => throw Exception('Stock API request timed out'),
          );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final timeSeries =
            data['Time Series ($interval)'] as Map<String, dynamic>? ?? {};

        return timeSeries.entries.map((entry) {
          final timeStr = entry.key;
          final prices = entry.value;

          return {
            'timestamp': timeStr,
            'open': prices['1. open'] ?? '0.00',
            'high': prices['2. high'] ?? '0.00',
            'low': prices['3. low'] ?? '0.00',
            'close': prices['4. close'] ?? '0.00',
            'volume': prices['5. volume'] ?? '0',
          };
        }).toList();
      } else {
        throw Exception('Failed to get intraday data: ${response.statusCode}');
      }
    } catch (e) {
      // ignore: avoid_print
      print('StockApiService.getIntradayTimeSeries error: $e');
      rethrow;
    }
  }
}
